#!/bin/bash

# ========== GLOBAL VARIABLES ==========
FILE_TO_MODIFY="$HOME/.bash_profile"

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
	
	while read line; do
		echo "writing source for $line to $1"
		echo ""
		writeToFile "$(prePopulatedProfile $line)" $1
		echo ""
	# writing all sources from this specific pathing
	done <<< "$(find $HOME/shellscripts/FunTimeRecords/bashProfileSources/* | grep .sh$)"
}

function validateSourcingIsNeeded(){
	# booleans that will set the return condition
	local arrayOfSourceFound=()

	while read lsLine ; do
		# change to $HOME so the EGREP can correctly target the bash files
		cd

		# echos for quick checks
		# echo "== $lsLine contents =="
		# echo "$(egrep '^(source)\s\S*(export)\S*(.sh)$|^(source)\s.*(alias)\S*(.sh)$' $lsLine)"

		# starts with text source | whitespace | anycharacter * | text export found somewhere in the middle | anycharacter * | ends with .sh
		# starts with text source | whitespace | anycharacter * | text alias found somewhere in the middle | anycharacter * | ends with .sh
		if [[ -z "$(egrep '^(source)\s\S*(export)\S*(.sh)$|^(source)\s.*(alias)\S*(.sh)$' $lsLine)" ]]; then
			# filter returned nothing
			arrayOfSourceFound+=(false)
		else
			# filter returned something
			arrayOfSourceFound+=(true)
		fi

	# egrep-ing the output of LS to look for profile OR rc file. grep -e can replace egrep if needed?
	# starts with "source" | whitespace | nonwhitespace * | .sh at the end 
	done <<< "$(ls -a -1 $HOME | egrep '\.bash+_[a-z]*.e$|.bashrc')"
	
	# return conditions
	# IF BOTH RC AND PROFILE DOES NOT HAVE SOURCE return 8
	# IF ONE of them does have it return 0
	if [[ ${arrayOfSourceFound[0]} == true || ${arrayOfSourceFound[1]} == true ]]; then
		echo 0
	else
		echo 8
	fi
}

function main(){
	changePermission
	
	# since the validate method echos the return value i can catch with conditional?
	if [[ "$(validateSourcingIsNeeded)" == 0 ]]; then
		echo "Sourcing was found"
	else
		echo "Sourcing was not found in either files"
		# writing in comment + spacing
		writeToFile "" $FILE_TO_MODIFY
		writeToFile "# Source for alias, exports, and functions" $FILE_TO_MODIFY
		# actual source writing.
		sourceAliasAndExports $FILE_TO_MODIFY
	fi

	# I tried sourcing the file im modifying, but its not applying changes to the current shell session. Since this is the case im going to just have the user restart the terminal session
	echo ""
	echo "restart terminal session to apply all changes!"
}




# setup flow
# - user pull or clone the repo
# - user is going to install pre-reqs (just sublime. everything else can be installed through depMan)
# - user is going to change permission on this shell file
# - user runs script
# - user restarts shell sessions
# - user runs the depMan script to install brew and npm
# - user now has the abillity to run whatever script he/she needs!

# start of script
main