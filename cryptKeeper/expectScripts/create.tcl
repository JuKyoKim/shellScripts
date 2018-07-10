#!/usr/bin/expect -f

# set timeout for each input to be within 3 seconds
set timeout 60

spawn ssh [lindex $argv 0] -p [lindex $argv 1]
expect {
	# TODO - need to overwrite this string once my SSH server is kicked up
	"This is a OverTheWire game server. More information on http://www.overthewire.org/wargames" {
		expect "bandit1@bandit.labs.overthewire.org's password:" {
			send [lindex $argv 2]
			send "\r"
			sleep 2
			
			send "ls -a"
			send "echo 'reached inside the bubble!'"
			
		}
	}

	# Make a better use case for ssh fail in expect
	"Bad port" {
		send "\r"
	}
}

expect "bandit1@bandit:~$" {
	send "ls -a"
	send "echo 'reached inside the bubble!'"
}
interact