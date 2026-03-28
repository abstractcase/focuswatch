#!/bin/bash
# FocusWatch — Developer ID build, notarize, and package script
# Usage: ./build_for_distribution.sh
#
# Prerequisites:
#   - Xcode with Developer ID Application certificate for team V5DR82A7NX
#   - An app-specific password stored in Keychain as "notarytool-focuswatch"
#     Create one at: appleid.apple.com -> App-Specific Passwords
#     Store it:  xcrun notarytool store-credentials "notarytool-focuswatch" \
#                  --apple-id "your@email.com" \
#                  --team-id V5DR82A7NX

set -e

SCHEME="FocusWatch"
PROJECT="FocusCop.xcodeproj"
BUNDLE_ID="com.abstractcase.focuswatch"
TEAM_ID="V5DR82A7NX"
ARCHIVE_PATH="./build/FocusWatch.xcarchive"
EXPORT_PATH="./dist"
APP_PATH="$EXPORT_PATH/FocusWatch.app"
ZIP_PATH="./dist/FocusWatch.zip"

echo "=== FocusWatch Distribution Build ==="
echo ""

# Sanity checks
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: xcodebuild not found. Install Xcode."
    exit 1
fi

# Clean
echo "Cleaning previous builds..."
rm -rf build/ dist/
mkdir -p build dist

# Archive
echo "Archiving..."
xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -archivePath "$ARCHIVE_PATH" \
    archive \
    CODE_SIGN_STYLE=Automatic \
    DEVELOPMENT_TEAM="$TEAM_ID"

# Export with Developer ID
echo "Exporting with Developer ID signing..."
xcodebuild \
    -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist exportOptions.plist

if [ ! -d "$APP_PATH" ]; then
    echo "Error: Export failed — $APP_PATH not found."
    exit 1
fi

# Notarize
echo "Notarizing (this takes a minute)..."
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

xcrun notarytool submit "$ZIP_PATH" \
    --keychain-profile "notarytool-focuswatch" \
    --wait

# Staple
echo "Stapling notarization ticket..."
xcrun stapler staple "$APP_PATH"

# Repackage for distribution
rm "$ZIP_PATH"
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

echo ""
echo "=== Done ==="
echo "Signed + notarized app: $APP_PATH"
echo "Distribution zip:       $ZIP_PATH"
echo ""
echo "Upload FocusWatch.zip to GitHub Releases, your website, or anywhere."
echo "Users unzip and drag FocusWatch.app to /Applications."
