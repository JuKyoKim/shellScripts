# Hockey App CLI Tool

## Description
- Shell script that allows users to hit hockey app api with a couple of keywords

## Features
- Allows users to download whatever build to your work machine for side load (need to specify app name and platform)
- Allows users to list all apps under your hockey app account
- Allows users to list versions of specific apps (you need to specify platform and app name)
- Caches the last downloaded app in lastAppPulled.json file under your $HOME directory
- Caches the entire list of apps found under your hockey app account in fauxcache.json under your $HOME directory

## How to install the script
- Clone or download this script to whatever directory you want
- Make the script executable with the ```chmod +x```
> for style points create an alias in your bashrc or bash_profile that can run the command anywhere for ease of use
> Personally I made an alias called hockey to run the script from anywhere
> ```alias hockey="~/hockeyCLTool.sh"```
- Install JQ on your dev machine - [JQ download](https://stedolan.github.io/jq/download/)
- Setup an ENV variable in your bashrc or bash_profile called HOCKEYTOKEN
	```export HOCKEYTOKEN="1234hockeytoken56789"```
- reset the terminal session

## Executing the script (with examples)
- To pull script's usage doc
```hockey```

- To pull list of apps under hockey
```hockey list```

 - pulls Android apps
 	- the platform is case sensitive!
```hockey list Android```

- pulls iOS apps
	- the platform is case sensitive!
```hockey list iOS``` 

- To pull list of specific apps version
	- the platform is case sensitive!
	- the appName should include quotes IF there is a space in between!
```shell
hockey list-version {platform} {app name}
hockey list-version Android "testApp"
```

- To Download specific app
	- the platform is case sensitive!
	- the app name should include quotes IF there is a space in between!
	- the version should be whatever app version is listed in the previous command
```shell
hockey download {platform} {appname} {version}
hockey download Android "testApp" 4400000
```

## Things to add later on
- option to run through this as a text based GUI
- option to name the Downloaded file whatever they input
- make more clear console logs
- make all the curl commands more uniform!
- make a working loading bar (CURL command takes forever, so need a visual indicator to show progress)