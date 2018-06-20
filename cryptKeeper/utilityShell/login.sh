source $HOME/shellscripts/cryptKeeper/utilityShell/shellUtil.sh


# ===== GLOBAL ===== #

SERVER_ADDRESS=
PORT_NUMBER=
SERVER_PASSPHRASE=


# ===== main functions ===== # 

function login(){
	read -e -p "Enter server address:" SERVER_ADDRESS
	read -e -p "Enter port number:" PORT_NUMBER
	read -e -p "Enter passphrase:" SERVER_PASSPHRASE
}

function main(){
	clearTerminalSession
	login
	$HOME/shellscripts/cryptKeeper/expectScripts/loginAssistBot.tcl $SERVER_ADDRESS $PORT_NUMBER $SERVER_PASSPHRASE
}

#  ===== start of script ===== #
main