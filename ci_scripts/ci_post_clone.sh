#!/bin/bash
set -e

echo "=== AutoBrew CI: Post Clone ==="

# Install XcodeGen if not available
if ! command -v xcodegen &> /dev/null; then
    echo "Installing XcodeGen..."
    brew install xcodegen
fi

# Generate Xcode project from project.yml
echo "Generating Xcode project..."
cd "$CI_PRIMARY_REPOSITORY_PATH"
xcodegen generate

echo "=== Post Clone Complete ==="
