#!/bin/bash
# ===== GLOBAL_VAR ===== #

DEFAULT_HASH_BIT_RATE=256

# ===== UTILITY ===== #

function clearTerminalSession(){
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
}

function hashString(){
	# ARGUMENT 1 = THE STRING TO BE HASHED!
	# ARGUMENT 2 = BIT RATE ITS GOING TO BE HASHED INTO!
	# RETURNS HASHED STRING
	echo $1 | shasum -a $2 | awk '{print $1}'
}

function hashFile(){
	# ARGUMENT 1 = BIT RATE YOU WANT TO HASH IT IN
	# ARGUEMNT 2 = PATH TO FILE
	shasum -a $1 $2
}

function validateHashKey(){
	# simple if conditional that returns false or true
	if [[ $1 = $2 ]]; then
		echo true;
	else
		echo false;
	fi
}

function base64Encode(){
	#ARGUMENT 1 = PATH TO FILE
	openssl base64 -in $1
}

function base64Decode(){
	echo "$1" | openssl enc -base64 -d
}

# ===== MAIN ===== #

function main(){
	test="$(base64Encode $1)"
	base64Decode test
}

#START OF PROGRAM!
main $1