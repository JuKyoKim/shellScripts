#!/bin/bash



readonly PROGNAME=$(basename $0)

# Update this array to find all the content types allowed for whatever app
readonly VALID_TYPES=("networkvideo" "videos")

# need to remove this validation from the script since this is no longer needed, 
# either that or i need to find a way to curl and check if this is a valid ID for each content
readonly VALID_UUID=^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$

# remove these since tehy are no longer valid
readonly VALID_SCHEMES=("http" "pgatourlive" "wwe")

# need to modify to accept HBO, WWE, and other apps as the value
readonly VALID_HOSTS=("pgatourlive" "wwe")

# modify to have the new app package names
readonly VALID_PACKAGES=("com.wwe.universe" "com.pgatourlive.pga")

array_contains() {
	local array="$1[@]"
	local seeking=$2
	local in=1
	for element in "${!array}"; do
		if [[ "$element" == "$seeking" ]]; then
		    in=0
		    break
		fi
	done
	return $in
}

usage() {
	cat <<-EOF 
	$PROGNAME -- Deeplink Test Script

	usage
	-----
	$PROGNAME type uuid scheme <host> <package> <--print>

	    type    -- one of (${VALID_TYPES[@]})
	    uuid    -- a valid UUID per RFC4122
	    scheme  -- one of (${VALID_SCHEMES[@]})
	    host    -- one of (${VALID_HOSTS[@]}), required for http and android-app scheme or --print
	    package -- one of (${VALID_PACKAGES[@]}), required for android-app scheme or --print
	    --print -- Do not send intent, but print off each possible intent


	return codes
	------------
	0 -- Program Exited Successfully.  Intent should start on connected device.
	1 -- Program Exited failing type validation
	2 -- Program Exited failing uuid validation
	3 -- Program Exited failing scheme validation
	4 -- Program Exited failing host validation
	5 -- Program Exited failing package validation
	EOF
}

validateType() {
	local contentType=$1
	array_contains VALID_TYPES $contentType && return 0 || echo "Bad Type: $contentType"; usage; exit 1
}

validateUUID() {
	local contentUUID=$1
	if ! [[ "$contentUUID" =~ $VALID_UUID ]]; then
	    echo "Bad UUID: $contentUUID"
		usage
		exit 2
	fi
}

validateScheme() {
    local scheme=$1
    array_contains VALID_SCHEMES $scheme && return 0 || echo "Bad Scheme: $contentScheme"; usage; exit 3
}

validateHost() {
    local host=$1
    array_contains VALID_HOSTS $host && return 0 || echo "Bad Host: $host"; usage; exit 4
}

validatePackage() {
    local package=$1
    array_contains VALID_PACKAGES $package && return 0 || echo "Bad Package: $package"; usage; exit 5
}

sendIntent() {

    local contentType=$1
    local contentUUID=$2
    local scheme=$3
    local host=$4
    local package=$5

    if [[ "$scheme" == "http" ]]; then
        sendHttpIntent $contentType $contentUUID $host
    elif [[ "$scheme" == "android-app" ]]; then
        sendAndroidAppIntent $contentType $contentUUID $host $package
    else
        sendNickAppIntent $contentType $contentUUID $scheme
    fi

}

printIntents() {

   local contentType=$1
   local contentUUID=$2
   local scheme=$3
   local host=$4
   local package=$5

   echo "http://www.$host.com/$contentType/$contentUUID?type=$contentType&itemId=$contentUUID&xrs=test_token"
   echo "$scheme://$contentType/$contentUUID?type=$contentType&itemId=$contentUUID&xrs=test_token"
   echo "android-app://$package/http/www.$host.com/$contentType/$contentUUID?type=$contentType&itemId=$contentUUID&xrs=test_token"
}

sendHttpIntent() {

	local contentType=$1
	local contentUUID=$2

	adb shell am start -a android.intent.action.VIEW -d "http://www.$host.com/$contentType/$contentUUID?type=$contentType\&itemId=$contentUUID\&xrs=test_token"
}


sendNickAppIntent() {

	local contentType=$1
	local contentUUID=$2
	local scheme=$3

	adb shell am start -a android.intent.action.VIEW -d "$scheme://$contentType/$contentUUID?type=$contentType\&itemId=$contentUUID\&xrs=test_token"
}

sendAndroidAppIntent() {

    local contentType=$1
    local contentUUID=$2
    local host=$3
    local package=$4

    adb shell am start -a android.intent.action.VIEW -d "android-app://$package/http/www.$host.com/$contentType/$contentUUID?type=$contentType\&itemId=$contentUUID\&xrs=test_token"

}

main() {

	local contentType=$1
	local contentUUID=$2
    local scheme=$3
    local host=$4
    local package=$5
    local print=$6

	validateType $contentType
	validateUUID $contentUUID
    validateScheme $scheme

    if [[ "$scheme" == "http" ]]; then
        validateHost $host
    elif [[ "$scheme" == "android-app" || "$print" == "--print" ]]; then
        validateHost $host
        validatePackage $package
    fi

    if [[ "$print" == "--print" ]]; then
        printIntents $contentType $contentUUID $scheme $host $package
    else
        sendIntent $contentType $contentUUID $scheme $host $package
    fi
}

main $1 $2 $3 $4 $5 $6