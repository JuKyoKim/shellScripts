#!/bin/bash
# bash dependency manager!

# Need to make sure the update info is captured in the console for later use




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

# Update and upgrade all brew packages already installed
function updateAllBrews(){
	brew update
	brew upgrade
}

# Install brew packages based on whatever JSON file is passed?
# Need to create a format for the JSON file
# pathing for the JSON file should be flexible
function installAllBrewPackages(){
	echo "$1"
}

# Create a JSON file based on all the home brew packages
# Format needs to stay the same as the JSON file thats read by the installAllBrewPackages method
# make the JSON file live inside root? or Desktop?
function generateBrewPackageList(){
	echo "$1"

}

checkHomeBrewInstalled