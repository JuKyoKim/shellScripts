#!/usr/bin/expect


spawn ssh bandit1@bandit.labs.overthewire.org -p 2220

expect "This is a OverTheWire game server. More information on http://www.overthewire.org/wargames"
send "\r"

expect "bandit1@bandit.labs.overthewire.org's password:"
send "boJ9jbbUNNfktd78OOpsqOltutMc3MY1"
send "\r"

interact