# dependencyManager

## Description
- Dependency manager is a shell script that allows users to easily install/update any supported package managers
- For the time being its only NPM and HomeBrew (as I start using more i'll update this script)

## Feature
- On start it will check to make sure the base packages + the managers are installed npm, homebrew, JQ (shell based json parser)
- The check can also be manually triggered
- Generate a JSON file with a list of all packages under that manager (the json file is used for the install command!)
- Installs packages listed inside the JSON file specified
- Updates all packages under whichever manager specified (you can invoke with no arguments to update packages under all managers)
- display version infromation

## How to install
- move the script to

## How to use
- Clone or download this script to whatever directory you want
- Make the script executable with the **chmod +x**
> for style points create an alias in your bashrc or bash_profile that can run the command anywhere for ease of use
> I personally have this added in my bash profile **alias depMan='~/shellscripts/dependencyManager.sh'**

## upcoming features 
- auto detect the JSON file using something like grep instead of a regex looking for .json
- steps to auto run the update feature based on time interval? (something like a monthly run)
- support version specific install for homebrew packages (This only works on node packages)
- support install to latest for npm packages (some kind of argument)
- man page? (need to look in to this one)

## Notes
- JSON file examples for both homebrew and npm is inside the repro, so if you want to customize it you can
- Homebrew packages auto installs to latest
- npm auto installs to version specific (this was due to problems i was running in to with appium!)
- atm the commands are invoked by quick conditional checks, so will change this to a case statement with custom conditionals to make adding new commands easier
- create a function that will increment version
-- the version will be recorded inside either this markdown or in the shell script as a global var

## Examples on how to run the command
- to invoke the usage information
> ./dependencyManager.sh

- to invoke the check command
> ./dependencyManager.sh -c

> ./dependencyManager.sh -c npm

- to invoke the generate command
> ./dependencyManager.sh -g

> ./dependencyManager.sh -g npm

- to invoke the install command
> ./dependencyManager.sh -i npm $HOME/shellscripts/dependencyManager/nodeJsonExample.json

- to invoke the update command
> ./dependencyManager.sh -u

> ./dependencyManager.sh -u npm

- to invoke the version command
> ./dependencyManager.sh -v