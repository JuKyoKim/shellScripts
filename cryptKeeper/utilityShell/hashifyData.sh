#!/bin/bash

# ===== GLOBAL_VAR ===== #

DEFAULT_HASH_BIT_RATE=256

# ===== FUNCTIONS ===== #

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