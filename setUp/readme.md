# initialSetUpScript

## Description
- This shell script is for setting up my development environment
	- it will source both the default exports + aliases to my ```.bash_profile```
	- it will change permission of all shellscripts found inside the ```/shellscripts``` directory

## How it works!
- On start it will find all files ending with ```.sh``` and change permission their permission so they're executable (simple while loop after quick find/grep)
- Checks if the ```.bash_profile or .bash_rc``` file contains the proper source lines
	- if the lines don't exist it will write to the file the source lines for both exports and aliases (it will write to ```.bash_profile``` by default)
- informs user they need to restart their session to apply changes

## ToDo
- Need to find a way to restart current shell session to apply changes dynamically
	- thinking about trying something like ``` exec bash ```