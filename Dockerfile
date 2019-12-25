ARG NODE_VERSION="12.14"
ARG YARN_VERSION="1.21"

### Shared base stage
FROM node:${NODE_VERSION}-slim as base

# Configurable args
ARG DEV_MODE="false"

# Shared internal config
ENV DEV_MODE="${DEV_MODE}"
ENV INSTALL_DEV_TOOLS="apt-get update -y && apt-get install -y build-essential git python"

# If in dev mode, install the build tools in the shared base image
RUN if [ "${DEV_MODE}" = "true" ]; then eval "${INSTALL_DEV_TOOLS}"; fi

# Install Yarn
RUN npm install --global --force yarn@${YARN_VERSION}

### Build stage
FROM base as builder

# If not in dev mode, install the build tools in the build stage only
RUN if [ "${DEV_MODE}" != "true" ]; then eval "${INSTALL_DEV_TOOLS}"; fi

# Set up working dir and perms
RUN mkdir /app && chown node:node /app
WORKDIR /app

# Don't need root any more
USER node

# Install app dependencies
COPY --chown=node package.json yarn.lock /app/
RUN YARN_FLAGS=$([ "${DEV_MODE}" = "true" ] && echo "--production --frozen-lockfile" || echo "")
RUN yarn ${YARN_FLAGS}

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
