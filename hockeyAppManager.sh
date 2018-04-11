#!/bin/bash

# BIG TO DO
#  CAMEL CASE EVERYTHING AND CAPS ALL GLOBAL VARIABLES
#  Make sure to also note how each function returns output based on input
#  install dependencies function needs to run before anything
#  make sure to have a quick messgae to display informing me that somehting is being pulled down
#  if there are 2 versions that are exactly the same, give the user an option to download the one of their choosing
#  display notes in the process

# ====== GLOBAL VARIABLES ======= #
readonly PROGNAME=$(basename $0)
readonly ACCESS_TOKEN=$HOCKEYTOKEN
readonly VALID_COMMANDS=("download", "list", "list-version")


function fauxcache(){
	# TODO:
	# - find a way to add a custom JSON object in to the JQ made array.
	# {"date_cached" : "todays date"} <= something along this line
	curl -s -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps | jq '[.["apps"][] | {"title": .title, "platform": .platform, "public_ID": .public_identifier, "package_name": .bundle_identifier}]' > ~/fauxcache.json
}

function list_out_apps(){
	# for curl requests
	local search_item=$1

	# catches empty conditions and immediately exits after showing full list
	if [[ -z "$1" ]]; then
		echo "list of all apps displayed below"
		curl -s -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps | jq '.["apps"][] | .title +" : "+ .platform'
		echo "end of list"
		return 0;
	else
		case "$1" in

			# ideally i would like to just remove the ios one and add an or statement, but not sure how to do that in case
			"Android" )
				echo "List of all apps under $search_item platform"
				curl -s -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps | jq --arg search_item "$search_item" '.["apps"][] | select(.platform==$search_item) | .title '	
			;;
			"iOS" )
				echo "List of all apps under $search_item platform"
				curl -s -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps | jq --arg search_item "$search_item" '.["apps"][] | select(.platform==$search_item) | .title '	
			;;

			# For any other case its going to just make a curl request and find items
			* )
				#  BIG TO DO!!!!
				#  NEED TO USE REGEX IN THE CURL REQUEST TO DISPLAY ALL APPS WITH SPECIFIC NAMES
				echo "List of all apps with the name: $search_item"
				curl -s -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps | jq --arg search_item "$search_item" '.["apps"][] | select(.title==$search_item) | .title + " : " + .platform'
				echo "end of list"
			;;
		esac

	fi	 
}

function list_out_versions(){

	local publicID=$1
	echo "list of all versions available"
	curl -s -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps/"$publicID"/app_versions | jq '.["app_versions"][] | "version_number : " + .version '

}

function download_app(){

	#  MUST ACCEPT 5 PARAMS
	# Param 1 is for app_name
	# Param 2 is for appVersion
	# Param 3 is for platformInstallable
	# Param 4 is for downloadLink

	# need to remove the spacing and the escaping characters for names
	curl -o ~/Downloads/"$1_$2.$3" -L "$4"
}

# something i need to incorporate later
function delete_apps(){

	while read files ; do
		echo "file : $files"
		if [[ "$files" = "$app_package_name" ]]; then
			rm -rf ~/Downloads/$files
		fi
	
	done <<< "$(ls ~/Downloads)"
}

function validate_platform_name(){

	local platform_name=$1

	if [[ -z "$platform_name" ]]; then
		echo "no platform name was given"; usage ; exit 1
	else
		if [[ "$platform_name" == "Android" || "$platform_name" == "iOS" ]]; then
			(return 0)
		else		
			echo "invalid platform was given"; usage ; exit 2
		fi	

	fi
}

function validate_type(){
	# MUST be passed version or name for the first item
	# MUST be passed the app name or version number after
	# example usage = validate_type  appnumber appid || validate_type name "app name"

	local validate_type=$1
	local defaultReturnCode=
	local data_to_validate=
	local public_identifier=$3
	
	case "$validate_type" in
		"version" )
			let defaultReturnCode=6
			data_to_validate="$(curl -s -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps/$public_identifier/app_versions | jq '.["app_versions"][] | .version '	)"
		;;
		"name" )
			let defaultReturnCode=4
			data_to_validate="$(jq '.[] | .title' ~/fauxcache.json)"
		;;
	esac

	# conditional to check if 
	if [[ -z "$2" && -z "$3" && "$validate_type" = "version" ]]; then
		# if the condition was empty
		echo "no $validate_type was given"; usage ; exit 5
	elif [[ -z "$2" && "$validate_type" = "name" ]]; then
		# if the condition was empty
		echo "no $validate_type was given"; usage ; exit 3
	else	
		while read data_type ; do

			# if the string doesn't match then spit out error else pass
			modifiedString="$(clear_quotes "$data_type")"
			if [[ "$2" = "$modifiedString" ]]; then
				let defaultReturnCode=0
				break
			fi
		done <<< "$data_to_validate" #need to modify the loop to consume the correct data instead
		
		# need to make the error code cases more specific
		if [[ "$defaultReturnCode" -eq 4 || "$defaultReturnCode" -eq 6 ]]; then
			echo "data that was provided was invalid EC: $defaultReturnCode"
			usage
		fi
	
		return $defaultReturnCode

	fi
}

# TO DO!
function install_dependencies(){
	echo "logic to download all bash tools"
}

# TO DO!
function check_for_cache(){
	echo "logic to check for cached json here!"
}

function clear_quotes(){
	local data_type=$1
	
	formatted_text="${data_type%\"}"
	formatted_text="${formatted_text#\"}"
	# need to return a string here, so it can be bound to other variables later

	# returns the text back
	# function should only be used to populate variable data with a subshell?
	echo "$formatted_text"
}

function usage(){
	cat <<-EOF 
		======== Hockey App Manager ========

		$PROGNAME -- Hockey App Download script

		Usage
		=====
		$PROGNAME <command> <platform> <app_name> <version>

		command -- list of all commands => (${VALID_COMMANDS[@]})
		platform -- list of all Platforms => (Android, iOS)
		app_name -- The list of valid app names will be provided by using the list-all command


		return codes
		------------
		0 => Command was successful
		1 => no platform name was given
		2 => platform name was invalid
		3 => no app name was given
		4 => app name was invalid
		5 => no version was given
		6 => version was invalid
		7 => generic data was invalid

		======== Hockey App Manager ========
	EOF
}


function main (){

	# ==== local variables ==== #
	local app_name=$3
	local platform_name=$2
	local version=$4
	local pubID= #variable is set later on
	local ipa_or_apk= #variable is set later on in the install command
	local download_url= #variable is set later on in the install command
	local package_name= #variable is set later on in the install command
	# ==== local variables ==== #

	# download/writes a re-usable JSON file
	# need to run the faux cache function when a valid argument is passed should make a simpler check
	fauxcache

	case "$1" in

		"list" )
			list_out_apps "$2"
		;;

		"list-version" )
			# for this command $2 value MUST BE A PLATFORM
			# for this command $3 value MUST BE A NAME OF THE ANDROID APP
			
			# checks to make sure both the name and platform are valid
			validate_platform_name "$2"
			validate_type "name" "$3"
			
			# sets the public_id to a variable and removes the quotes so it can be used
			pubID="$(jq --arg app_name "$app_name" --arg platform_name "$platform_name" '.[] | select(.title==$app_name) + select(.platform==$platform_name) | .public_ID' ~/fauxcache.json)"
			pubID="$(clear_quotes $pubID)"

			list_out_versions "$pubID"
		;;

		"download" )
			# sets the public id based on app name + platform name
			pubID="$(jq --arg app_name "$app_name" --arg platform_name "$platform_name" '.[] | select(.title==$app_name) + select(.platform==$platform_name) | .public_ID' ~/fauxcache.json)"
			pubID="$(clear_quotes $pubID)"
			package_name="$(jq --arg app_name "$app_name" --arg platform_name "$platform_name" '.[] | select(.title==$app_name) + select(.platform==$platform_name) | .package_name' ~/fauxcache.json)"
			package_name="$(clear_quotes $package_name)"

			validate_platform_name "$2"
			validate_type "name" "$3"
			validate_type "version" "$4" "$pubID"

			if [[ "$platform_name" = "Android" ]]; then
				ipa_or_apk="apk"
			else
				ipa_or_apk="ipa"
			fi

			
			# creates the last build downloaded.json (for debugging reasons in the near future)
			curl -H "X-HockeyAppToken: $ACCESS_TOKEN" https://rink.hockeyapp.net/api/2/apps/"$pubID"/app_versions?include_build_urls=true | jq --arg version "$version" '[.["app_versions"][] | select(.version==$version) | {title, notes, version, "downloadLink": .build_url}]' > ~/buildToDownload.json
			
			buildCount=0
			# if the second item is available display options and download based on userinput
			# else download the first item available in the generated json
			if [[ "$(jq '.[1] | .notes' ~/buildToDownload.json)" != null ]]; then
				clear
				echo "=== List of builds available for download ==="

				while read jsonData ; do
					echo "option $((buildCount++)):"
					echo "$jsonData"
					echo ""
				done <<< "$(jq '.[] | .notes' ~/buildToDownload.json)"

				echo "=== which Build option do you choose? ==="
				echo "=== accepted input would be 1, 2, 3, or 4.... ==="
				echo "=== Note: invalid input will exit the script and throw an error ==="
				read choice

				# tonumber cases the argument in to a number...... --ARG is always a string being passed......
				download_url="$(jq --arg choice "$choice" '.[$choice | tonumber] | .downloadLink' ~/buildToDownload.json)"
				
				# TODO need to write a regular expression that checks the notes string and pull the QA or prod name
				# and make the app name = that instead
				# need to move the appname space modifier to the else condition below.

			else
				download_url="$(jq '.[0] | .downloadLink' ~/buildToDownload.json)"
			fi
			
			download_url="$(clear_quotes "$download_url")"
			app_name="${app_name// /_}" #modifies the spaces in to underscores mainly for android apps
			download_app "$app_name" "$4" "$ipa_or_apk" "$download_url"
		;;

		* )
			if [[ -z "$1" ]]; then
				usage
			else
				echo "option was not recognized. Look at the Usage notes below and use onf of the following commands!"
				echo ""
				usage
				exit 7
			fi
		;;
	esac

	# PARAMS needed to pass
	# $1 - option passed
	# $2 - platform, app_name, bundle name
	# $3 - name of the app if they are using install
	# $4 - specific version the user wants
	# use an array to store the values i need to validate against and just use a ternary operator

}

# accepting them as strings to avoid issues?
main "$1" "$2" "$3" "$4"

