#!/bin/bash

# Check all dependencies needed to run Atlassian Developer Stack
function checkDependencies(){
    echo "Checking all dependencies needed before we start ... "

    dependencies=("docker" "git")
    for dependency in "${dependencies[@]}"
    do 
        if [ "$(which $dependency)" = "" ] ;then
            echo "Atlassian Developer Stack requires '$dependency' to be installed in your enviroment. Please, fix it and try again."
            exit 1
        fi
    done

    echo "Nice!!! You have all dependencies installed :-) ... Let's move on!"
}

# Running the script
echo "Install Atlassian Developer Stack (asd)"
checkDependencies