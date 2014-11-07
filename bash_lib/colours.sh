##################################################################################
# Setup colours
##################################################################################

TERM=xterm
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldylw=${txtbld}$(tput setaf 3) #  yellow
bldblu=${txtbld}$(tput setaf 4) #  blue
bldpur=${txtbld}$(tput setaf 5) #  purple
bldcyn=${txtbld}$(tput setaf 5) #  cyan 
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}

coloured_msg() {
    local colour=$1
    local message=$2
    echo "${colour}${message}${txtrst}"
}

