#!/bin/bash
set -x

EXECUTABLE=/usr/local/bin/metrixd
DIR=$HOME/.metrix
FILENAME=metrix.conf
FILE=$DIR/$FILENAME
PORT=${PORT}
MASTERNODEGENKEY=${MASTERNODEGENKEY}

# create directory and config file if it does not exist yet
if [ ! -e "$FILE" ]; then
    mkdir -p $DIR

    echo "Creating $FILENAME"

    # Seed a random password for JSON RPC server
    cat <<EOF > $FILE
printtoconsole=${PRINTTOCONSOLE:-1}
rpcport=${PORT}
rpcbind=127.0.0.1
rpcallowip=10.0.0.0/8
rpcallowip=172.16.0.0/12
rpcallowip=192.168.0.0/16
externalip=${EXTERNAL_IP}
server=0
daemon=0
listen=1
listenonion=0
maxconnections=64
masternode=1
rpcuser=${RPCUSER:-metrixrpc}
rpcpassword=${RPCPASSWORD:-`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`}
masternodeprivkey=${MASTERNODEGENKEY}
EOF
fi

cat $FILE
ls -lah $DIR/

echo "Initialization completed successfully"
exec $EXECUTABLE
