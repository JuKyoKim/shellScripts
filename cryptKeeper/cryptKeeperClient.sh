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
	#ARGUMENT 1 = PATH TO FILE or pipe in String?
	base64 $1
}

function base64Decode(){
	#ARGUMENT 1 = encoded b64 string
	echo "$1" | base64 --decode
}

function login(){
	# need to kickup ssh server
	# ask for address and port
	# auto connect based on RSA KEY
	# if the RSA key does not exist throw error and exit
	clearTerminalSession
	read -e -p "Enter server address:" server_address
	read -e -p "Enter port number:" port_number
	read -e -p "Enter passphrase:" server_passphrase
	ssh $server_address -p $port_number
}



# ===== MAIN ===== #

function main(){
	login
}

#START OF PROGRAM!
main