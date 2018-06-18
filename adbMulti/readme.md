# adbMulti

## Description
- Shell script that will run adb commands in a flexible manor against MULTIPLE connected android devices

## Feature
- Just run it like you are running ```adb {command} {argument}```

## How to install
- clone or download the script
- Make the script executable with the ```chmod +x```
> for style points create an alias in your bashrc or bash_profile that can run the command anywhere for ease of use
> I personally have this added in my bash profile ```alias adbMulti='~/shellscripts/adbMulti.sh'```

## Note:
- adb shell commands might only work on the first device passed (might be due to the session being killed by SIGINT? I still need to look in to this one)