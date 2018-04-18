#!/bin/bash

# NOTE:
# If you want to add more ADB commands you must do the following!
# - Update the OPTIONS global array (to display the option to console)
# - Create the function (it needs to accept at least one random param for device ID)
# - Source the function in the switch case statement under commandSelection function
# - save the shell script!

# Global Variables listed here!
DEVICEIDS=()
APKLIST=()
OPTIONS=("screenshot" "screenrecord" "logcat" "displayPackages" "setIdle" "installApp" "uninstallApp")

function main(){
	# pushes all connected devices to my global array variable
	pushDeviceIDToArray
	clearCurrentTerminalSession

	# if theres only 1 device automatically just go to the command selection with the singular item
	if [[ "${#DEVICEIDS[@]}" = 1 ]]; then
		clearCurrentTerminalSession
		commandSelection "${DEVICEIDS[0]}"
	else

		# variables local to this else statement
		count=1
		deviceIndex=

		# list devices here
		echo "Which device do you want to run adb commands on?"
		echo ""
		echo "list of connected android devices:"
		
		for i in "${DEVICEIDS[@]}"; do
			echo "option $count: $i"
			let count=count+1
		done
		echo ""

		read -p "device option: " deviceIndex
		if [[ "$deviceIndex" > "${#DEVICEIDS[@]}" || "$deviceIndex" < 1 ]]; then
			echo "invalid selection"; exit 1
		else
			clearCurrentTerminalSession
			commandSelection "${DEVICEIDS[$deviceIndex-1]}"
		fi

	fi
}

function clearCurrentTerminalSession(){
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
}

function screenShot(){
	# pass the device ID as param1 or "$1"
	clearCurrentTerminalSession
	echo "Capturing screenshot on device $1"
	adb -s "$1" shell screencap /sdcard/Pictures/screenshot.png

	echo ""
	echo "Pulling screenshot from device $1 and moving to desktop"
	adb -s "$1" pull /sdcard/Pictures/screenshot.png
	mv screenshot.png ~/Desktop/

	echo "removing screenshot from device $1"
	adb -s "$1" shell rm -rf /sdcard/Pictures/screenshot.png
}

function screenRecord(){
	#  pass the device ID as param1 or "$1"
	clearCurrentTerminalSession
	# the Trap is there to catch the CTRL + C command so i can immediately chain to pull recording
	trap 'pullRecording "$1"' 2
	echo "Starting screenrecord on device $1"
	echo "Note:" 
	echo "- When you are done recording you must MANUALLY kill the recording. (CTRL + C)"
	echo "- The recording will automatically get pulled from your device to your desktop at the end!"
	echo "- The recording will also be removed from device $1 as soon as its pulled"
	adb -s "$1" shell screenrecord /sdcard/recording.mp4

}

function pullRecording(){
	#  pass the device ID as param1 or "$1"
	clearCurrentTerminalSession
	echo "Pulling the recording on device $1"
	# sleep delay is required so the system has time to allow the MP4 to "compile"
	sleep 1
	adb -s "$1" pull /sdcard/recording.mp4
	mv recording.mp4 ~/Desktop/
	echo "Removing the recording from device $1"
	adb -s "$1" shell rm -rf /sdcard/recording.mp4
}

function logcat(){
	clearCurrentTerminalSession
	echo "Starting adb logcat on device $1"
	echo "Note: - When you are done recording logs you must manually kill the session."
	echo "      - ctrl + c is the button combination!"
	echo "      - The log files will be placed on your desktop!"
	echo "		- The logs are filtered for todays ONLY!"

	# filtering out logs only for today!
	adb -s "$1" logcat | grep "$(date +%m-%d)" > ~/Desktop/log.txt
}

function displayPackages(){
	clearCurrentTerminalSession
	echo "Displaying all packages installed on device $1"
	echo ""
	adb -s "$1" shell pm list packages
}

function setIdle(){
	clearCurrentTerminalSession
	# accept the package name as second param
	echo "Setting idle state on APP: $2"
	adb -s "$1" shell am set-inactive "$2" true
	adb -s "$1" shell dumpsys deviceidle force-idle
	echo "NOTES:"
	echo "- DO NOT FORCE KILL YOUR APP"
	echo "- DO NOT RELAUNCH THE APP FOR AT LEAST 3-5 MIN (it's to allow it time to force that idle state)"
}

function specifyPathForApp(){
	# Need to accept the APPID as a first param (for the adb installation command)
	clearCurrentTerminalSession
	# buffer message!
	echo "Enter the pathing for the apk file!"
	echo "Note:"
	echo "- You cannot use the ~ character since it will translate it as a string literal"
	echo "- You cannot use GLOBAL variables."
	echo "- Valid Path Example: $HOME/Downloads/some.apk"
	echo ""

	# install with specified path
	read -e -p "Path to APK: " specifiedPathToAPK
	echo ""
	echo "installing $specifiedPathToAPK to device $1"
	adb -s "$1" install "$specifiedPathToAPK"
}

# Offchance may need to run this in subshell so the "install commands not recognized"
function installApp(){
	# pushes all .apk pathing from home directory to global array
	pushAPKListToArray
	clearCurrentTerminalSession
	
	# if condition to check if the list is empty (for some odd reason it 
	# will push up $HOME/Downloads/ by default if there are no APK files found)
	if [[ "${#APKLIST[@]}" = 1 && "${APKLIST[0]}" = "$HOME/Downloads/" ]]; then
		# the specifyPathForApp Command is just reusable in other parts of the app
		echo "no apk was found in your $HOME/Downloads !"
		echo "Would you like to specify a different path? (y or n)"
		read -p "y or n?: " specifyPath
		# limiting the type of inputs to Y and N (not case sensitive)
		if [[ "$specifyPath" = "y" || "$specifyPath" = "Y" ]]; then
			specifyPathForApp $1
		elif [[ "$specifyPath" = "n" || "$specifyPath" = "N" ]]; then
			echo "Exiting script"; exit 0
		else
			echo "invalid input. Exiting script"; exit 2
		fi
	else
		echo "Here is a suggested list of APK files in your downloads:"
		echo "=================="
		count=1
		for i in "${APKLIST[@]}"
		do
			echo "option $count: $i"
			let count=count+1
		done
		echo "option $count: specify your own path for apk file"
		appCount="${#APKLIST[@]}"
		let appCount=appCount+1
		# based on what the user inputs run the install command on that
		read -e -p "option: " apkIndex
		if [[ "$apkIndex" > "$appCount" || "$apkIndex" < 1 ]]; then
			echo "invalid selection"; exit 1
		elif [[ "$apkIndex" = "$appCount" ]]; then
			specifyPathForApp $1
		else
			#statements
			clearCurrentTerminalSession
			echo "Installing ${APKLIST[$apkIndex-1]} to device $1"
			adb -s "$1" install "${APKLIST[$apkIndex-1]}"
			echo ""
			echo "Install complete!"
		fi
	fi
}

function uninstallApp(){
	adb -s "$1" uninstall "$2"
}

function pushAPKListToArray(){
	while read line
	do
		APKLIST+=("$HOME/Downloads/$line")
	done <<< "$(ls ~/Downloads | grep .apk)"
}

function pushDeviceIDToArray(){
	# SUBSHELL SESSION WONT LET ME MODIFY THE VALUES
	# SO I NEED TO FEED THE STRING TO THE COMMAND
	# STDIN to ACTIVELY MODIFY THE GLOBAL VARIABLE

	while read line
	do
		# if statement that will only accept the device IDs and not the first line
		if [ ! "$line" = "" ] && [ `echo $line | awk '{print $2}'` = "device" ]; then
			device=`echo $line | awk '{print $1}'`
			DEVICEIDS+=("$device")
		fi
	done <<< "$(adb devices)"
}

function commandSelection(){
	echo "Select an option:"
	echo "Note: the command select is case sensitive!"
	for i in "${OPTIONS[@]}"
	do
		echo "- $i"
	done
	echo ""
	read -e -p "command: " optionSelected
	
	# if input is invalid exit the script, phase this out with case
	if [[ -z "$optionSelected" ]]; then
		echo "Input was null"; exit 1
	fi

	case "$optionSelected" in
		"screenrecord" )
			screenRecord "$1"
		;;

		"screenshot" )
			screenShot "$1"
		;;

		"logcat" )
			logcat "$1"
		;;

		"displayPackages" )
			displayPackages "$1"
		;;

		"setIdle" )
			echo "Please enter the app package name!"
			echo "Hint: It can be pulled from the displayPackages command!"
			read -e -p "Package name: " packageName
			setIdle "$1" "$packageName"
		;;

		"installApp" )
			installApp $1
		;;

		"uninstallApp" )
			clearCurrentTerminalSession
			echo "Please enter the package name of the app you want to uninstall!"
			echo "Hint: It can be pulled from the displayPackages command!"
			read -e -p "Package name: " packageName
			adb -s "$1" uninstall "$packageName"
		;;

		* )
			echo "Option was not recognized"; exit 1
		;;

	esac
}

# Start the shell script flow
main