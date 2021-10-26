#!/bin/sh
# Author: Tobias Schifftner
set -e

echo ""
echo "Welcome to semantic-release by Ambimax"
echo ""

error_exit() {
    echo "$1"
    exit 1;
}

if [ ! -f ".releaserc.json" ]; then
    cp /etc/.releaserc.json .releaserc.json
fi


if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
    set -- node "$@"
fi

exec "$@"
