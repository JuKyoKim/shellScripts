#!/bin/bash
source $HOME/shellscripts/cryptKeeper/utilityShell/shellUtil.sh

# ===== Global Variables ===== #

# ===== Functions ===== #

function main(){
	clearTerminalSession
	printOptions
	getUserOption
}

function getUserOption(){
	read -e -p "Option: " user_option

	case $user_option in
		"login" )
			$HOME/shellscripts/cryptKeeper/utilityShell/login.sh
		;;

		"create" )
			echo "create"
		;;

		"read" )
			echo "read"
		;;

		"update" )
			echo "update"
		;;

		"delete" )
			echo "delete"
		;;

		* )
			printGenericError
			exit 127
		;;
	esac
}

# ===== Messages ===== #

function printOptions(){
	cat <<-EOF
		======== CryptKeeper Home ========

		Description
		------------
		Simple password manager that encrypts/decrypt 
		your data and prints it out for ease of use
			- Uses SHA to do a basic hashing to "encrypt" data
			- Uses base64 to encode the hashed item
			- Stores it on your remote SSH server in basic text file
			- Supports basic CRUD operations!

		Options
		------------
		login => test login to ssh server
		create => new credential storage file (if one exist already this option will force exit)
		read => reads credential storage file (if one doesn't exist it will force exit)
		update => updates existing credential storage file (if one doesn't exist it will instead create new)
		delete => deletes existing credential storage file (if one doesn't exist it will force exit)

	EOF
}

function printGenericError(){
	cat <<-EOF
		Option choice was invalid!
		Exiting script....
	EOF
}

# ===== start of scripts ===== #

main