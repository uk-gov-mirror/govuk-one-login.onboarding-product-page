# Use a slim lts-supported version.
FROM node:24.22.1-alpine3.24@sha256:1200d815de24f8dcca745fbf7651d166034a35adbcad8860a8538ffff44f1420  AS production

# Expose any necessary ports (if your application requires it)
ARG PORT=3000
ENV PORT=$PORT
EXPOSE $PORT

# Set the working directory in the container
WORKDIR /app

# Copy the application code, see .dockerignore for exclusions
COPY . .

# Install project dependencies
RUN npm ci && npm run build && npm ci --omit=dev


# Add the Dynatrace OneAgent
COPY --from=khw46367.live.dynatrace.com/linux/oneagent-codemodules-musl:nodejs / /
ENV LD_PRELOAD=/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so

USER node
CMD npm start

HEALTHCHECK CMD wget --spider http://localhost:$PORT/healthcheck
