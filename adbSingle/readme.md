# adbSingle

## Description
- A shell script that runs specific ADB commands on a single device when multiple android devices are connected.
- It simplifies the choices for non-technical QA folks so they can easily choose the options they want.

## Features!
- On start it will display all devices that are currently connected to your machine.
	- If there is only one device connected it will automatically display adb commands as options.
- Easy to setup + only requires [Android platform tools](https://developer.android.com/studio/command-line/adb.html) to be installed.
- Commands that output a file (screenrecord, screenshot, logs) will automatically throw them on desktop AND remove them from device (if needed).

## Commands currently supported!
- screenshot
- screenrecord (The recording will be automatically after recording session ends)
- logcat (saves to text file on desktop, filtering todays date)
- display installed packages
- set any app to idle state
- install app (you can either select APK in downloads or specify a path)
- uninstall app (uninstall app you specify)
- clear app data (package name must be specified)

## How to install the script!
- Clone or download this script to whatever directory you want
- Make the script executable with the ```chmod +x```
> for style points create an alias in your bashrc or bash_profile that can run the command anywhere for ease of use
> I personally have this added in my bash profile ```alias adbSingle='~/shellscripts/adbSingle.sh'```

## How you can customize the shell script to your needs - Adding additional commands!
1. Under the OPTIONS array add the command you want to enter.
2. Inside the shell script add a function with the command name you entered in the OPTIONS array
> The function should accept 1 argument or "$1" (This will be explained in the next 2 step).
> The argument you're passing is the DEVICE UDID (which is needed to run adb -s).
3. Inside the commandSelection function there should be a case condition. Inside that case condition add a new condition for the command.
4. Inside that command condition just add the function you made and make it accept 1 argument
5. Save and run the script!
6. Verify the script displays the option and can run the command properly!

## Things to add later on!
- Make the screenrecord function time delayable (will most likely prompt options then accept a second argument to the screenrecord function)
- Allow the option to run the script with arguments instead of going to text based flow
- Allow users to pull files if they pass a specific route/pathing for the device
- Allow user to input env variables (stuff like "~", "HOME", "PATH", "EXPORT_FARTS" ) to be used when entering options in the script flow (read line needs to be done in current shell (refer to my auto complete and hockey app shell script since its done there.))