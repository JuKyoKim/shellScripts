#!/bin/bash
# ===========global variabls===========
ARRAY_OF_BREW_PACKAGE=()
ARRAY_OF_NPM_PACKAGE=()
readonly PROGNAME=$(basename $0)
readonly ARRAY_OF_DEP_MANAGE=( "npm" "brew" )
readonly ARRAY_OF_COMMAND=("-c" "-g" "-i" "-u")
# ===========Generic Utility===========

function beautifyWithJQ(){
	# MUST ACCEPT A PATHING
	# pumping the output of OG ugly json to JQ
	# store it in a variable
	# print the output in to json file again
	echo "beautifing JSON file $1"
	beautifiedJSON="$(jq '.' $1)"
	echo "$beautifiedJSON" > "$1"
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

# Something to make my code leaner? for now im going to leave this here
function checkDepManInstalled(){
	# - Param 1 should accept the dependency name
	# - Param 2 should accept the expected path it should appear
	# Print false or true depending on if something was correctly returned?

	whichDependencyOutput="$(which $1)"
	# if the path doesn't match the second param
	if [[ "$whichDependencyOutput" != "$2" ]]; then
		echo false
	else
		echo true
	fi
}

function clearCurrentTerminalSession(){
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
}

function usage(){
	cat <<-EOF
		========= Dependency Manager =========

		NAME
		----
		$PROGNAME -- Dependency Manager Shell Script

		USAGE
		-----
		$PROGNAME <command> <managerType> <JsonFilePathing>

		<command> - List of all available commands => (${ARRAY_OF_COMMAND[@]})
		<managerType> - List of all supported Dependency Managers =>(${ARRAY_OF_DEP_MANAGE[@]})
		<JsonFilePathing> - This is an optional field!
		                  - IF specified the pathing should contain '.json' at the end
		                  - IF the pathing doesn't get specified it will default to desktop with generic name!
		                  - IF the pathing is wrong (doesn't contain .json) it will default to desktop with generic name!

		COMMAND INFO
		-----------
		-c  Checks to see if dependency manager is installed
		-g  Generates a json file containing the packages installed under whichever manager.
		-i  Install packages under whatever JSON file was passed. 
		    IF the package is already installed it will skip and move to the next item
		-u  update all packages under whatever dependency manager (Its always to latest stable).

		RETURN CODES
		------------
		0 => script ran successfully with valid data
		1 => command given was null, invalid, or unrecognized
		2 => managerType was null, invalid, or unrecognized
		3 => pathing did not include '.json' at the end 
		     (this might get auto handled with default logic)

		========= Dependency Manager =========
	EOF
}

function validateNullData(){
	# accepts 2 items
	# - first item is data to be checked
	# - second item is the return code if item is not available
	if [[ -z $1 ]]; then
		echo $2
	else
		echo 0
	fi
}

function validateInvalidData(){
	# accepts 3 items
	# - first item should be the item in question
	# - second item should be an array of expected outputs
	# -- WHEN PASSING THE SECOND ITEM IT needs to be echo-ed in
	# - third item should be the return code returned

	# EXAMPLE: validateInvalidData "npm" "$(echo ${ARRAY_OF_DEP_MANAGE[@]})" "2"

	# unpack the array from param to variable
	tempArray=( "$2" )
	matched=false

	# for loop through the array
	for item in $tempArray; do
		if [[ $1 == $item ]]; then
			matched=true
		fi
	done

	# at the end of the for loop do a conditional check IF item match return 0 else return the error code
	if [[ $matched == true ]]; then
		echo 0
	else
		echo $3
	fi

}

function validateJsonIncludedInPath(){
	# accepts 2 items
	# - first item should be the item in question
	# - second item should be the error code returned if the item doesnt contain .json

	# - if the pathing doesnt contain .json at the end
	if [[ $1 =~ \.json$ ]]; then
		echo 0
	else
		echo $2
	fi
}

# ==========HomeBrew Management==========
# Check to see if homebrew is installed

function checkHomeBrewInstalled(){
	# check to see if which brew outputs the correct install location
	
	brewInstalled="$(checkDepManInstalled brew "/usr/local/bin/brew")"
	if [[ $brewInstalled == false ]]; then
		cd $HOME
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "homebrew is installed on your system already"
		echo "Version: $(brew --version)"
	fi
}

# pushes up brew list in to global array
function pushUpBrewListToArray(){
	while read line 
	do
		ARRAY_OF_BREW_PACKAGE+=("$line")
	done <<< "$(brew list)"
}

# Update and upgrade all brew packages already installed
function updateAllBrewPackages(){
	brew update
	brew upgrade
}

# Install brew packages based on whatever JSON file is passed
function installAllBrewPackages(){
	pushUpBrewListToArray
	# while loop over the json doc thats passed
	while read line; do
		found=false
		formatLineText="$(clear_quotes $line)"
		# compare each item against whatever is pulled from brew list command
		for brewPackageName in "${ARRAY_OF_BREW_PACKAGE[@]}"; do
			
			# if formula is found set to true, and discontinue nested loop
			if [[ "$formatLineText" == "$brewPackageName" ]]; then
				found=true
				break
			fi
		done

		# if item is not found then start installing the formula
		if [[ "$found" == false ]]; then
			echo "$formatLineText formula was not found installed in machine"
			echo "starting brew install $formatLineText"
			brew install $formatLineText
		fi
		# piping the JSON data to avoid subshell issues
	done <<< "$(jq '.brewPackages[]' $1)"
}

# Generates a JSON file with list of package names (json file should be beautified)
function generateBrewPackageList(){
	# MUST ACCEPT A PATHING AS ONE ARG

	# push the brew list output in to an array
	pushUpBrewListToArray
	totalCount="${#ARRAY_OF_BREW_PACKAGE[@]}"
	
	# pip echo output to json file
	echo "{" > $1
	echo '"brewPackages":[' >> $1
	count=1
	
	# for each item in array
	for brewPackageName in "${ARRAY_OF_BREW_PACKAGE[@]}"; do
		# if condition to not add a comma at the end
		stringToOutPut=
		if [[ "$count" != "$totalCount" ]]; then
			stringToOutPut="\"$brewPackageName\","
		else
			stringToOutPut="\"$brewPackageName\""
		fi

		echo "$stringToOutPut" >> $1
		let count=count+1
	done
	
	echo ']' >> $1
	echo "}" >> $1
	beautifyWithJQ "$1"
}

# ==========NPM + Node.js Management==========

# pushes up the text to array, but ill crop with AWK
function pushUpNpmListToArray(){
	echo "Running npm list command to pull all global packages..."
	while read line ; do
		if [[ "$(echo "$line" | awk '{print $1}')" != "/usr/local/lib" ]]; then
			# rip out only the part thats relevant
			string="$(echo "$line" | awk '{print $2}')"
			# replace the @ character with a blank space
			string="${string/@/ }"
		fi
		ARRAY_OF_NPM_PACKAGE+=("$string")
	done <<< "$(npm ls -g --depth 0)"
	# TODO - look in to create a basic loading bar
	# https://stackoverflow.com/questions/12628327/how-to-show-and-update-echo-on-same-line
	echo "pushing list up to temp variable..."
}

function nodeJsonOutPut(){
	cat <<-EOF
		{
      		"name": "$1",
      		"version": "$2"
    	}
	EOF
}

function checkNpmAndNodeIsInstalled(){
	nodeInstalled="$(checkDepManInstalled node "/usr/local/bin/node")"
	if [[ $nodeInstall == false ]]; then
		echo "node was not found. Running the install latest command"
		cd $HOME
		brew install node
	else
		echo "node.js is installed on your system already"
		echo "Version: $(node -v)"

	fi

	npmInstalled="$(checkDepManInstalled npm "/usr/local/bin/npm")"
	if [[ $npmInstalled == false ]]; then
		echo "npm was not found. Running the install latest NPM version"
		cd $HOME
		npm install npm@latest -g
	else	
		echo "npm is installed on your system already"
		echo "Version: $(npm -v)"
	fi
}

function generateNpmPackageList(){

	# ACCEPT JSON file PATHING!
	pushUpNpmListToArray

	count=1
	echo "Creating $1 file"
	echo "{" > $1
	echo "\"nodePackages\": [" >> $1

	for string in "${ARRAY_OF_NPM_PACKAGE[@]}" ; do
		npmPackageName="$(echo "$string" | awk '{print $1}')"
		versionNum="$(echo "$string" | awk '{print $2}')"
		
		# IF the npmPackageName and the versionNum does not have 0 length
		if [[ ! -z "$npmPackageName" && ! -z "$versionNum" ]]; then
			nodeJsonOutPut $npmPackageName $versionNum >> $1
			# if condition to add commas at the end of each item
			if [[ "$count" != "${#ARRAY_OF_NPM_PACKAGE[@]}" ]]; then
				echo "," >> $1
			fi
		fi
		let count=count+1
	done

	# wrap up the json file
	echo "] }" >> $1

	# beautify with JQ immediately after!
	beautifyWithJQ $1
}

function updateAllNpmPackages(){
	npm update -g .
	npm install npm@latest -g.
}

function installAllNpmPackages(){
	pushUpNpmListToArray

	# check against existing list if any of the packages are already installed
	while read externalJsonPackages; do
		withoutAtSign="${externalJsonPackages/@/ }"
		# compare to make sure the external JSON stuff isnt showing up in the current list
		found=false

		for string in "${ARRAY_OF_NPM_PACKAGE[@]}" ; do

			existingPackageName="$(echo "$string" | awk '{print $1}')"
			formatString="$(echo "$withoutAtSign" | awk '{print $1}')"
			formatString="$(clear_quotes $formatString)"

			if [[ $formatString == $existingPackageName ]]; then
				found=true
				break
			fi
		done

		if [[ $found == false ]]; then
			echo "$withoutAtSign node package was not found."
			echo "starting global install for package $externalJsonPackages"
			npm install -g "$(clear_quotes $externalJsonPackages)"
		fi

	done <<< "$(jq '.nodePackages[] | .name + "@" + .version' $1)"
}

# ===== app start =====

function errorMessage(){
	cat<<-EOF
		$1 "$2" was not recognized!
		please read the usage information displayed below!
		



	EOF
}

function main(){
	# ====== local variables ======
	local array_of_user_input=( $1 $2 $3 )
	local commandNull="$(validateNullData $1 1)"
	local commandValid="$(validateInvalidData $1 "$(echo ${ARRAY_OF_COMMAND[@]})" 1)"
	local managerTypeNull="$(validateNullData $2 2)"
	local managerTypeValid="$(validateInvalidData $2 "$(echo ${ARRAY_OF_DEP_MANAGE[@]})" 2)"

	# checks to make sure command is at least not null
	if [[ $commandNull == "1" || $commandValid == "1" ]]; then
		clearCurrentTerminalSession
		errorMessage "command" "$1"
		usage
		exit 1
	fi

	# check to make sure if the C command is empty then do whatever need to modify this part
	if [[ $1 == "-c" && $managerTypeNull == "2" || $managerTypeValid == "2" ]]; then
		echo "reached here"
		checkNpmAndNodeIsInstalled
		checkHomeBrewInstalled
	else
		clearCurrentTerminalSession
		errorMessage "managerType" "$2"
		usage
		exit 2
	fi

}

# = start =
main $1 $2 $3