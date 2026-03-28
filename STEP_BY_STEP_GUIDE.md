# FocusWatch: Setup Guide
## From Zero to Running App in ~30 Minutes

---

### Step 1: Install Xcode (15–20 minutes)

1. **Open the Mac App Store**
   - Click the App Store icon in your Dock, or press ⌘+Space and type "App Store"

2. **Search for Xcode**
   - Click the search icon in the top-left, type "Xcode", press Enter

3. **Install Xcode**
   - Click "Get" (it's free). Xcode is ~15 GB — expect 10–20 minutes depending on your connection.

4. **First-launch setup**
   - Open Xcode and accept the license agreement
   - Let it install additional components if prompted (~2–3 minutes)

---

### Step 2: Open the FocusWatch Project (30 seconds)

1. Open Finder and navigate to the FocusWatch folder
2. Double-click **FocusCop.xcodeproj** — Xcode will open with the project loaded
3. At the top of the Xcode window, confirm the scheme shows **FocusWatch** and the destination is **My Mac**

---

### Step 3: Build and Run (1 minute)

1. Press **⌘R** (or click the ▶ button in the top-left)
2. The first build takes ~30 seconds. Watch for "Build Succeeded" in the status bar.
3. When it completes, look at your **menu bar** (top-right of screen) — you should see a small **binoculars icon** (🔭)

> FocusWatch requires **no special permissions**. It uses a public macOS notification to detect which app is in focus — no Accessibility access needed.

---

### Step 4: Using the App

Click the binoculars icon in the menu bar. You'll see:

| Menu Item | What it does |
|---|---|
| ✅ Monitoring Active • N events | Live event count — updates every 5 seconds |
| 📊 Show Events & Stats | Opens the events window with full history |
| 🧪 Test Focus Detection | Adds a manual test entry + shows a tip |
| 📤 Export Events to CSV | Save all events as a spreadsheet |
| Launch at Login | Toggle — starts FocusWatch automatically on login |
| Quit FocusWatch | Stops the app |

---

### Step 5: Reading the Events Window

Open **Show Events & Stats** to see the full log.

- The header shows **total event count** and your **top 3 apps** by focus time
- Each line in the log is one focus change: `[time]  App Name (bundle.id)`
- A **🔍** flag marks a *quick switch* — the previous app was active for under 2 seconds, which can indicate an app stealing focus
- Events are **not saved to disk**. Use **Export Events to CSV** before quitting if you want to keep the data.

---

### Troubleshooting

**Can't see the binoculars icon?**
- Menu bar icons can be hidden when space is tight. Try making your menu bar less crowded, or look for it in the overflow area (click `>>` if present on the right side of the menu bar).

**Build fails?**
- Confirm you're on macOS 13 or later: Apple menu → About This Mac
- Try Product → Clean Build Folder (⇧⌘K), then ⌘R

**Events window shows nothing after switching apps?**
- Wait a second or two — the display refreshes every 1 second
- Try ⌘+Tab to switch between a couple of apps and then reopen the events window

---

### Stopping FocusWatch

Click the binoculars icon → **Quit FocusWatch**.

If **Launch at Login** is enabled and you want to disable it permanently, open the app, click the menu, and uncheck **Launch at Login** before quitting.
