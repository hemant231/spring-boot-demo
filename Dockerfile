FROM mongo:3.4.4

MAINTAINER hemant231

# Setup build environment
# ...
RUN apt-get update && apt-get install -y cron netcat-traditional netcat-openbsd

# Copy install & configuration scripts
# ...
COPY ./.docker/scripts /mongo_scripts

COPY ./.docker/scripts/mongod.conf /etc/

# Set execution permissions on scripts
# ...
RUN chmod +rx /mongo_scripts/*.sh

EXPOSE 27107

ENTRYPOINT ["/mongo_scripts/run1.sh"]
