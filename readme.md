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

#### * [Bash CLI, Tools, Tips, & Tricks](#cli-tools-tips--tricks)
* [Homebrew](#homebrew)
* [Android Platofrm Tools](#android-platform-tool)
* [Apple Configurator (Automation Tool)](#apple-configuratorautomation-tools)
* [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
* [Appium](http://appium.io/)
* [Hosting a file on local IP/PORT](#hosting-a-file-on-local-ipport!)
* [Airflow (Chromecast/airplay content from Mac)](https://airflowapp.com/)
* [Alfred (better version of spotlight)](https://www.alfredapp.com/)
* [iTerm (better version of terminal)](https://www.iterm2.com/)
* [Docker](https://www.docker.com/)
* [Charles](https://www.charlesproxy.com/)
* [Spectacle (windows management tool)](https://www.spectacleapp.com/)
* [Postman (rest api)](https://www.getpostman.com/)
* [vysor (control android from desktop)](https://www.vysor.io/)

#### * [My ToDos!](#todo)


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
* Apple Configurator
* Android SDK
* Android Platform Tools
* Maven
* Appium
* Appium doctor
* ios-deploy
* nodemon
* json-server


### Steps for Full installation
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
7. Go to [git-prompt repo](https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh)
8. Clone the git-prompt.sh shell script to your local machine. Using ```wget``` might be easier then manually downloading.
   * MAKE SURE THE FILE PATH IS FOR THE RAW FILE OR YOU ARE GOING TO GRAB THE ENTIRE HTML
    ```wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh```
9. Follow the instructions in the git-prompt shellscript to source to bash sessions
10. Go to [video-to-gif repo](https://github.com/minimaxir/video-to-gif-osx)
11. Download the shell script
12. Go to ```/shellScripts/bashProfileSources/aliasAndFunctions.sh``` and modify the ```alias convertVideoToGif=``` pathing to point to where the shell script currently lives
13. Go to [MTR's main website](https://github.com/traviscross/mtr) and follow the installation instructions


---


## CLI, Tools, Tips, & Tricks!

### [Homebrew](https://brew.sh/)

Command to install homebrew
```ruby
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Command to update all casks and homebrew
```shell
brew update
```

Command to upgrade everything
```shell
brew upgrade 
```

Command to find where stuff gets downloaded
```shell
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


### [Hosting a file on local IP/PORT](http://www.benjaminoakes.com/2013/09/13/ruby-simple-http-server-minimalist-rake/)

Command to host file/s
```shell
ruby -run -e httpd {path to file or directory} -p {4 digit PORT NUMBER}
```


---


## TODO
1. Deeplink.sh
	* update the script to be flexible to any app installed on current android/ios device?
2. maybe include a section on how i use charles?