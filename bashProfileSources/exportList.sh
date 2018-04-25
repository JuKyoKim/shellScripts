#!/bin/bash

# Shell file with all of my Exports to make it easier to sync up all of my work stations

# PS1 EXPORTS
export PS1="\[$(tput bold)\]\[$(tput setaf 6)\]\T \[$(tput setaf 2)\][\[$(tput setaf 3)\]\u\[$(tput setaf 1)\]@\[$(tput setaf 3)\]\W\[$(tput setaf 2)\]]\[$(tput setaf 4)\]\$(__git_ps1)\\$ \[$(tput sgr0)\]"

# Exporting the ANDROID_HOME pathing for Appium
export ANDROID_HOME="$HOME/Library/Android/sdk"

# PATH EXPORTS
export PATH="$PATH:$ANDROID_HOME/tools/"
export PATH="$PATH:$ANDROID_HOME/tools/bin/"
export PATH="$PATH:$ANDROID_HOME/platform-tools/"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="$PATH:/usr/local/sbin"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
# MongoDB EXPORTS 
# Currently commentted out since im not using it
# export MONGO_PATH=/usr/local/mongodb
# export PATH=$PATH:$MONGO_PATH/bin

# Android Package Name EXPORTS
export NHL="com.nhl.gc1112.free"
export EURO="com.eurosport.player"
export ESPN="com.espn.score_center"
export ESPN_DEBUG="com.espn.score_center.debug"
export APPIUM_UNLOCK="io.appium.unlock"
export APPIUM_UIAUTO_SERV_TEST="io.appium.uiautomator2.server.test"
export APPIUM_UIAUTO_SERV="io.appium.uiautomator2.server"
export APPIUM_SETTING="io.appium.settings"

# java EXPORTS
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=${JAVA_HOME}/bin:$PATH