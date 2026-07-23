# Release process

This document describes how to cut a release of vale-ai-tells and publish the
style packages as GitHub release artifacts.

## Prerequisites

Local command-line tools plus the GitHub CLI drive releases. Install everything
from the `Brewfile`:

```bash
brew bundle install
```

The release flow requires:

| Tool | Purpose | Install |
| --- | --- | --- |
| `just` | Runs the release recipes in the `Justfile`. | `brew install just` |
| `cog` (cocogitto) | Builds `CHANGELOG.md` from Conventional Commits. | `brew install cocogitto` |
| `vale` | Lints prose and the rule files before you tag. | `brew install vale` |
| `rumdl` | Formats and lints the generated Markdown. | `brew install rumdl` |
| `gh` | Creates the release and edits its notes. | `brew install gh` |

Verify the tools are on your `PATH` (Homebrew installs them under
`/opt/homebrew/bin`):

```bash
just --version
cog --version
vale --version
```

Authenticate the GitHub CLI once with `gh auth login`.

## Commit format

`cog` parses [Conventional Commits](https://www.conventionalcommits.org/), so
every commit that should appear in the changelog needs a lowercase type prefix:

- `feat:` becomes a Features entry.
- `fix:` becomes a Bug Fixes entry.
- `chore:` and `test:` are omitted from the changelog (see `cog.toml`).

`cog` drops any subject without a recognized prefix, such as `Fix a bug`, from
the changelog. Use `fix: a bug` instead.

## How the version section reaches the tag

`cog` writes a `## [vX.Y.Z]` changelog section only when it cuts that version.
The section, the commit that carries it, and the tag must all land together,
because the release workflow reads `CHANGELOG.md` from the tagged commit.
`cog bump` does all three in one step, so prefer it over tagging by hand.
Tagging first and regenerating the changelog afterward leaves the section in a
commit that sits after the tag, and the workflow then finds no notes.

## Release flow

### 1. Confirm the tree is clean and linted

```bash
just lint
git status --short
```

`cog bump` refuses to run against an unclean tree, so commit or stash any
pending work first. Give each commit a Conventional Commit prefix so `cog` can
classify it.

### 2. Preview the pending changelog

```bash
just preview-changelog
```

This shows the entries `cog` generates for the commits since the last tag. If a
commit is missing, check its subject for a valid Conventional Commit prefix.

### 3. Update the README rule count

If you added or removed rules, update the rule count and the package download
URLs in `README.md` so they point at the new tag. Commit that change before you
bump.

### 4. Cut the version with cog bump

```bash
cog bump --version 1.26.0
```

`cog bump` writes the `## [v1.26.0]` section into `CHANGELOG.md`, commits it, and
creates the tag on that commit. Use `--auto` instead of `--version` to let `cog`
pick the next number from the Conventional Commit history. Confirm the notes
extract before you push:

```bash
scripts/extract-release-notes.sh v1.26.0
```

### 5. Build the artifacts locally

```bash
just build-packages
unzip -l dist/ai-tells-experimental.zip
```

This step is optional, and it lets you inspect the exact zips a release
publishes.

### 6. Publish

Push the commit and the tag, then let the workflow build and attach the zips:

```bash
git push && git push --tags
```

To publish without waiting on the workflow, create the release from the local
artifacts instead:

```bash
scripts/extract-release-notes.sh v1.26.0 release-notes.md
gh release create v1.26.0 \
  dist/ai-tells.zip dist/ai-tells-commits.zip dist/ai-tells-experimental.zip \
  --title v1.26.0 --notes-file release-notes.md
git push && git push --tags
```

The tag push still triggers the workflow, which updates the same release.

## What the workflow builds

The `release.yml` workflow triggers on any `v*` tag and attaches three
artifacts to the release:

- `ai-tells.zip`: the main prose style package.
- `ai-tells-commits.zip`: the commit-message style package.
- `ai-tells-experimental.zip`: the experimental package, including its Tengo
  scripts under `config/`.

The workflow does not build these inline. It calls two scripts that you can also
run locally:

- `scripts/build-packages.sh [output-dir]` builds the three zips into
  `dist/` by default. Run `just build-packages` to inspect the exact artifacts a
  release would publish.
- `scripts/extract-release-notes.sh <version> [output-file]` prints the
  `CHANGELOG.md` section for a version and exits non-zero when no section
  matches. Use it to check the notes before you tag.

If no section matches the tag, the workflow fails, so cut the version with
`cog bump` (step 4) rather than tagging by hand.

## Recovering from a tag placed too early

If a tag already points at a commit whose `CHANGELOG.md` has no matching
section, the release cannot publish. Confirm the gap, then re-cut the version.

```bash
scripts/extract-release-notes.sh v1.26.0   # reports "No CHANGELOG section found"
```

Delete the tag locally and on the remote, then run the release flow from step 4.
This is safe only when no release consumes the tag yet. Check with
`gh release view v1.26.0` first.

```bash
git tag -d v1.26.0
git push origin :refs/tags/v1.26.0
cog bump --version 1.26.0
```

## Fixing a published release

To sync the notes after editing `CHANGELOG.md`:

```bash
just update-release-notes vX.Y.Z
```

To replace an attached artifact without re-tagging:

```bash
gh release upload vX.Y.Z ai-tells.zip --clobber
```
