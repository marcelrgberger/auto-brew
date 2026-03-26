#!/bin/bash
set -e

echo "=== AutoBrew CI: Post Build ==="

if [ "$CI_XCODEBUILD_EXIT_CODE" -eq 0 ]; then
    echo "Build succeeded"
else
    echo "Build failed with exit code: $CI_XCODEBUILD_EXIT_CODE"
    exit 1
fi

echo "=== Post Build Complete ==="
