# Common functions for starting and stopping services.

# Check the correct user is used, otherwise the owner of logfiles can be changed.
check_user() {
    if [[ `whoami` == 'root' ]]; then
        echo "These scripts must only be run as the 'crap' user."
        exit 1
    fi
}

# Set TIMEOUT to override this.
DEFAULT_TIMEOUT=10

# First argument is process name/command line to match on.
terminate() {
    if [[ -n $TIMEOUT ]]; then
	timeout=$TIMEOUT
    else
	timeout=$DEFAULT_TIMEOUT
    fi

    if pgrep --full --count $1 > /dev/null; then
	echo "Asking" `pgrep --full --count $1` "$1 processes to terminate"
	pkill --signal TERM --full $1
    else
	echo "No running $1 processes"
	return
    fi

    sleep 1

    for i in `seq $timeout -1 1`; do
	pgrep --full --count $1 > /dev/null || break
	echo "Waiting $i seconds for" `pgrep --full --count $1` "$1 processes to terminate..."
	sleep 1
    done

    if pgrep --full --count $1 > /dev/null; then
	echo `pgrep --full --count $1` "$1 processes didn't terminate, killing them"
	pkill --signal KILL --full $1
    fi
}
