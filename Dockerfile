FROM node:lts-alpine

ARG GITHUB_TOKEN
ENV NODE_ENV=production
ENV NODE_PATH=/usr/local/lib/node_modules/

WORKDIR /github/workspace

RUN echo -e "//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}\n \
    @ambimax:registry=https://npm.pkg.github.com" >> /root/.npmrc

RUN npm install --global \
    @ambimax/semantic-release-composer@1.0.2 \
    semantic-release@v17.3.7 \
    @semantic-release/changelog@^5.0.1 \
    @semantic-release/exec@^5.0.0 \
    @semantic-release/commit-analyzer@^8.0.1 \
    semantic-release-docker@v2.2.0 \
    @semantic-release/git@^9.0.0 \
    @semantic-release/github@^7.2.0 \
    @semantic-release/release-notes-generator@^9.0.1

COPY etc/.releaserc.json /etc/.releaserc.json
COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN apk update \
    && apk add --no-cache git openssh bash \
    && rm -f /root/.npmrc

CMD ["npx", "semantic-release"]
