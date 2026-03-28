#!/bin/bash

# FocusWatch Distribution Build Script

set -e

echo "🔍 Building FocusWatch for Distribution"
echo "===================================="

# Check if we have Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is required to build FocusWatch"
    echo "Please install Xcode from the Mac App Store"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/
rm -rf dist/

# Create build directory
mkdir -p build
mkdir -p dist

echo "🔨 Building FocusWatch..."

# Build for release
xcodebuild \
    -project FocusWatch.xcodeproj \
    -scheme FocusWatch \
    -configuration Release \
    -derivedDataPath ./build \
    -archivePath ./build/FocusWatch.xcarchive \
    archive

echo "📦 Exporting app bundle..."

# Export the app
xcodebuild \
    -exportArchive \
    -archivePath ./build/FocusWatch.xcarchive \
    -exportPath ./dist \
    -exportOptionsPlist exportOptions.plist

# Check if build succeeded
if [ -f "dist/FocusWatch.app/Contents/MacOS/FocusWatch" ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📍 App location: dist/FocusWatch.app"
    echo "📦 Ready for distribution"
    echo ""
    echo "To distribute:"
    echo "1. Zip the FocusWatch.app folder"
    echo "2. Upload to your website/GitHub releases"
    echo "3. Users download and drag to Applications"
    echo ""
    echo "⚠️  Note: For public distribution, consider:"
    echo "   - Apple Developer ID signing"
    echo "   - Notarization"
    echo "   - Or publish source code for users to build"
else
    echo "❌ Build failed!"
    exit 1
fi