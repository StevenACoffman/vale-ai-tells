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

## Release flow

### 1. Confirm the tree is clean and linted

```bash
just lint
```

### 2. Preview the pending changelog

```bash
just preview-changelog
```

This shows the entries `cog` generates for the commits since the last tag.
If a commit is missing, check its subject for a valid Conventional Commit
prefix.

### 3. Regenerate the changelog

```bash
just generate-changelog
```

This overwrites `CHANGELOG.md`. Review the result and confirm the new version
section is present, then commit it:

```bash
git add CHANGELOG.md
git commit -m "chore: update changelog for vX.Y.Z"
```

### 4. Update the README rule count

If you added or removed rules, update the rule count and the package download
URLs in `README.md` so they point at the new tag.

### 5. Tag, push, and publish

```bash
just release vX.Y.Z
```

The `release` recipe does the following:

1. Creates an annotated tag with `just tag`.
2. Pushes the branch and the tag.
3. Waits for the `release.yml` GitHub Actions workflow to finish.
4. Copies the version's `CHANGELOG.md` section into the release notes with
   `just update-release-notes`.
5. Prints the release URL.

## What the workflow builds

The `release.yml` workflow triggers on any `v*` tag and attaches three
artifacts to the release. The workflow builds:

- `ai-tells.zip`: the main prose style package.
- `ai-tells-commits.zip`: the commit-message style package.
- `ai-tells-experimental.zip`: the experimental package, including its Tengo
  scripts under `config/`.

The workflow also extracts release notes from the matching `CHANGELOG.md`
section. If no section matches the tag, the workflow fails, so make sure step 3
ran before you tag.

## Fixing a published release

To sync the notes after editing `CHANGELOG.md`:

```bash
just update-release-notes vX.Y.Z
```

To replace an attached artifact without re-tagging:

```bash
gh release upload vX.Y.Z ai-tells.zip --clobber
```
