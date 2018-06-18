# Tom's bag of fun dev tools + tips/tricks!
This repo contains shell scripts + quick notes on any tools + tips/tricks I use in my day to day.
* The shell scripts are listed below so you can go straight to the files
	* Each script should have a readme with install info + how to use
* The tools + tips/tricks are listed below under the "Table of Content"
	* Don't expect super detailed notes! I made it super simple for me to understand quickly.


---


## ShellScripts
* [adbMulti](/adbMulti)
* [adbSingle](/adbSingle)
* [dependencyManager](/dependencyManager)
* [hockeyAppTool](/hockey)


---


## Table of Content!

#### * [Installation Instructions!](#installation-of-scripts--other-utilities)

#### * [My ToDos!](#todo)

#### * [Bash CLI, Tools, Tips, & Tricks](#cli-tools-tips--tricks)
* [Homebrew](#homebrew)
* [Android Platofrm Tools](#android-platform-tool)
* [Apple Configurator (automation tools)](#apple-configuratorautomation-tools)
* [markdown cheatsheet](#markdown-cheatsheet)
* [Appium](#appium)


---


## Installation of Scripts + Other Utilities

### Pre-Reqs
* Install latest version of [Sublime Text](https://www.sublimetext.com/)
* Create a [symlink for Sublime Text](https://olivierlacan.com/posts/launch-sublime-text-3-from-the-command-line/)
* Install [JDK & JRE](https://docs.oracle.com/javase/9/install/installation-jdk-and-jre-macos.htm#JSJIG-GUID-2FE451B0-9572-4E38-A1A5-568B77B146DE)

### What's being installed?
By default these items are installed. You can always configure the JSON files in the ```/dependencyManager``` directory to not install certain items. Starred items are installed no matter what.
* Homebrew *
* Node.js *
* Npm *
* Android SDK
* Android Platform Tools
* Maven
* Appium
* Appium doctor
* ios-deploy
* nodemon
* json-server


### Steps
1. Open Terminal
2. Clone this repo to your home directory
	* You can just type in terminal ```cd```, ```cd $HOME```, ```cd ~```
3. Change permission to make the initialPullSetUp.sh executable 
	* ```chmod +x ~/shellscripts/setUp/initialPullSetUp.sh```
4. Exec the initialPullSetUp.sh script
	* ```./$HOME/shellscripts/setUp/initialPullSetUp.sh```
	* The script will source all the exports + aliases I use to your ```.bash_profile```
	* Make sure to restart your terminal session after running the script
		* In the new session check to see if it worked by typing 
```modify_bash_profile```
5. Exec the Dependency Manager script with the check option
	* In terminal type ```depMan -c``` 
	* This should auto install everything you need to run the other depMan options
6. Exec the depMan script with install option
	* In terminal type these 2 commands
	```shell 
	depMan -i npm $HOME/shellscripts/dependencyManager/nodeJsonExample.json
	depMan -i brew $HOME/shellscripts/dependencyManager/brewJsonExample.json
	```
	* This should install the default packages for QA automation (stuff like appium, ios-deploy, carthage, etc....)
7. Go to [git-prompt repo](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)
8. Clone the shell script to your local machine


---


## CLI, Tools, Tips, & Tricks!

### [Homebrew](https://brew.sh/)

Command to install homebrew
```ruby
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Command to update all casks and homebrew
```bash
brew update
```

Command to upgrade everything
```bash
brew upgrade 
```

Command to find where stuff gets downloaded
```bash
brew --cache
```

Command to uninstall Homebrew
```ruby
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```


---


### [Android Platform tool](https://developer.android.com/studio/releases/platform-tools.html)

Command to install adb (this is using homebrew)
```shell
brew install android-platform-tools
```

Command to list devices
```shell
adb devices
```

Command to run shell on current device
```shell
adb shell
```

Command to list packages
```shell
adb shell pm list packages
```

Command to install apps
```shell
adb install {apk location}
```

Command to uninstall apps
```shell
adb uninstall {package name}
```

Command to take screenshots
```shell
adb shell screencap {path to save to in device}
```

Command to pull files
```shell
adb pull {path of file you want to pull}
```

Command to set app to idle state
```shell
adb -s "$1" shell am set-inactive "$2" true
adb -s "$1" shell dumpsys deviceidle force-idle
**after running the command you need to wait 2-3 min for the change to take place**
```

Command to clear app data
```shell
adb shell pm clear {package name}
```


---


### [Apple configurator(automation tools)](https://itunes.apple.com/us/app/apple-configurator-2/id1037126344?mt=12)

Command to install app
```shell
cfgutil install-app {path to IPA file}
```

Command to uninstall app
```shell
cfgutil remove-app {Package name}
```

Command to get all properties of connected device 
```shell
cfgutil get all
```


---


### [MarkDown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)


---


### [Appium](http://appium.io/)


---


## TODO
1. Deeplink.sh
	* update the script to be flexible to any app installed on current android/ios device?
2. High Level README.md
	* update this readme with every tool i've used + installation instructions
	* capitalize correctly
	* need to make sure android sdk + xcode installation steps are also included