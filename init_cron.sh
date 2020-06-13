#!/bin/bash

cwd=$(pwd)

(crontab -l 2>/dev/null; echo "0 18 * * * cd ${cwd} && . venv/bin/activate && $(which python3) main.py >> ~/cron.log && deactivate") | crontab -