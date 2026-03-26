#!/bin/bash
# Patches knownRegions in the generated .xcodeproj after xcodegen generate
# XcodeGen doesn't propagate all regions from .xcstrings files

PBXPROJ="AutoBrew.xcodeproj/project.pbxproj"

if [ ! -f "$PBXPROJ" ]; then
    echo "Error: $PBXPROJ not found" >&2
    exit 1
fi

python3 -c "
path = '$PBXPROJ'
with open(path, 'r') as f:
    content = f.read()

old = '''knownRegions = (
				Base,
				en,
			);'''

if old not in content:
    print('Warning: knownRegions pattern not found — may already be patched or format changed')
    exit(0)

new = '''knownRegions = (
				en,
				de,
				fr,
				it,
				nl,
				pl,
				\"pt-BR\",
				es,
				Base,
			);'''

content = content.replace(old, new)
with open(path, 'w') as f:
    f.write(content)
print('Patched knownRegions in', path)
"
