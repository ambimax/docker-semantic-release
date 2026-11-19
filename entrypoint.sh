#!/bin/sh

set -e

git config --global --add safe.directory '*' || true

echo ""
echo "Welcome to semantic-release by Ambimax"
echo ""
echo "Helm version:"
helm version
echo ""

error_exit() {
    echo "$1"
    exit 1;
}

case " $* " in
    *" --extends "*|*" -e "*) ;;
    *)
        if [ ! -f ".releaserc.json" ]; then
            cp /etc/.releaserc.json .releaserc.json
        fi
        ;;
esac

if [ $# -eq 0 ]; then
    set -- npx semantic-release
elif [ "${1#-}" != "${1}" ]; then
    set -- npx semantic-release "$@"
elif [ -z "$(command -v "${1}")" ]; then
    set -- node "$@"
fi

exec "$@"
