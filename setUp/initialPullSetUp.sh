#!/bin/bash

# ========== GLOBAL VARIABLES ==========
ARRAY_OF_PATH=()


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
	cat<<-EOF

	EOF
}

function changePermission(){
	# allows users to execute the file (required for shell scripts)
	chmod +x $1
}

function returnArrayOfPath(){
	while read line; do
		ARRAY_OF_PATH+=("$line")
	done <<< "$(ls -1 $1)"
}

function echoArrayItems(){
	for item in "${ARRAY_OF_PATH[@]}"; do
		echo "item $item"
	done
}

function main(){
	returnArrayOfPath $1
	
}

# setup flow
# - Pull or clone the repo
# - user is going to change permission on this shell file
# - user is going to set up his bash with whatever he needs
# - user is going to change permission on all shell scripts found inside this repo
# - user is going to install all dependencies (just the basics)

# start of script
main $1