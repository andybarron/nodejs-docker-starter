FROM node:12
WORKDIR /usr/src/app
RUN npm config set unsafe-perm true

# postgres
RUN export LC_ALL=en_US.UTF-8
RUN export LANG=en_US.UTF-8
# RUN locale-gen en_US.UTF-8
RUN apt-get update
RUN apt-get install postgresql-client -y
