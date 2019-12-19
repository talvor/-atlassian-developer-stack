#!/bin/bash

#global variables
CLEAR="$(which clear)"
CAT="$(which cat)"
ADS_DIRECTORY_PROJECT_PATH="$HOME/.atlassian/ads/projects"
ADS_DIRECTORY_WORKSPACE_PATH="$HOME/.atlassian/ads/.config/workspace"
MKDIR="$(which mkdir) -p"
CP="$(which cp) -r"
RM="$(which rm) -r"
BLUE="tput setaf 4"
RESET_COLOR="tput sgr0"

setup() {
    banner
    menu
}

banner() {
    $BLUE
    cat <<"EOF"

########################################################################################################################################################################
#     _      _     _                       _                     ____                          _                                   ____    _                    _      #
#    / \    | |_  | |   __ _   ___   ___  (_)   __ _   _ __     |  _ \    ___  __   __   ___  | |   ___    _ __     ___   _ __    / ___|  | |_    __ _    ___  | | __  #
#   / _ \   | __| | |  / _` | / __| / __| | |  / _` | | '_ \    | | | |  / _ \ \ \ / /  / _ \ | |  / _ \  | '_ \   / _ \ | '__|   \___ \  | __|  / _` |  / __| | |/ /  #
#  / ___ \  | |_  | | | (_| | \__ \ \__ \ | | | (_| | | | | |   | |_| | |  __/  \ V /  |  __/ | | | (_) | | |_) | |  __/ | |       ___) | | |_  | (_| | | (__  |   <   #
# /_/   \_\  \__| |_|  \__,_| |___/ |___/ |_|  \__,_| |_| |_|   |____/   \___|   \_/    \___| |_|  \___/  | .__/   \___| |_|      |____/   \__|  \__,_|  \___| |_|\_\  #
#                                                                                                         |_|                                                          #
########################################################################################################################################################################


EOF
    $RESET_COLOR
}

copyProjectFiles(){
    workspacePath="$(cat $ADS_DIRECTORY_WORKSPACE_PATH)"
    projectName=$(echo $path | cut -d '/' -f7)
    projectPath="$workspacePath/$projectName"

    if [ ! -d "$projectPath" ]; then
        $MKDIR $projectPath
    else
        $RM $projectPath/
    fi

    $CP $1/ $projectPath/
}

menu() {
    echo -e "Choose one of the projects listed below\n"

    count=1
    for path in $(find $ADS_DIRECTORY_PROJECT_PATH/* -mindepth 1 -maxdepth 2 -type d); do
        echo "$count - Project="$(echo $path | cut -d '/' -f7)" IDE=$(echo $path | cut -d'/' -f8)"
        let "count += 1"
    done

    echo "Q - Quit"

    echo -e "\n"
    read -p "What is your choice? " option

    if [ "$option" == "q" ] || [ "$option" == "Q" ]; then
        echo "Bye bye" && exit 0
    fi
    
    if [ "$option" -lt "$count" ]; then
        pathCount=1
        for path in $(find $ADS_DIRECTORY_PROJECT_PATH/* -mindepth 1 -maxdepth 2 -type d); do
            if [ "$pathCount" == "$option" ]; then
                copyProjectFiles $path
                break
            fi
            let "pathCount += 1"
        done
    else
        CLEAR
        CAT <<"EOF"
                                                            #####
                                                        #### _\_  ________
                                                        ##=-[.].]| \      \
                                                        #(    _\ |  |------|
                                                        #   __| |  ||||||||
                                                        \  _/  |  ||||||||
                                                    .--'--'-. |  | ____ |
                                                    / __      `|__|[o__o]|
                                                    _(____nm_______ /____\____
    
EOF
        echo "I don't recognize your choice '$option', but don't worry, I'm going to show the menu and you can try again!"
        menu
    fi
}

#Script execution
setup