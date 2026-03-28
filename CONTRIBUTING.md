# Contributing to FocusWatch

Thank you for your interest in contributing to FocusWatch! We're excited to work with the community to make this tool better.

## 🤝 How to Contribute

### Reporting Issues
- Check existing issues before creating new ones
- Provide detailed reproduction steps
- Include macOS version and FocusWatch version
- Attach crash logs if applicable

### Feature Requests
- Explain the use case and problem you're solving
- Consider performance impact (FocusWatch aims to stay lightweight)
- Check that the feature aligns with privacy-first principles

### Code Contributions

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Follow existing code style** (spaces, naming conventions)
4. **Test thoroughly** - FocusWatch must be crash-free
5. **Update documentation** if needed
6. **Commit with clear messages** (`git commit -m 'Add amazing feature'`)
7. **Push to your branch** (`git push origin feature/amazing-feature`)
8. **Open a Pull Request**

## 🎯 Development Principles

### Core Values
- **Simplicity** - Keep it minimal and focused
- **Performance** - Must be lightweight and efficient
- **Privacy** - No data collection, 100% local processing
- **Stability** - Zero crashes, rock-solid reliability

### Code Guidelines
- Use Swift 5.0+ features appropriately
- Prefer AppKit over complex SwiftUI for stability
- Avoid memory leaks and retain cycles
- Comment non-obvious logic
- Follow Apple's Human Interface Guidelines

## 🏗 Project Structure

```
FocusWatch/
├── FocusWatch/                  # Main app code
│   ├── FocusCoApp.swift      # App entry point
│   ├── SimpleFocusMonitor.swift    # Core monitoring logic
│   ├── SimpleMenuBarController.swift # UI controller
│   └── Assets.xcassets       # Icons and resources
├── README.md                 # Project documentation
├── LICENSE                   # MIT License
└── CONTRIBUTING.md           # This file
```

## 🧪 Testing

- Test on multiple macOS versions (13.0+)
- Verify memory usage stays under 10MB
- Ensure no crashes during extended use
- Test edge cases (rapid app switching, many apps)

## ❓ Questions?

- Open an issue for discussion
- Check existing documentation first
- Be respectful and constructive

## 🎖 Recognition

Contributors will be acknowledged in the README and release notes.

---

**Built by Hard Software** - Because the hardest software to build is the simplest.