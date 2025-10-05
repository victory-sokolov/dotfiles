#!/bin/sh
#
# Wait for a command to be successful.
# First argument is the number of seconds to wait between retries.
# The rest of the arguments are the command to execute.
#
# Example 1: ./wait-for.sh 10 "ping -c 1 example.com"
# Example 2: ./wait-for.sh 15 ping -c 1 example.com
#
# Taken from: https://github.com/softwarepatterns-com/sh-utilities/blob/main/wait-for.sh 

# Check if at least two arguments are given
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <number_of_seconds> <command> [command arguments]"
    exit 1
fi

# Assign the first argument to SLEEP_DURATION and the rest to COMMAND
SLEEP_DURATION=$1
shift
COMMAND="$*"

# Run the command repeatedly until successful
while true; do
    echo "Executing command: $COMMAND"
    if $COMMAND; then
        echo "Command was successful. Exiting."
        break
    else
        echo "Command failed. Retrying in $SLEEP_DURATION seconds..."
        sleep $SLEEP_DURATION
    fi
done
