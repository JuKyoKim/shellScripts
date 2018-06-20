#!/bin/bash

# THIS SHELL will contain a bunch of generic functions

function clearTerminalSession(){
	# basic osascript to clear terminal
	osascript -e 'tell application "System Events" to tell process "Terminal" to keystroke "k" using command down'
}

function findYorick(){
	# reference to yorick from both shakespeare and league
	# adds a period to start of string
	# finds a file with yorick.tcl at the end of the pathing
	# outputs the result
	echo ".$(find ~/shellscripts/* | grep yorick.tcl$)"
}