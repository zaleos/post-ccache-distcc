#!/bin/bash

function _main() {
    # Note that you can add more build servers below if you enable them in the Vagrantfile
    init_distcc_build_server 10.22.66.101 16 # buildserver1
    #init_distcc_build_server 10.22.66.102 16 # buildserver2

    setup_distcc_env
    setup_ccache_env

    ccache -Ccz # Wipe local ccache, to force recompile on buildserver
    source build-local.sh
}

function setup_distcc_env() {
    # These settings are optional, but force compilation on remote hosts
    export DISTCC_VERBOSE=1          # Enable verbose debugg logs
    export DISTCC_FALLBACK=0         # Disable local compilation fallback
    export DISTCC_SKIP_LOCAL_RETRY=1 # Disable local compilation retry
}

function setup_ccache_env() {
    export CCACHE_PREFIX=distcc      # When ccache is called, call distcc first
    export CCACHE_DIRECT=true        # Enable the direct mode (https://ccache.dev/manual/3.7.8.html#_the_direct_mode)
}

function init_distcc_build_server() {
    local IP="$1"
    local THREADS="$2"
    if [ -z "$DISTCC_HOSTS" ]; then
        DISTCC_HOSTS=--randomize
    fi
    add_ip_to_known_hosts "$IP"
    export DISTCC_HOSTS="$DISTCC_HOSTS vagrant@$IP/$THREADS,lzo"
    local SSHCMD="ssh vagrant@$IP echo test"
    local PUBKEY_FILE=$HOME/.ssh/id_ecdsa.pub
    $SSHCMD >/dev/null || {
        >&2 echo "Cannot connect to $IP with vagrant. Please make sure you can connect passwordlessly with a private key."
        >&2 echo "You will likely have to copy the contents of your $PUBKEY_FILE file to the build server's"
        >&2 echo "/home/vagrant/.ssh/authorized_keys file,"
        >&2 echo "Then try this command:"
        >&2 echo "$SSHCMD"
        >&2 echo "Note: your pubkey is:"
        >&2 cat $PUBKEY_FILE
        exit 1
    }
}

function add_ip_to_known_hosts() {
    local IP="$1"
    local FILE=$HOME/.ssh/known_hosts

    if [ ! -f $FILE ]; then
        mkdir -p $HOME/.ssh
        touch $FILE
    fi

    if ! grep --silent "^$IP" $FILE; then
        ssh-keyscan -t rsa $IP >> $FILE
    fi
}

_main
