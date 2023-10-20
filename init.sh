#!/bin/bash
set -e

sed 's~Exec=/usr/share/code/code~Exec=/usr/share/code/code --no-sandbox~' \
  /usr/share/applications/code.desktop > /usr/share/applications/code.desktop
