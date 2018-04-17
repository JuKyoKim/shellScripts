# CommandLineTools
List of command line tools I use for everyday functions. The document also contains quick tidbits on how to user certain cli tools

## TOM's TODO for updating this document!
1. create bookmark points in this MD file
2. wrap up rest of the commands
3. link to shell scripts i use (by the time this is done ill have the universal installer written out)
4. https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet cheat sheet for MD cause im lazy
5. Need to add this one specific function to some of my output shell scripts
```bash
function clearCurrentTerminalSession(){
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
}
```

---

### Homebrew - https://brew.sh/

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

### Android Platform tool - https://developer.android.com/studio/releases/platform-tools.html

Command to install (this is using homebrew)
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

---

### Apple configurator - https://itunes.apple.com/us/app/apple-configurator-2/id1037126344?mt=12

