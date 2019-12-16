#!/bin/bash

#global variables
DEBUG=true
ASD_DIRECTORY_PATH="$HOME/.atlassian/asd"
MKDIR="$(which mkdir) -p"
GIT="$(which git)"
ASD_REPOSITORY="git@bitbucket.org:phall_atlassian/atlassian-developer-stack.git"

install()
{
    checkDependencies
    setUpAsdDirectory
    cloneRepository
}

log()
{
    if  "$DEBUG" = true ; then
        echo $(date "+%d-%m-%Y - %T") : $1
    fi
}

# Check all dependencies needed to run ASD, it will abort the execution if any of the dependencies is missing.
checkDependencies()
{
    log "Checking all dependencies needed before we start ... "

    dependencies=("docker" "git")
    for dependency in "${dependencies[@]}"
    do 
        if [ "$(which $dependency)" = "" ]; then
            log "Atlassian Developer Stack requires '$dependency' to be installed in your enviroment. Please, fix it and try again"
            exit 1
        fi
    done

    log "Nice!!! You have all dependencies installed :-) ... Let's move on!"
}

# Set up the ASD directory, it will create the directory ($ASD_DIRECTORY_PATH) for current user if it does not exits.
setUpAsdDirectory()
{
    log  "Creating the asd's configuration folder for user '$USER' which is the user who is running this script"
    if [ ! -d $ASD_DIRECTORY_PATH ]; then
        log "The configuration folder '$ASD_DIRECTORY_PATH' does not exist, let's create it"
        $MKDIR $ASD_DIRECTORY_PATH;
        log "Folder '$ASD_DIRECTORY_PATH' successfully created"
    else
        log "The configuration folder '$ASD_DIRECTORY_PATH' already exists"
    fi
}

# Clone the ASD repository
cloneRepository()
{
   if [ `ls -A $ASD_DIRECTORY_PATH | wc -l` -eq 0 ]; then
        log "Cloning the repository"
        $GIT clone $ASD_REPOSITORY $ASD_DIRECTORY_PATH
   else 
        log "Updating the repository"
        $GIT -C $ASD_DIRECTORY_PATH pull
   fi
}

# Running the Installation
echo "Installing Atlassian Developer Stack (asd)"
install
echo "Atlassian Developer Stack (asd) successfully installed"