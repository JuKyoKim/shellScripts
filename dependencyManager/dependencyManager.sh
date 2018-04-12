#!/bin/bash
# ===========global variabls===========
ARRAY_OF_BREW_PACKAGE=()
ARRAY_OF_NPM_PACKAGE=()
ARRAY_OF_DEP_MANAGE=( "npm" "brew" )

# ===========Generic Utility===========

function beautifyWithJQ(){
	# MUST ACCEPT A PATHING
	# pumping the output of OG ugly json to JQ
	# store it in a variable
	# print the output in to json file again
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
	whichBrewOutput="$(which brew)"
	if [[ "$whichBrewOutput" != "/usr/local/bin/brew" ]]; then
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
	echo -n "pushing list up to temp variable..."
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
	whichNodeOutput="$(which node)"
	if [[ "$whichNodeOutput" != "/usr/local/bin/node" ]]; then
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

	echo "Creating $1 file"
	echo "{" > $1
	echo "\"nodePackages\": [" >> $1

	for string in "${ARRAY_OF_NPM_PACKAGE[@]}" ; do
		npmPackageName="$(echo "$string" | awk '{print $1}')"
		versionNum="$(echo "$string" | awk '{print $2}')"

		nodeJsonOutPut $npmPackageName $versionNum >> $1
	done



	# wrap up the json file
	echo "] }" >> $1

	# beautify with JQ immediately after!
	# beautifyWithJQ
}

function updateAllNpmPackages(){
	npm update -g .
	npm install npm@latest -g.
}
# "(\w*\w@*.*)"
generateNpmPackageList $HOME/Desktop/node.json