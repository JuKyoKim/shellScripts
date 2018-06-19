# TODOs + Notes
- layer data change 3-4 times
- base64
- crypt
- salt with openSSL?
- gpg - https://gnupg.org/
- triple DES - https://www.rankred.com/common-encryption-techniques/
- AES - https://searchsecurity.techtarget.com/definition/Advanced-Encryption-Standard


client side responsibility (after RSA validation and user is in)
=========
OPTIONS
- print decoded base64 data (This will be specific though, the data im going to be reading will be one specific Text file)
- update/create by pushing up new base64 data
- delete any base64 data stored under whatever user


server side responsibility
=========
- validate with RSA key
- CRUD create, read, update, delete but only specific files users pushes up

<!-- Need to find out how to create dynamic DNS to easily hit it from work/outside home network -->
<!-- https://lifehacker.com/205090/geek-to-live--set-up-a-personal-home-ssh-server
https://lifehacker.com/124212/geek-to-live--how-to-set-up-a-personal-home-web-server -->

cryptKeeperClient shell script will start the login flow
expectedBot will enter the passwords? once it spawns?

boJ9jbbUNNfktd78OOpsqOltutMc3MY1
ssh bandit1@bandit.labs.overthewire.org -p 2220

https://stackoverflow.com/questions/7729948/expect-script-issue
https://gist.github.com/Fluidbyte/6294378