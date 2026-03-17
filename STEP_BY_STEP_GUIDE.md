# FocusCop: Complete Setup Guide
## From Zero to Running App in ~30 Minutes

### Step 1: Install Xcode (15-20 minutes)

1. **Open Mac App Store**
   - Click the blue App Store icon in your Dock
   - Or press ⌘+Space and type "App Store"

2. **Search for Xcode**
   - Click the search icon (🔍) in the top-left
   - Type "Xcode" and press Enter

3. **Install Xcode**
   - Click the blue "Get" button (it's free)
   - Enter your Apple ID password if prompted
   - **Warning:** Xcode is ~15GB - this will take 10-20 minutes depending on your internet

4. **Wait for installation to complete**
   - You'll see a progress circle
   - When done, you'll see "Open" instead of the progress indicator

### Step 2: Launch Xcode (First Time Setup)

1. **Open Xcode**
   - Click "Open" in App Store, OR
   - Find Xcode in Applications folder and double-click

2. **Accept License Agreement**
   - Xcode will ask you to agree to the license
   - Click "Agree"

3. **Install Additional Components**
   - Xcode may need to install extra tools
   - Click "Install" when prompted
   - This takes 2-3 more minutes

4. **Skip Sign-In (Optional)**
   - Xcode may ask you to sign in with Apple ID
   - You can click "Skip" for now - we don't need it

### Step 3: Open FocusCop Project (30 seconds)

1. **Navigate to FocusCop folder**
   - Open Finder
   - Go to: `/Users/runaelee/FocusCop`

2. **Double-click the project file**
   - Find `FocusCop.xcodeproj`
   - Double-click it
   - Xcode will open with the project loaded

### Step 4: Build and Run (1 minute)

1. **Check the scheme**
   - Look at the top of Xcode window
   - You should see "FocusCop" selected as the scheme
   - If not, click the dropdown and select "FocusCop"

2. **Build and Run**
   - Press ⌘R (Command + R), OR
   - Click the ▶️ play button in the top-left

3. **Wait for build**
   - You'll see "Building..." in the top bar
   - First build takes ~30 seconds

4. **Look for the menu bar icon**
   - When build completes, look at your menu bar (top of screen)
   - You should see a small eye icon (👁️)
   - If you don't see it, look for it among other menu bar icons

### Step 5: Test FocusCop (2 minutes)

1. **Click the eye icon**
   - Click the 👁️ icon in your menu bar
   - A popover window should appear

2. **Grant Permissions (Important!)**
   - FocusCop will ask for Accessibility permissions
   - Click "Open System Preferences"
   - In System Preferences:
     - Find "FocusCop" in the list
     - Check the checkbox next to it
     - You may need to unlock with your password first

3. **Test the app**
   - Go back to FocusCop (click the eye icon again)
   - Click the "Test" tab (test tube icon 🧪)
   - Click "Single Focus Steal Test"
   - You should see a test window flash briefly

4. **Check the results**
   - Click the "Log" tab
   - You should see entries with red highlights (🔴)
   - Click the "Suspects" tab
   - You should see the test app listed with a count

### Troubleshooting

**If Xcode won't open the project:**
- Make sure you double-clicked `FocusCop.xcodeproj` (not the folder)
- Try right-click → "Open With" → "Xcode"

**If build fails:**
- Check that you have macOS 13+ (click Apple menu → "About This Mac")
- Try Product → Clean Build Folder in Xcode, then ⌘R again

**If you don't see the menu bar icon:**
- Check if it's hidden behind other menu bar items
- Try building again (⌘R)
- Make sure the build succeeded (green checkmark in Xcode)

**If permissions don't work:**
- Go to System Preferences → Security & Privacy → Privacy → Accessibility
- Make sure FocusCop is checked
- Try restarting the app after granting permissions

### Success! 🎉

You now have:
- ✅ FocusCop running in your menu bar
- ✅ Real-time focus monitoring
- ✅ Built-in testing capability
- ✅ Focus theft detection working

**What's Next:**
- Switch between apps normally - see them in the Log
- Use the Test tab to trigger focus stealing
- Check the Suspects tab to see which apps steal focus
- The app runs automatically and monitors everything!

### To Stop FocusCop:
- Click the eye icon → right-click → "Quit"
- Or force-quit from Activity Monitor if needed