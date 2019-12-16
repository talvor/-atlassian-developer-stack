#!/bin/sh
# Handle signals
cleanup () {
	tput rc
	tput cnorm

    kill $PID
	RETURN=1
}
# This tries to catch any exit, to reset cursor
trap cleanup INT QUIT TERM

spinner () {
    PID=$1
    local MESSAGE=$2
    local i=1
    local sp="⣾⣽⣻⢿⡿⣟⣯⣷"

    RETURN=0

    tput sc
    tput civis

    while kill -0 $PID 2> /dev/null; do
        tput rc
        tput el
        printf "${sp:i++%${#sp}:1} $MESSAGE"
        sleep .2
    done

    tput cnorm
    echo ' '

    return $RETURN
}