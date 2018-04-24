#!/bin/bash

if [[ -e /.firstrun ]]; then
    echo "Executing entrypoint.sh"
    /mongo_scripts/entrypoint.sh

    echo "Executing first_run.sh"
    /mongo_scripts/first_run.sh
fi

# Start MongoDB
# ...
echo "Starting MongoDB..."
/usr/bin/mongod --bind_ip 0.0.0.0 --auth $@
