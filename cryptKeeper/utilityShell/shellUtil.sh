#!/bin/bash

# THIS SHELL will contain a bunch of generic functions

function clearTerminalSession(){
	# basic osascript to clear terminal
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
}