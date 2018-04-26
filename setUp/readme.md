# initialSetUpScript

## Description
- This shell script is something i wrote to assist in setting up my development env (off chance I have a new machine, or i factory reset my current)
- it just writes to my .bash_profile common exports, functions, and alias' that I use in my day to day.
- it will automatically make all shellscripts found inside the /shellscripts directory executable

## TODOs
- Need to find a way to restart shell session to apply the line changes in bash_profile (I tried sourcing it, but doesn't seem to work?)
- thinking about trying something like ``` exec bash ```
- IF the restart shell session stuff does get figured out, I need to execute the depMan script to install homebrew + npm and all its associated packages (for initial setup just install brew and npm. The packages are not needed immediately and can be installed later!)
- IF the restart shell session stuff does get figured out, I need to write validation methods that will run each script correctly just to make sure its working correctly.