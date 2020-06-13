#!/bin/bash

rm -rf venv
if [ -x "$(command -v virtualenv)" ]; then
  virtualenv venv
  soucre venv/bin/activate
elif [ -x "$(command -v pip3)" ]; then
  sudo pip3 install virtualenv
  virtualenv venv
  souce venv/bin/activate
else
  sudo pip install virtualenv
  virtualenv venv
  souce ./venv/bin/activate
fi

if [ -x "$(command -v pip3)" ]; then
  pip3 install -r requirements.txt
else
  pip install -r requirements.txte
fi

source venv

cwd=$(pwd)

(crontab -l 2>/dev/null; echo "0 18 * * * cd ${cwd} &&" \
" . venv/bin/activate && $(which python3) main.py "\
">> ~/cron.log && deactivate") | crontab -

deactivate