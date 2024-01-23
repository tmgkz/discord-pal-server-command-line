#!/bin/bash

pip install -r requirements.txt

if [ ! -e settings.json ]; then
    echo -n 'Please type discord bot token: '
    read -r TOKEN
    jq -n --arg token "$TOKEN" \
    '{
        "token":$token
    }' > settings.json
fi

if [ ! -e /etc/systemd/system/discord-pal-server-command ]; then
    SERVICE_NAME="discord-pal-server-command"
    UNIT_FILE="/etc/systemd/system/$SERVICE_NAME.service"
    SCRIPT_PATH="$(pwd)/main.py"

    echo -n '------------------------------------------------------'
    echo -n ''
    echo -n 'This is the setting for automatic execution by Systemd'
    echo -n 'Please type run user: '
    read -r USER

    echo -n 'Please type run group: '
    read -r GROUP

    # Unit file
    echo "[Unit]
Description=Discord CommandLine
After=network.target

[Service]
ExecStart=/usr/bin/python3 $SCRIPT_PATH
Restart=always
User=$USER
Group=$GROUP

[Install]
WantedBy=default.target" > "$UNIT_FILE"

    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"
    sudo systemctl start "$SERVICE_NAME"
fi

echo "Finished!"