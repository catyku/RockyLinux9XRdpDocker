#!/bin/bash

start_xrdp_services() {
    # Preventing xrdp startup failure
    rm -rf /var/run/xrdp-sesman.pid
#    rm -rf /var/run/ibus-daemon.pid
    rm -rf /var/run/xrdp.pid
    rm -rf /var/run/xrdp/xrdp-sesman.pid
    rm -rf /var/run/xrdp/xrdp.pid
#    ibus-daemon -d 

    # Use exec ... to forward SIGNAL to child processes
    xrdp-sesman 
    exec xrdp -n
}

stop_xrdp_services() {
    #ibus-daemon --kill
    xrdp --kill
    xrdp-sesman --kill
    exit 0
}

echo Entryponit script is Running...
echo

users=$(($#/3))
mod=$(($# % 3))

echo "users is $users"
echo "mod is $mod"

if [[ $# -eq 0 ]]; then
    echo "No input parameters. exiting..."
    echo "there should be 3 input parameters per user"
    exit
fi

if [[ $mod -ne 0 ]]; then
    echo "incorrect input. exiting..."
    echo "there should be 3 input parameters per user"
    exit
fi
echo "You entered $users users"

while [ $# -ne 0 ]; do

    #echo "username is $1"
    useradd $1
    wait
    #getent passwd | grep foo
    echo $1:$2 | chpasswd
    wait
    #echo "sudo is $3"
    if [[ $3 == "yes" ]]; then
        usermod -aG wheel $1
    fi
    wait
    echo "user '$1' is added"

    cp /xsessionrc "/home/$1/.xsession"
    chown $1:$1 "/home/$1/.xsession"
    # Shift all the parameters down by three
    shift 3
done

echo -e "This script is ended\n"

echo -e "starting xrdp services...\n"

trap "stop_xrdp_services" SIGKILL SIGTERM SIGHUP SIGINT EXIT
start_xrdp_services
