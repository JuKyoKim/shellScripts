#!/bin/bash
# ===========global variabls===========
ARRAY_OF_BREW_PACKAGE=()


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
	ARRAY_OF_BREW_PACKAGE=()
	while read line 
	do
		ARRAY_OF_BREW_PACKAGE+=("$line")
	done <<< "$(brew list)"
}

# Update and upgrade all brew packages already installed
function updateAllBrews(){
	brew update
	brew upgrade
}

# Install brew packages based on whatever JSON file is passed
function installAllBrewPackages(){
	pushUpBrewListToArray
	while read line; do
		found=false
		formatLineText="$(clear_quotes $line)"
		for brewPackageName in "${ARRAY_OF_BREW_PACKAGE[@]}"; do
			# if found dont install
			if [[ "$formatLineText" == "$brewPackageName" ]]; then
				found=true
				break
			fi
		done

		if [[ "$found" == false ]]; then
			echo "$formatLineText formula was not found installed in machine"
			echo "starting brew install $formatLineText"
			brew install $formatLineText
		fi
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



installAllBrewPackages $HOME/Desktop/brw.json