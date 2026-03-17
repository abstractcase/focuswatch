#!/bin/bash

# FocusCop Distribution Build Script

set -e

echo "🔍 Building FocusCop for Distribution"
echo "===================================="

# Check if we have Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is required to build FocusCop"
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

echo "🔨 Building FocusCop..."

# Build for release
xcodebuild \
    -project FocusCop.xcodeproj \
    -scheme FocusCop \
    -configuration Release \
    -derivedDataPath ./build \
    -archivePath ./build/FocusCop.xcarchive \
    archive

echo "📦 Exporting app bundle..."

# Export the app
xcodebuild \
    -exportArchive \
    -archivePath ./build/FocusCop.xcarchive \
    -exportPath ./dist \
    -exportOptionsPlist exportOptions.plist

# Check if build succeeded
if [ -f "dist/FocusCop.app/Contents/MacOS/FocusCop" ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📍 App location: dist/FocusCop.app"
    echo "📦 Ready for distribution"
    echo ""
    echo "To distribute:"
    echo "1. Zip the FocusCop.app folder"
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