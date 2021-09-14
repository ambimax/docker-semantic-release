# ambimax / docker-semantic-release

Generates docker image for simple semantic releasing via github actions.

## What is Semantic Release?

Semantic Release solves one major problem in software development: Releasing software with versions that both make sense and are easy to create. It does this by analyzing git commits and deriving a new version for automatic releases from them.

### Git commits

Your git commits must follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format in order to provide meaning to semantic release.

Git commit message example for a normal fix:

```
fix: summary of changes
```

Git commit message example for a _breaking change_ release:

```
chore: Trigger major release for previous commits

BREAKING CHANGE: Did some stuff
```

**Example 1:**

You have worked on a **fix for an existing feature**. This fix does not break any backwards compatibility (i.e. the previous version works the same if upgraded to your new code). To now create a commit for this feature, you would have to type the following message:

`fix(JIRA-123): Add some awesome new feature`

> **Note**: The JIRA-123 is the ticket you are working on and everything past the : is the description for your addition. **This will increase the patch version.**

**Example 2:**

You have worked on a **new, isolated feature**. This feature does not break any backwards compatibility (i.e. the previous version works the same if upgraded to your new code). To now create a commit for this feature, you would have to type the following message:

`feat(JIRA-123): Add some awesome new feature`

> **Note**: The JIRA-123 is the ticket you are working on and everything past the : is the description for your addition. **This will increase the minor version.**

**Example 3:**

You have worked on a **new, backwards incompatible feature**. This feature does break backwards compatibility by changing some logic in other features. To now create a commit for this feature, you would have to type the following message:

`feat(JIRA-123): Add some awesome new feature

BREAKING CHANGE: Other feature now requires some changes to the configuration`

> **Note**: The JIRA-123 is the ticket you are working on and everything past the : is the description for your addition.
> The BREAKING CHANGE Is in the body of the commit (press <kbd>Enter</kbd> twice). Here you describe, what changed in the new version that makes it incompatible with the old version. **This will increase the major version**.

### Breaking changes

If a commit introduces a breaking change (regardless of the commit type), you can add a BREAKING CHANGE section to your commit. This will **automatically increase the major version** on next release.

### What if I made a mistake in one of my commits?

If you are working on a separate branch, you can simply [rewrite your commit messages](https://linuxize.com/post/change-git-commit-message/#changing-an-older-or-multiple-commits). You need to force push after the rebase.

## How can I add semantic release to my project?

### Configure semantic release

The plugin can be configured in the [**semantic-release** configuration file](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/configuration.md#configuration).

**Minimal example**

```js
{
  "branches": ["main", "master"],
  "tagFormat": "${version}",
  "plugins": [
    "@semantic-release/commit-analyzer",
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md"],
        "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ]
  ]
}
```

**PHP projects with composer.json example**

```js
{
  "branches": ["main", "master"],
  "tagFormat": "${version}",
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github",
    [
      "@semantic-release/changelog",
      {
        "changelogFile": "CHANGELOG.md"
      }
    ],
    "@ambimax/semantic-release-composer",
    [
      "@semantic-release/exec",
      {
        "prepareCmd": "echo \"SEMANTIC_VERSION=${nextRelease.version}\" >> $GITHUB_ENV && echo \"GIT_VERSION=v${nextRelease.version}\" >> $GITHUB_ENV"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["composer.json", "CHANGELOG.md"],
        "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ]
  ]
}
```

### Add Github action for semantic release

Add github action `.github/workflows/release.yml` for automatic release creation:

```yaml
name: Release

on:
  push:
    branches:
      - "main"
      - "master"

  pull_request:
    types:
      - opened
      - synchronize

jobs:
  package:
    name: "Release"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 1
          persist-credentials: false

      - name: Rollout semantic release
        id: release
        uses: docker://ambimax/semantic-release:latest
        env:
          GH_TOKEN: ${{ secrets.AMBIMAX_GITHUB_RELEASE_TOKEN }}
```

`GH_TOKEN` must have permissions to perform commits and releases on the Github repository!

## Sources

More information on this topic can be found on

- [Semantic release project](https://github.com/semantic-release/semantic-release)
- [The idea behind semantic versioning](https://semver.org/)
- [Conventional commits](https://www.conventionalcommits.org/)

## License

[MIT License](http://choosealicense.com/licenses/mit/)

## Author

- [Tobias Schifftner](https://twitter.com/tschifftner), [ambimax® GmbH](https://ambimax.de)
