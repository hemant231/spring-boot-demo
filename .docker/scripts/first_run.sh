#!/bin/bash

# Set Install Environment Varaibles (See mongo.env)
# ...
ROOT_DB="admin"
ROOT_USER=${MONGODB_ROOT_USERNAME}
# ROOT_PASS=${MONGODB_ROOT_PASSWORD:-$(pwgen -s -1 16)}
ROOT_PASS=${MONGODB_ROOT_PASSWORD}
ROOT_ROLE=${MONGODB_ROOT_ROLE}

USER=${MONGODB_USERNAME}
PASS=${MONGODB_PASSWORD}
DB=${MONGODB_DBNAME}
ROLE=${MONGODB_ROLE}

# Start MongoDB service
# ...
echo "Starting MongoDB to add users and roles...."
/usr/bin/mongod &
while ! nc -vz localhost 27017; do sleep 1; done

# Create Root User if defined in mongo.env
# ...
if [[ -n $ROOT_USER ]] && [[ -n $ROOT_PASS ]] && [[ -n $ROOT_ROLE ]]
then
	echo "Creating root user: \"$ROOT_USER\"..."
	mongo $ROOT_DB --eval "db.createUser({ user: '$ROOT_USER', pwd: '$ROOT_PASS', roles: [ { role: '$ROOT_ROLE', db: '$ROOT_DB' } ] });"
fi

# Create Web User if defined in mongo.env
# ...
if [[ -n $USER ]] && [[ -n $PASS ]] && [[ -n $ROLE ]] && [[ -n $DB ]]
then
	echo "Creating web user: \"$USER\"..."
	mongo $DB --eval "db.createUser({ user: '$USER', pwd: '$PASS', roles: [ { role: '$ROLE', db: '$DB' } ] });"
fi

echo "MongoDB users and roles are set...."


# Load MongoDB Seed Data
# ...
echo "Starting MongoDB data seed...."
DATA_FILES=/mongo_data/
FILES=/mongo_data/*
if [ -d "$DATA_FILES" ]; then
  for f in $FILES
  do
    echo "Importing $f data..."
      /usr/bin/mongoimport --db $DB --collection users --type json --drop --file $f --jsonArray
    cat $f
  done
fi
echo "Completed MongoDB data seed...."


# Shutdown MongoDB service
# ...
echo "Shutting down MongoDB...."
/usr/bin/mongod --shutdown

echo "========================================================================"
echo "MongoDB Root User: $ROOT_USER"
echo "MongoDB Root Role: $ROOT_ROLE"
echo "========================================================================"
echo "========================================================================"
echo "MongoDB User: $USER"
echo "MongoDB Database: $DB"
echo "MongoDB Role: $ROLE"

# Unset Sensitive environment variables
# ...
export MONGODB_ROOT_PASSWORD=""
export MONGODB_PASSWORD=""

rm -f /.firstrun
