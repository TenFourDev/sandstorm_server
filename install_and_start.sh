#!/bin/bash
set -e

SERVER_DIR="/home/steam/server"

echo "==> Checking for Insurgency: Sandstorm server updates..."

# print current user
echo "==> Current user: $(whoami)"

# print current working directory
echo "==> Current working directory: $(pwd)"

# print permissions of the server directory
echo "==> Permissions of the server directory:"
ls -ld "/home/steam/server"

steamcmd \
    +force_install_dir "$SERVER_DIR" \
    +login anonymous \
    +app_update 581330 \
    +quit

echo "==> Insurgency: Sandstorm server is up to date."
echo "==> Starting server..."

cd "$SERVER_DIR"

exec ./start.sh