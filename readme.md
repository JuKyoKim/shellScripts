# ShellScript
This repo has shellscripts + notes on stuff I use on my day to day life at work or at home.

## Table of content!
#### ShellScripts
- [adbMulti](/adbMulti)
- [adbSingle](/adbSingle)
- [dependencyManager](/dependencyManager)
- [hockeyAppTool](/hockey)

#### CLI, Tools, Tips, & Tricks (for me to ref)
- [Homebrew](#Homebrew)
- [Android Platofrm Tools](#Android-Platform-tool)
- [Apple Configurator (automation tools)](#Apple-configurator(automation tools))
- [markdown cheatsheet](#markdown-cheatsheet)
- [Appium](#Appium)

#### My TODOs!

---

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

### [MarkDown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#hr)
Link is on the header!

### [Appium](http://appium.io/)










