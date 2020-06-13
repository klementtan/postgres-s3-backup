#!/bin/bash
rm -rf venv
if [ -x "$(command -v virtualenv)" ]; then
  virtualenv venv
  echo "Actvating venv"
  soucre venv/bin/activate
  echo "Downloading req"
  pip3 install -r requirements.txt
elif [ -x "$(command -v pip3)" ]; then
  sudo pip3 install virtualenv
  virtualenv venv 
  souce venv/bin/activate
  pip3 install -r requirements.txt
else 
  sudo pip install virtualenv
  virtualenv venv 
  souce ./venv/bin/activate
  pip install -r requirements.txt 
fi



cwd=$(pwd)

(crontab -l 2>/dev/null; echo "0 18 * * * cd ${cwd} && . venv/bin/activate && $(which python3) main.py >> ~/cron.log && deactivate") | crontab -