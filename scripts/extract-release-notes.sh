#!/usr/bin/env bash
# Extract the CHANGELOG.md section for a release version.
#
# This runs in CI (see .github/workflows/release.yml) and can also be run
# locally to preview the notes a release would attach.
#
# Usage: scripts/extract-release-notes.sh <version> [output-file]
#   version      Release version, with or without a leading "v" (e.g. v1.26.0).
#   output-file  File to write the notes to (default: stdout).

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <version> [output-file]" >&2
  exit 2
fi

repo_root=$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)
version=${1#v}
out_file=${2:-}

# Escape dots so the version matches literally in the awk regex below.
ver_re=${version//./\\.}

# Capture the lines under the target version's header up to the next release
# header. Headers look like "## [v1.25.0](compare-url) - 2026-07-17" (cocogitto
# output) or "## [1.25.0] - 2026-07-17" (hand-written); the optional "v?" covers
# both. Drop the "- - -" separators cog inserts between releases and the vale
# control comments, then trim leading blank lines.
notes=$(awk -v ver="$ver_re" '
    /^## / {flag = ($0 ~ ("\\[v?" ver "\\]")); next}
    flag && /^- - -[[:space:]]*$/ {next}
    flag
  ' "$repo_root/CHANGELOG.md" \
  | sed -E '/^<!-- vale (off|on) -->$/d' \
  | awk 'NF{found=1} found')

if [ -z "$notes" ]; then
  echo "No CHANGELOG section found for v${version}" >&2
  exit 1
fi

if [ -n "$out_file" ]; then
  printf '%s\n' "$notes" > "$out_file"
else
  printf '%s\n' "$notes"
fi
