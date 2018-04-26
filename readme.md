# ShellScript
This repo has shellscripts + notes on stuff I use on my day to day life at work or at home.

## Table of content!

#### ShellScripts
- [adbMulti](/adbMulti)
- [adbSingle](/adbSingle)
- [dependencyManager](/dependencyManager)
- [hockeyAppTool](/hockey)

#### Installation instructions!

#### [My TODOs!](#todo)

#### [Bash CLI, Tools, Tips, & Tricks (for me to ref)](#cli-tools-tips--tricks)
- [Homebrew](#homebrew)
- [Android Platofrm Tools](#android-platform-tool)
- [Apple Configurator (automation tools)](#apple-configuratorautomation-tools)
- [markdown cheatsheet](#markdown-cheatsheet)
- [Appium](#appium)

---

## Installation of scripts + other utilities

### Pre-reqs
- Install latest version of [Sublime Text](https://www.sublimetext.com/)
- Create a [symlink for Sublime Text](https://olivierlacan.com/posts/launch-sublime-text-3-from-the-command-line/)
- Install [JDK & JRE](https://docs.oracle.com/javase/9/install/installation-jdk-and-jre-macos.htm#JSJIG-GUID-2FE451B0-9572-4E38-A1A5-568B77B146DE)

### Steps
1. clone this repo to your home directory ('~' or '$HOME')
2. change permission to make the initialPullSetUp.sh executable ``` chmod +x ~/shellscripts/setUp/initialPullSetUp.sh```
3. run the script (this script will write to your bash_profile the sourcing for aliases and exports needed for native app automation + java development)
4. restart terminal (the shell script will tell you to anyways)
5. in the new session check to see if it worked by typing 
``` modify_bash_profile ```
IF this command opens sublime and your .bash_profile it means the first script ran worked as expected!
6. in terminal type ``` depMan -c ``` 
(its the alias for my dependencyManager shell script. The -c option checks to see if homebrew and npm is installed. IF it doesn't find them it will auto install them)
7. in terminal type these 2 commands
```shell 
depMan -i npm $HOME/shellscripts/dependencyManager/nodeJsonExample.json
depMan -i brew $HOME/shellscripts/dependencyManager/brewJsonExample.json
```
8. THIS IS WHERE I LEFT OFF NEED TO MAKE THE MARKDOWN LOOK CLEANER!
test

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

### [MarkDown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#hr)

---

### [Appium](http://appium.io/)

---

## TODO
1. update the deeplink shell script to be flexible to hit any app based on global array in bashrc or whatever is set in the app?
2. source the test.sh file in bash_profile to make it easy to use
3. move all references from bash_profile to a different file and just source that
4. update this readme with any quick tips and tricks i find along the way (external shell scripts + other tools i've used in the past! Should check my stars for this information!) 
5. need to update with initial setup shell script info
6. need to update with all of the export list being sourced
7. need to make sure installation instructions for all shell script recommends they do this in thier home directory (at least thats where its going to be set up if the run this shit!)