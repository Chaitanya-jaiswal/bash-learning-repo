#!/bin/bash
DEBUG=${DEBUG:-0}

debug() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "[DEBUG] $*" >&2
    fi
}

main() {
    debug "Started with $# args"
    echo "Processing..."
}

main "$@"
