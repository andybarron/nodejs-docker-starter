ARG NODE_VERSION="12.14"
ARG YARN_VERSION="1.21"

### Shared base stage
FROM node:${NODE_VERSION}-slim as base

# Configurable args
ARG NODE_ENV="production"

# Shared internal config
ENV NODE_ENV="${NODE_ENV}"
ENV DEV_TOOLS="build-essential git python"
ENV INSTALL_DEV_TOOLS="apt-get install -y ${DEV_TOOLS}"

# Fix some apt-get installs (e.g. postgres) failing on Debian slim images:
# https://github.com/debuerreotype/debuerreotype/issues/10#issuecomment-450480318
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done

# Update packages
RUN apt-get update -y

# If in dev mode, install the build tools in the shared base image
RUN if [ "${NODE_ENV}" != "production" ]; then ${INSTALL_DEV_TOOLS}; fi

# Install Yarn
RUN npm install --global --force yarn@${YARN_VERSION}

### Build stage
FROM base as builder

# TODO: Use Docker secrets for this
# Private npm access token
ARG NPM_TOKEN
ENV NPM_TOKEN="${NPM_TOKEN}"

# Fail if NPM_TOKEN is not defined
# RUN if [ -z "${NPM_TOKEN}" ]; then echo "Docker build-arg required: NPM_TOKEN" && exit 1; fi

# If in prod mode, install the build tools in the build stage only
RUN if [ "${NODE_ENV}" = "production" ]; then ${INSTALL_DEV_TOOLS}; fi

# Set up working dir and perms
RUN mkdir /app && chown node:node /app
WORKDIR /app

# Don't need root any more
USER node

# Install app dependencies
COPY --chown=node package.json yarn.lock .npmrc /app/
RUN echo '//registry.npmjs.org/:_authToken=${NPM_TOKEN}' > /app/.npmrc
RUN if [ "${NODE_ENV}" = "production" ]; then yarn --frozen-lockfile --production; else yarn; fi

# Copy source code
COPY --chown=node . /app/

# Build app
# RUN yarn build

### Run stage
FROM base as runtime

# This will be overriden in dev mode (see docker-compose.yml)
ENV NPM_TOKEN=""

# No root necessary
USER node

# Enable Yarn cache volume for local development
RUN mkdir -p /home/node/.cache/yarn

# Copy app
COPY --from=builder /app /app

WORKDIR /app
CMD yarn start
