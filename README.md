# 🔍 FocusWatch

*A lightweight macOS menu bar app that monitors application focus changes and detects focus theft.*

**By Hard Software** - Because sometimes software needs to be built the hard way.

![FocusWatch Menu Bar](https://img.shields.io/badge/macOS-13.0+-blue?logo=apple&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

## 🎯 What is FocusWatch?

FocusWatch sits quietly in your menu bar (🔍) and monitors every time you switch between applications. It helps you:

- **Track your app usage patterns** with detailed logs
- **Detect focus theft** - when apps steal focus and return it quickly
- **Analyze your workflow** with statistics and insights
- **Export your data** to CSV for further analysis

Perfect for developers, productivity enthusiasts, and anyone curious about their digital habits.

## ✨ Features

- **🔍 Smart Focus Detection** - Highlights suspicious quick app switches
- **📊 Live Statistics** - See your most-used apps and total switches
- **📤 CSV Export** - Full data export for Excel/Numbers analysis
- **🪶 Ultra-Lightweight** - <10MB RAM, zero CPU when idle
- **🔒 Privacy First** - 100% local, no network activity
- **🎨 Native macOS Design** - Clean menu bar integration

## 🚀 Installation

### Option 1: Download Release
1. Download the latest release from [GitHub Releases]
2. Drag `FocusWatch.app` to your Applications folder
3. Right-click and select "Open" (first time only)
4. Look for the binoculars icon (🔍) in your menu bar

### Option 2: Build from Source
```bash
git clone https://github.com/yourusername/focuswatch
cd focuswatch
open FocusWatch.xcodeproj
# Build and run in Xcode (⌘R)
```

## 🎮 How to Use

1. **Click the binoculars icon** in your menu bar
2. **"📊 Show Events & Stats"** - View your focus activity
3. **"🧪 Test Focus Detection"** - Try the built-in test
4. **"📤 Export Events to CSV"** - Download your data

### Understanding the Display

```
[2:30:15 PM] Safari 🔍
   └─ com.apple.Safari
```

- **🔍 = Quick Switch** - App switch under 2 seconds (potential focus theft)
- **Bundle ID** - Technical app identifier
- **Statistics** - Shows total events and most active apps

## 📊 What Gets Tracked

- **Timestamp** of each app switch
- **Application name** (user-friendly)
- **Bundle identifier** (technical ID)
- **Quick switch detection** (focus theft indicator)

## 🔒 Privacy & Security

- **100% local processing** - no data leaves your Mac
- **No network connections** - completely offline
- **Minimal permissions** - only basic app notifications
- **Open source** - inspect the code yourself

## 🛠 Requirements

- macOS 13.0 or later
- ~10MB disk space
- No special permissions required (basic mode)

## 📈 Performance

FocusWatch is designed to be invisible:

- **Memory:** ~5-10MB (less than a browser tab)
- **CPU:** <0.1% (only active during app switches)
- **Battery:** No measurable impact
- **Network:** Zero usage

## 🤝 Contributing

This is an open source project! Contributions welcome:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📝 License

MIT License - feel free to use, modify, and distribute.

## 🏢 About Hard Software

We build software the hard way - with attention to performance, privacy, and user experience. No shortcuts, no bloat, just solid tools that work.

---

**Made with 💻 by Hard Software**
*Sometimes the hardest software to build is the simplest.*