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
		echo "Version : $(brew --version)"
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
	npmInstalled="$(checkDepManInstalled node "/usr/local/bin/node")"
	if [[ $npmInstall == false ]]; then
		echo "node was not found. Running the install latest command"
		cd $HOME
		brew install node
	fi

	echo "attempting to install latest NPM version"
	npm install npm@latest -g
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

# ========= Generic app methods =========

function usage(){
	cat <<-EOF
		========= Dependency Manager =========

		Name
		----
		$PROGNAME -- Dependency Manager Shell Script

		Usage
		-----
		$PROGNAME <command> <managerType> <JsonFilePathing>

		<command> - List of all available commands => ()
		<managerType> - List of all supported Dependency Managers =>(${ARRAY_OF_DEP_MANAGE[@]})
		<JsonFilePathing> - Pathing Format example => (array items)

		commandInfo
		-----------
		-c  Checks to see if dependency manager is installed
		-g  Generates a json file containing the packages installed under whichever manager.
		-i  Install packages under whatever JSON file was passed. IF the package is already 
		    installed it will skip and move to the next item
		-u  update all packages under whatever dependency manager (Its always to latest stable).

		Return Codes
		------------
		0 => something
		TODO - Need to add exit conditions and return codes

		========= Dependency Manager =========
	EOF
}

function main(){
	usage
}



# = start =
main