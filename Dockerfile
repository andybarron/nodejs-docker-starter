ARG NODE_VERSION=12
ARG YARN_VERSION=1.19

# Build stage
FROM node:$NODE_VERSION-alpine as builder

# Install correct Yarn version
RUN npm install --global --force yarn@$YARN_VERSION

# Set up build tooling
RUN apk update && apk add build-base git python

# Set up working dir and perms
RUN mkdir -p /app && chown -R node: /app
WORKDIR /app

# Don't need root any more!
USER node

# development: "node:node"
ARG COPY_OWNER=root
RUN echo COPY_OWNER = $COPY_OWNER

# development: ""
ARG YARN_FLAGS="--production --frozen-lockfile"
RUN echo YARN_FLAGS = $YARN_FLAGS

# Install NPM dependencies
COPY --chown=$COPY_OWNER package.json yarn.lock /app/
RUN yarn $YARN_FLAGS

# Build app
COPY --chown=$COPY_OWNER . /app/

# Run stage
FROM node:$NODE_VERSION-alpine as runtime

# Install correct Yarn version (again)
RUN npm install --global --force yarn@$YARN_VERSION

# development: "build-base git python openssh-client bash zsh"
ARG DEV_TOOLS=
RUN echo DEV_TOOLS = $DEV_TOOLS

# Potentially install some dev tools for local development
RUN [[ -n "$DEV_TOOLS" ]] && apk update && apk add $DEV_TOOLS \
  && echo "Installed dev tools: $DEV_TOOLS" \
  || echo "No dev tools specified"

# Copy app
USER node
COPY --from=builder /app /app

# Enable Yarn cache volume for local development
RUN mkdir -p /home/node/.cache/yarn

WORKDIR /app
CMD yarn start
