#!/bin/sh

set -eux -o pipefail

sudo chown -Rf developer:developer .
find . -type d -exec sudo chmod 755 {} +
git checkout .
fnm install
npm install
