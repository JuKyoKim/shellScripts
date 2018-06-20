#!/usr/bin/expect -f

# set timeout for each input to be within 3 seconds
set timeout 1

spawn ssh [lindex $argv 0] -p [lindex $argv 1]
expect {
	# TODO - need to overwrite this string once my SSH server is kicked up
	"This is a OverTheWire game server. More information on http://www.overthewire.org/wargames" {
		expect "bandit1@bandit.labs.overthewire.org's password:" {
			send [lindex $argv 2]
			send "\r"
		}
	}

	# Make a better use case for ssh fail in expect
	"Bad port" {
		send "\r"
	}
}
interact