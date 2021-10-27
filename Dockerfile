FROM node:lts-alpine

ENV GITHUB_TOKEN=
ENV NODE_ENV=production
ENV NODE_PATH=/usr/local/lib/node_modules/

WORKDIR /github/workspace

RUN apk update \
    && apk add --no-cache git openssh bash curl
RUN curl -L https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz | tar xz && mv linux-amd64/helm /bin/helm && rm -rf linux-amd64

COPY npm-install.sh /opt/
RUN --mount=type=secret,id=GITHUB_TOKEN /opt/npm-install.sh

COPY etc/.releaserc.json /etc/.releaserc.json
COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh

CMD ["npx", "semantic-release"]
