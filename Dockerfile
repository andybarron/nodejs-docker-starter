ARG NODE_VERSION="12.14"
ARG YARN_VERSION="1.21"

### Shared base stage
FROM node:${NODE_VERSION}-slim as base

# Configurable args
ARG DEV_MODE="false"

# Shared internal config
ENV DEV_MODE="${DEV_MODE}"
ENV DEV_TOOLS="build-essential git python"
ENV INSTALL_DEV_TOOLS="apt-get install -y ${DEV_TOOLS}"

# Fix some apt-get installs (e.g. postgres) failing on Debian slim images:
# https://github.com/debuerreotype/debuerreotype/issues/10#issuecomment-450480318
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done

# Update packages
RUN apt-get update -y

# If in dev mode, install the build tools in the shared base image
RUN if [ "${DEV_MODE}" = "true" ]; then ${INSTALL_DEV_TOOLS}; fi

# Install Yarn
RUN npm install --global --force yarn@${YARN_VERSION}

### Build stage
FROM base as builder

# If not in dev mode, install the build tools in the build stage only
RUN if [ "${DEV_MODE}" != "true" ]; then ${INSTALL_DEV_TOOLS}; fi

# Set up working dir and perms
RUN mkdir /app && chown node:node /app
WORKDIR /app

# Don't need root any more
USER node

# Install app dependencies
COPY --chown=node package.json yarn.lock /app/
RUN if [ "${DEV_MODE}" != "true" ]; then yarn --frozen-lockfile; else yarn; fi

# Copy source code
COPY --chown=node . /app/

### Run stage
FROM base as runtime
USER node

# Enable Yarn cache volume for local development
RUN mkdir -p /home/node/.cache/yarn

# Copy app
COPY --from=builder /app /app

WORKDIR /app
CMD yarn start
