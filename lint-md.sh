#!/bin/bash
set -e

# Parse arguments
FIX=false
if [[ "$1" == "--fix" ]]; then
    FIX=true
fi

echo "Running Markdown linting..."

# Check that markdownlint-cli is available.
if ! command -v markdownlint &> /dev/null; then
    echo "Error: markdownlint not found"
    echo "Install with:"
    echo "- \`npm install -g markdownlint-cli\`"
    exit 1
fi

# Verify markdownlint version.
MARKDOWNLINT_VERSION=$(markdownlint --version | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
if [[ ! "$MARKDOWNLINT_VERSION" =~ ^0\.44\. ]]; then
    echo "Error: Expected markdownlint version 0.44.x but got $MARKDOWNLINT_VERSION"
    exit 1
fi

# Run markdownlint:
# - Include all .md files.
# - Exclude files in valkey-glide submodule.
# - Exclude files in vendor directory.
MARKDOWNLINT_OPTIONS=""
if [ "$FIX" = true ]; then
    MARKDOWNLINT_OPTIONS="--fix"
fi

find . -name "*.md" -print0 | \
    grep -zv "valkey-glide/" | \
    grep -zv "vendor/" | \
    xargs -0 -r markdownlint $MARKDOWNLINT_OPTIONS

echo "✓ Markdown linting completed!"
