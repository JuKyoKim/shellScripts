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