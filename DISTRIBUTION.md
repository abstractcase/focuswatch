# FocusWatch Distribution Guide

## Distribution Options

### 1. **Open Source (Recommended)**
**Best for:** Developer tools, community projects
- Upload to GitHub with source code
- Users build themselves with Xcode
- No signing certificates needed
- Easiest to maintain and update

**Setup:**
```bash
# Create GitHub repository
git init
git add .
git commit -m "Initial FocusWatch release"
git remote add origin https://github.com/yourusername/focuscop
git push -u origin main
```

### 2. **Developer ID Distribution**
**Best for:** Public apps outside App Store
- **Cost:** $99/year Apple Developer Program
- **Benefits:** Users can run immediately, no warnings
- **Requirements:** Code signing + notarization

**Steps:**
1. Join [Apple Developer Program](https://developer.apple.com/programs/)
2. Get Developer ID certificates
3. Sign app with `codesign`
4. Notarize with `xcrun notarytool`
5. Distribute .app bundle

### 3. **Mac App Store**
**Best for:** Maximum reach, automatic updates
- **Cost:** $99/year Apple Developer Program + 30% App Store fee
- **Benefits:** Trusted distribution, auto-updates
- **Requirements:** Strict review, sandboxing

**Additional Requirements for App Store:**
- Remove test functionality (or make it hidden)
- Add App Store screenshots
- Write app description
- Handle sandbox restrictions

### 4. **Unsigned Distribution**
**Best for:** Internal/testing use only
- **Cost:** Free
- **Downsides:** Scary security warnings for users
- Users must right-click → "Open" to bypass Gatekeeper

## Quick Start: Open Source Distribution

**For immediate distribution:**

1. **Build locally:**
   ```bash
   chmod +x build_for_distribution.sh
   ./build_for_distribution.sh
   ```

2. **Create GitHub repository:**
   - Upload source code
   - Add installation instructions
   - Include built .app in releases

3. **User instructions:**
   ```markdown
   ## Installation
   1. Download FocusWatch.app from releases
   2. Drag to Applications folder
   3. Right-click → Open (first time only)
   4. Look for eye icon in menu bar
   ```

## Professional Distribution Setup

If you want to distribute properly signed apps:

### Get Apple Developer Account
1. Visit [developer.apple.com](https://developer.apple.com)
2. Enroll in Developer Program ($99/year)
3. Download certificates

### Code Signing Commands
```bash
# Sign the app
codesign --deep --force --verify --verbose --sign "Developer ID Application: Your Name" dist/FocusWatch.app

# Create distributable ZIP
cd dist
zip -r FocusWatch-v1.0.0.zip FocusWatch.app

# Notarize (requires Apple Developer account)
xcrun notarytool submit FocusWatch-v1.0.0.zip --keychain-profile "AC_PASSWORD" --wait
```

### GitHub Release Template
```markdown
# FocusWatch v1.0.0

## Download
- [FocusWatch.app.zip](link) - Ready to run (macOS 13+)
- [Source Code](link) - Build yourself with Xcode

## Installation
1. Download and unzip FocusWatch.app
2. Drag to Applications folder
3. Double-click to launch
4. Grant Accessibility permissions when prompted

## What's New
- Real-time focus theft detection
- Built-in testing mode
- Menu bar interface with suspects tracking

## System Requirements
- macOS 13.0 or later
- Accessibility permissions for full functionality
```

## Recommendation

**Start with open source distribution:**
1. Upload to GitHub
2. Provide clear build instructions
3. Include pre-built app for convenience
4. Consider Apple Developer ID later if the project grows

This gives you immediate distribution while keeping options open for professional signing later.