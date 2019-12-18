#!/bin/bash

#global variables
CLEAR="$(which clear)"
CAT="$(which cat)"
ASD_DIRECTORY_PROJECT_PATH="$HOME/.atlassian/asd/projects"

setup() {
    banner
    menu
}

banner() {
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
}

menu() {
    echo -e "Choose one of the projects listed below\n"

    count=1
    for path in $(find $ASD_DIRECTORY_PROJECT_PATH/* -mindepth 1 -maxdepth 2 -type d); do
        echo "$count - $path"
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
        for path in $(find $ASD_DIRECTORY_PROJECT_PATH/* -mindepth 1 -maxdepth 2 -type d); do
            if [ "$pathCount" == "$option" ]; then
                echo "Start copying from $path"
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
        echo "We don't recognize your choice '$option', but don't worry, I'm going to show the menu and you can try again!"
        menu
    fi
}

#Script execution
setup
