# Claude.md

## Project overview

vale-ai-tells provides a Vale package for detecting linguistic patterns commonly associated with AI-generated prose. It provides 25 YAML rule files that flag vocabulary fingerprints, structural patterns, and rhetorical tells.

## Repository structure

```text
vale-ai-tells/
├── styles/ai-tells/          # Vale rule files (*.yml)
├── .github/workflows/        # Release automation
├── .pre-commit-config.yaml
├── .yamllint.yaml
├── .vale.ini                 # Sample configuration
├── Justfile
├── test-document.md          # Test file with AI patterns
└── test-false-positives.md   # Test file for false positive checks
```

## Development workflow

**First-time setup:**

```bash
just sync          # fetch external Vale styles (Google, write-good, proselint)
just prek-install  # install pre-commit hooks
```

**Testing rules locally:**

```bash
vale --config=.vale.ini test-document.md
```

**Running all linters:**

```bash
just lint           # run all linters (yaml, prose, markdown, spelling, messages)
just lint-yaml      # yamllint on all YAML files
just lint-prose     # Vale on all files
just lint-markdown  # rumdl on all Markdown files
just lint-spelling  # codespell
just lint-messages  # Vale on each rule's own message: field (dogfooding)
```

**Pre-commit hooks:**

```bash
just prek          # run hooks on staged files
just prek-all      # run hooks on all files
```

**Creating a release:**

```bash
git tag vX.Y.Z
git push --tags
```

The GitHub Actions workflow automatically creates a release with `ai-tells.zip`.

## Rule conventions

All rules use `error` level by default. Users can override this in their `.vale.ini`. Rule files use Vale's `existence` or `sequence` extensions. Each rule needs:

- `message`: Clear explanation of why the rule flags the pattern
- `level`: Always `error`
- `tokens` or `swap`: The patterns to match

Messages must pass the `ai-tells` style themselves: no em-dashes, no anthropomorphic
or cliché idioms, no quoting a flagged word as an example (give the good word instead).
Write each message as `AI <label>: '%s'. <concrete action>.` so agents can act on it.
`just lint-messages` enforces this via the `RuleMessage` View (selects the `message`
field with Dasel and lints it as prose); it runs as part of `just lint`.

## Tone

Appreciate the irony: an AI working on a tool that detects AI writing. Lean into it. Find the humor in flagging your own tendencies and catching yourself mid-cliché while helping humans spot the patterns you statistically tend to produce.

## Quality standards

Before committing changes:

1. Test against `test-document.md`
2. Ensure rules don't have excessive false positives
3. Update README.md if adding/removing rules
