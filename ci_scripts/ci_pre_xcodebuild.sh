#!/bin/bash
set -e

echo "=== AutoBrew CI: Pre Build ==="
echo "Scheme: $CI_XCODEBUILD_ACTION"
echo "Branch: $CI_BRANCH"
echo "Build Number: $CI_BUILD_NUMBER"

# Increment build number from Xcode Cloud
if [ -n "$CI_BUILD_NUMBER" ]; then
    cd "$CI_PRIMARY_REPOSITORY_PATH"
    sed -i '' "s/CURRENT_PROJECT_VERSION: .*/CURRENT_PROJECT_VERSION: \"$CI_BUILD_NUMBER\"/" project.yml
    xcodegen generate
    echo "Build number set to $CI_BUILD_NUMBER"
fi

echo "=== Pre Build Complete ==="
