FROM node:24-slim AS builder
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

COPY . /app
WORKDIR /app
RUN npm install --frozen-lockfile
RUN npm run build

FROM scratch

COPY --from=builder /app/packages/backend/dist/ /extension/dist
COPY --from=builder /app/packages/backend/package.json /extension/
COPY --from=builder /app/packages/backend/media/ /extension/media
COPY --from=builder /app/LICENSE /extension/
COPY --from=builder /app/packages/backend/icon.png /extension/
COPY --from=builder /app/README.md /extension/

LABEL org.opencontainers.image.title="Podman Desktop Chaos Lab Extension" \
        org.opencontainers.image.description="Containers durability harness tool" \
        org.opencontainers.image.vendor="DevConf Podman Desktop / Extension demo" \
        io.podman-desktop.api.version=">= 1.22.0"
