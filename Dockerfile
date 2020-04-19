# This file was auto-generated, do not edit it directly.
# Instead run bin/update_build_scripts from
# https://github.com/das7pad/sharelatex-dev-env

ARG NODE_VERSION
FROM node:${NODE_VERSION}

WORKDIR /runner
COPY runner/ /runner/
RUN npm ci

COPY bin /usr/local/bin

ENTRYPOINT []
CMD ["bash"]

ARG DATE
ARG RELEASE
ARG COMMIT
LABEL \
  org.opencontainers.image.created="$DATE" \
  org.opencontainers.image.authors="Jakob Ackermann <das7pad@outlook.com>" \
  org.opencontainers.image.url="https://github.com/das7pad/sharelatex-lint-runner" \
  org.opencontainers.image.documentation="" \
  org.opencontainers.image.source="https://github.com/das7pad/sharelatex-lint-runner" \
  org.opencontainers.image.version="$RELEASE" \
  org.opencontainers.image.revision="$COMMIT" \
  org.opencontainers.image.vendor="Jakob Ackermann" \
  org.opencontainers.image.licenses="AGPL-3.0" \
  org.opencontainers.image.ref.name="$RELEASE" \
  org.opencontainers.image.title="lint-runner" \
  org.opencontainers.image.description="lint Environment"
