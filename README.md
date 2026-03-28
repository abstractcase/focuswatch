# FocusWatch

FocusWatch is a macOS menu bar tool for investigating which apps are stealing your application focus.

So, you're doing work on your computer, and then some other app grabs focus - a notification here, an auto-launch there. FocusWatch logs every focus change in real time, flags suspiciously quick switches, and lets you export the full history so you can see exactly what's happening on your machine.

Everything runs locally. No network connections, no telemetry, no accounts. Your data stays on your Mac.

**By [Abstract Case](https://github.com/abstractcase)**

![macOS 13+](https://img.shields.io/badge/macOS-13.0+-000000?logo=apple&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Download

**[Download FocusWatch 1.0.0](../../releases/latest)**

Unzip and drag FocusWatch.app to your Applications folder. On first launch, right-click the app and choose Open if macOS asks you to confirm.

## What it does

FocusWatch sits in your menu bar and silently logs every time you switch between apps — the app name, bundle ID, timestamp, and whether the switch happened suspiciously fast (under 2 seconds, marked with `*`).

When something feels off — an app keeps interrupting you, your workflow gets broken for no reason — you open the event log and look at the timestamps. The pattern usually becomes obvious pretty quickly.

You can export the full log to CSV at any time for deeper analysis in Excel or Numbers.

No accessibility permissions required. FocusWatch uses a standard macOS system notification that any app can subscribe to.

## Menu

| Item | What it does |
|---|---|
| Show Events & Stats | Opens the event log with stats summary |
| Test Focus Detection | Adds a manual test entry to confirm it's working |
| Export Events to CSV | Save the full log to a file |
| Launch at Login | Toggle auto-start |
| About FocusWatch | Version info |

Events are kept in memory only — export before quitting if you want to keep them.

## Building from source

Requires Xcode 15+ and macOS 13+.

```bash
git clone https://github.com/abstractcase/focuswatch
cd focuswatch
open FocusCop.xcodeproj
```

Press `⌘R` to build and run.

## Requirements

- macOS 13.0 or later
- No special permissions required

## Privacy

FocusWatch makes no network connections. All data stays on your Mac.

## License

MIT — see [LICENSE](LICENSE).

---

Made by [Abstract Case](https://github.com/abstractcase)
