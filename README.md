# shellparty-wallet-dev-server

A simple web server that's designed to help with Shellparty Wallet development.

## Install

    npm install -g shellparty-wallet-dev-server

## Usage

Please adjust the wallet path according to your setup. The environment variable `WALLET_PATH` should point to where the _compiled_
source of the shellparty wallet is. And `SHELLBLOCKD_URL` should point to where your Shellblockd is running, probably including the
correct port number as in the following example:

    WALLET_PATH=shellnode/shellparty-wallet/build SHELLBLOCKD_URL=http://172.17.0.8:4421 shellparty-wallet-dev-server

