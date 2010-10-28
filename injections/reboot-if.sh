#!/bin/bash

# Listen on a TCP port and await reboot or shutdown commands.
# Especially useful on a minimal system lacking even an sshd.
# Or as a backup in case sshd isn't servicing requests.
#
# It's a good idea to use nc so you have a clear line feed.
#

#
# Use with
# tcpsvd localhost 5000 ./reboot-if.sh
# as the server, and
# (echo reboot ; echo quit) | nc -q 5 host port
# as the client.
#

cmd_reboot () {

    rf="$1"

    echo Executing reboot statement!
#    $rf
    echo b > /proc/sysrq-trigger
    retval="$?"
    echo Command $rf returned "$retval"

}

cmd_shutdown () {

    sf="$@"

    echo Executing shutdown statement!
#    "$sf"
    echo o > /proc/sysrq-trigger
    retval="$?"
    echo "$sf" returned "$retval"
    
}

while read line
do
    
    echo Got line: "$line"

    if [ "$line" == "reboot" ]; then
	#cmd_reboot /sbin/reboot
	#cmd_reboot /usr/bin/reboot-now
	cmd_reboot
    fi


    if [ "$line" == "shutdown" ]; then
	#cmd_shutdown /sbin/shutdown -r -t 10 now
	#cmd_shutdown /usr/bin/shutdown-now
	cmd_shutdown
    fi

    if [ "$line" == "quit" ]; then

	echo Exiting.
	exit 0

    fi

done
