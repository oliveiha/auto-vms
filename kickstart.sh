#!/bin/bash
set -e
VAGRANT_MACHINE=$1
echo -e ================== '\033[0;32m'Check Environemt Variables'\033[0m' ==================
echo You can use VM_PROXY, VM_NO_PROXY_HOSTS, VM_INTERNAL_CONNECTION_CHECK
if [ -z "$VM_PROXY" ]; then 
     echo -e NO VM_PROXY environment variable. '\033[0;33m'UP WITHOUT PROXY'\033[0m'
else
    echo -e '\033[0;33m'Found!'\033[0m' VM_PROXY environment variable. Running WITH proxy.
    if [ -z "$VM_NO_PROXY_HOSTS" ]; then 
        echo -e NO VM_NO_PROXY_HOSTS environment variable. '\033[0;33m'No Bypasses at Proxy'\033[0m'
    else
        echo -e '\033[0;33m'Found!'\033[0m' VM_NO_PROXY_HOSTS bypassing for: $VM_NO_PROXY_HOSTS .
    fi
    if [ -z "$VM_INTERNAL_CONNECTION_CHECK" ]; then 
        echo -e '\033[0;33m'No Connection Check at Internal Network.'\033[0m' VM_INTERNAL_CONNECTION_CHECK environment variable not set.
    else
        echo -e '\033[0;33m'Found!'\033[0m' VM_INTERNAL_CONNECTION_CHECK in: $VM_INTERNAL_CONNECTION_CHECK .
    fi
fi

echo -e ================== '\033[0;32m'Setup Start'\033[0m' ==================
curl https://gitlab.com/snippets/1690593/raw -o setup.temp.sh
chmod +x setup.temp.sh
echo -e Kickstarting Vagrant 
if [ -z "$VAGRANT_MACHINE" ]; then 
    ./setup.temp.sh --has_proxy true
else
    echo -e For Host: '\033[0;33m'$VAGRANT_MACHINE '\033[0m'
    ./setup.temp.sh -m $VAGRANT_MACHINE --has_proxy true 
fi
