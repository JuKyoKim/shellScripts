#!/bin/bash
function main(){
	echo $1
}

function hashEnvCryptString(){

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


# json file thats been base64-ed
# you can only cat it ONCE u have the correct hashkey


# USAGE/START OF PROGRAM!
main $1