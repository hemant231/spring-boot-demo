FROM mongo:latest

MAINTAINER hemant231

# Setup build environment
# ...
RUN apt-get update && apt-get install -y cron netcat-traditional netcat-openbsd

# Copy install & configuration scripts
# ...
COPY ./.docker/scripts /mongo_scripts

yes | cp -rf ./.docker/scripts/mongod.conf /etc

# Set execution permissions on scripts
# ...
RUN chmod +rx /mongo_scripts/*.sh

EXPOSE 8080

ENTRYPOINT ["/mongo_scripts/run.sh"]
