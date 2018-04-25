#!/bin/bash

# ========== GLOBAL VARIABLES ==========


# write logic that setup all the source in to the bash profile
# need to write a readme file here
# need to update the readme in the highlevel directory

function writeToFile(){
	# first param is the text
	# second param is the file to be written to
	echo $1 >> $2
}

function prePopulatedProfile(){
	# list out shit i know im going to need to set up just the shell scripts
	# path to each shell script
	cat<<-EOF
		source $1
	EOF
}

function changePermission(){
	# list all files under shellscript directory
	# then filter out only the shell scripts
	# change permisson so each script is executable
	while read line; do
		chmod +x $line
	done <<< "$(find $HOME/shellscripts/* | grep .sh$)"
}

function sourceAliasAndExports(){
	# need to check if the line exists in some form or way

	local fileToModify="$HOME/.bash_profile"
	
	while read line; do
		echo "writing source for $line to $fileToModify"
		echo ""
		writeToFile "$(prePopulatedProfile $line)" $fileToModify
		echo ""
	done <<< "$(find $HOME/shellscripts/bashProfileSources/* | grep .sh$)"
}

function main(){
	changePermission
	sourceAliasAndExports
	read -e testVar
	echo $testVar
}


function validateSourcingIsNeeded(){

	# return 0 if its not needed, if it is then return 1
	# need to read the bashrc and the bash_profile to see if the thing exist
	# Check the bashrc and the bashprofile
	# or just use egrep?
	# for line in "$(cat )"; do
	# 	#statements
	# done
	echo "helllp"
}
# setup flow
# - Pull or clone the repo
# - user is going to change permission on this shell file
# - user is going to set up his bash with whatever he needs
# - user is going to change permission on all shell scripts found inside this repo
# - user is going to install all dependencies (just the basics)

# start of script
complete -F autoCompCommands ./initialPullSetUp.sh
main