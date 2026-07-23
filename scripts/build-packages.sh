#!/usr/bin/env bash
# Build the vale-ai-tells release artifacts: the three style-package zips.
#
# This runs in CI (see .github/workflows/release.yml) and can also be run
# locally to inspect the exact artifacts a release would publish.
#
# Usage: scripts/build-packages.sh [output-dir]
#   output-dir  Directory to write the .zip files to (default: dist).

set -euo pipefail

repo_root=$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)

out_dir=${1:-dist}
mkdir -p "$out_dir"
out_dir=$(cd "$out_dir" && pwd)

cd "$repo_root"

echo "Building packages into $out_dir"

# zip appends to an existing archive, so start from a clean slate. This keeps
# repeated local runs identical to a fresh CI checkout.
rm -f "$out_dir/ai-tells.zip" \
      "$out_dir/ai-tells-commits.zip" \
      "$out_dir/ai-tells-experimental.zip"

# ai-tells and ai-tells-commits are style-only packages (flat zip).
(cd styles && zip -r "$out_dir/ai-tells.zip" ai-tells)
(cd styles && zip -r "$out_dir/ai-tells-commits.zip" ai-tells-commits)

# ai-tells-experimental includes Tengo scripts in config/. Vale's package sync
# expects a top-level dir wrapping a styles/ subtree so it can merge into
# StylesPath. Assemble that layout in a temp dir so nothing lands in the repo.
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

mkdir -p "$work_dir/ai-tells-experimental/styles"
cp -r styles/ai-tells-experimental "$work_dir/ai-tells-experimental/styles/"
# Copy config but exclude the project vocabulary (not part of the package).
rsync -a --exclude='vocabularies/' styles/config/ \
  "$work_dir/ai-tells-experimental/styles/config/"
(cd "$work_dir" && zip -r "$out_dir/ai-tells-experimental.zip" ai-tells-experimental)

echo "Built:"
ls -lh "$out_dir"/ai-tells.zip \
       "$out_dir"/ai-tells-commits.zip \
       "$out_dir"/ai-tells-experimental.zip
