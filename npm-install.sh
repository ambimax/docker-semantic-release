#!/usr/bin/env bash

trap "rm -f /root/.npmrc" EXIT

echo -e "//npm.pkg.github.com/:_authToken=$(cat /run/secrets/GITHUB_TOKEN)\n \
    @ambimax:registry=https://npm.pkg.github.com" >> /root/.npmrc

npm install --global \
    @ambimax/semantic-release-composer@1.0.2 \
    semantic-release@v17.4.7 \
    @semantic-release/changelog@^5.0.1 \
    @semantic-release/exec@^5.0.0 \
    @semantic-release/commit-analyzer@^8.0.1 \
    semantic-release-docker@v2.2.0 \
    @semantic-release/git@^9.0.1 \
    @semantic-release/github@^7.2.3 \
    @semantic-release/release-notes-generator@^9.0.3 \
    @semantic-release-helm@^v2.1.0
