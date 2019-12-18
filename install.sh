#!/bin/bash

#global variables
DEBUG=true
ADS_DIRECTORY_PATH="$HOME/.atlassian/ads"
ADS_CONFIG_PATH="$HOME/.atlassian/ads/.config"
ADS_WORKSPACE_CONFIG="$ADS_CONFIG_PATH/workspace"
MKDIR="$(which mkdir) -p"
GIT="$(which git)"
ADS_REPOSITORY="git@bitbucket.org:phall_atlassian/atlassian-developer-stack.git"

install() {
    checkDependencies
    setUpAdsDirectory
    cloneRepository
    createSymbolicLinkToAdsSetup
    setWorkspaceDirectory
}

log() {
    if "$DEBUG" = true; then
        echo $(date "+%d-%m-%Y - %T") : $1
    fi
}

# Check all dependencies needed to run ADS, it will abort the execution if any of the dependencies is missing.
checkDependencies() {
    log "Checking all dependencies needed before we start ... "

    dependencies=("docker" "git")
    for dependency in "${dependencies[@]}"; do
        if [ "$(which $dependency)" = "" ]; then
            log "Atlassian Developer Stack requires '$dependency' to be installed in your enviroment. Please, fix it and try again"
            exit 1
        fi
    done

    log "Nice!!! You have all dependencies installed :-) ... Let's move on!"
}

# Set up the ADS directory, it will create the directory ($ADS_DIRECTORY_PATH) for current user if it does not exits.
setUpAdsDirectory() {
    log "Creating the Ads's configuration folder for user '$USER' which is the user who is running this script"
    if [ ! -d $ADS_DIRECTORY_PATH ]; then
        log "The configuration folder '$ADS_DIRECTORY_PATH' does not exist, let's create it"
        $MKDIR $ADS_DIRECTORY_PATH
        log "Folder '$ADS_DIRECTORY_PATH' successfully created"
    else
        log "The configuration folder '$ADS_DIRECTORY_PATH' already exists"
    fi
}

# Clone the ADS repository
cloneRepository() {
    if [ $(ls -A $ADS_DIRECTORY_PATH | wc -l) -eq 0 ]; then
        log "Cloning the repository"
        $GIT clone $ADS_REPOSITORY $ADS_DIRECTORY_PATH
    else
        log "Updating the repository"
        $GIT -C $ADS_DIRECTORY_PATH pull
    fi
}

# Create the symbolic link which will point to setup.sh
createSymbolicLinkToAdsSetup() {

    if [[ -L "/usr/local/bin/ads-setup" ]]; then
        $(rm /usr/local/bin/ads-setup)
    fi

    $(ln -s $ADS_DIRECTORY_PATH/setup.sh /usr/local/bin/ads-setup)
}

# Set the workspace directory to a config file
setWorkspaceDirectory() {
    read -p "Please, inform the path to your workspace (directory where you keep your projects) -> " pathToWorkspace
    if [ ! -d $pathToWorkspace ]; then
        log "The path '$pathToWorkspace' is either incorrect or does not exist, please try again!"
        setWorkspaceDirectory
    fi

    if [ ! -d $ADS_CONFIG_PATH ]; then
        log "Creating the config folder '$ADS_CONFIG_PATH'"
        $MKDIR $ADS_CONFIG_PATH
    fi

    log "Overwriting the content of the config file '$ADS_WORKSPACE_CONFIG' with '$pathToWorkspace'"
    echo $pathToWorkspace > $ADS_WORKSPACE_CONFIG
}

# Running the Installation
echo "Installing Atlassian Developer Stack (ads)"
install
echo "Atlassian Developer Stack (ads) successfully installed. Run the command ads-setup in your terminal to configure your project."
