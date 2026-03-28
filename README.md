# FocusWatch

A lightweight macOS menu bar app that monitors application focus changes and detects focus theft.

**By [Abstract Case](https://github.com/abstractcase)**

![macOS 13+](https://img.shields.io/badge/macOS-13.0+-000000?logo=apple&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

---

## What is FocusWatch?

FocusWatch sits quietly in your menu bar and logs every time you switch between applications. It's useful for:

- Tracking your app usage patterns over time
- Detecting focus theft — when apps steal your focus and return it within a second or two
- Exporting a full event log to CSV for further analysis

No accessibility permissions required. FocusWatch uses a standard macOS system notification to observe focus changes — nothing invasive.

## Download

**[Download the latest release](../../releases/latest)** — unzip and drag FocusWatch.app to your Applications folder.

On first launch, macOS may ask you to confirm opening an app from the internet. Right-click the app and choose Open if the normal double-click is blocked.

## Features

- Menu bar app — no Dock icon, no clutter
- Real-time focus event log with timestamps and bundle IDs
- Quick-switch detection: events under 2 seconds are flagged with `*`
- Top apps summary (most-focused apps by count)
- CSV export via a standard Save dialog
- Launch at Login toggle built in
- 100% local — no network activity, no telemetry

## How to Use

Click the binoculars icon in your menu bar:

| Item | What it does |
|---|---|
| Show Events & Stats | Opens the event log window |
| Test Focus Detection | Adds a manual test entry |
| Export Events to CSV | Saves all events to a .csv file |
| Launch at Login | Toggle auto-start on login |
| About FocusWatch | Version and copyright info |

Events are not saved to disk between sessions — export before quitting if you want to keep the data.

## Building from Source

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

FocusWatch does not make any network connections. All data stays on your Mac.

## License

MIT — see [LICENSE](LICENSE).

---

Made by [Abstract Case](https://github.com/abstractcase)
