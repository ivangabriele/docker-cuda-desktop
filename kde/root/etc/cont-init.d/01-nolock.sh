#!/usr/bin/with-contenv bash

set -eu
set -o pipefail

s6-setuidgid ubuntu mkdir -p "$HOME/.config"
s6-setuidgid ubuntu mv /misc/kscreenlockerrc "$HOME/.config/kscreenlockerrc"
