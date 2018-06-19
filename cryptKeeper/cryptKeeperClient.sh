#!/bin/bash
# ===== GLOBAL_VAR ===== #



# ===== UTILITY ===== #

function clearTerminalSession(){
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
}



# ===== MAIN ===== #



function login(){
	read -e -p "Enter username:" raw_username
	read -e -p "Enter password:" raw_password
	
	# public vs private?
	
}

function hashEnvCryptString(){
	# ARGUMENT 1 = THE STRING TO BE HASHED!
	# ARGUMENT 2 = BIT RATE ITS GOING TO BE HASHED INTO!
	# RETURNS HASHED STRING
	echo $1 | shasum -a $2 | awk '{print $1}'
}

function callSSHServer(){
	echo $1
}

function base64IncomingData(){
	echo $1
}

function encryptIncomingData(){
	ehco $1
}

function randomGenerateKey(){
	echo $1
}

function randomGeneratePassword(){
	echo $1
}

function pushUpEncryptedFile(){
	echo $1
}

function readJSONFile(){
	echo $1
}

# TODOs + Notes
# - layer data change 3-4 times
# base64
# crypt
# salt with openSSL?
# gpg - https://gnupg.org/
# triple DES - https://www.rankred.com/common-encryption-techniques/
# AES - https://searchsecurity.techtarget.com/definition/Advanced-Encryption-Standard
# based on ENV variable user sets up the encryption will be looped several times
# sha1

# ====== flow envisoned ======
# User has shell script
# user has environemnt variable set (hash key)
# user runs script to encrypt JSON file with passwords and usernames
# user salt/encrypts everything
# pushes it up and writes to SSH
# ===== decrypt flow ======
# user pulls from ssh
# user decrypts
# user has password

# hash the file client side, and track it with another file that tracks 
# all files and the hash value to make sure the files were the same since



# json file thats been base64-ed
# you can only cat it ONCE u have the correct hashkey


function main(){
	login
}

# USAGE/START OF PROGRAM!
main $1