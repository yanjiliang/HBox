# HBox HarmonyOS Next - Setup Guide

This guide will help you get the HBox HarmonyOS Next project running in DevEco Studio.

## Prerequisites

Before you begin, ensure you have:

1. **DevEco Studio 5.0 or later** installed
   - Download from: https://developer.harmonyos.com/deveco-studio

2. **HarmonyOS SDK API 12 or later**
   - Install via DevEco Studio SDK Manager

3. **Node.js 14.19.1 or later**
   - Required for Hvigor build system

4. **A HarmonyOS Next device or emulator**
   - For testing the application

## Setup Steps

### 1. Open the Project

1. Launch DevEco Studio
2. Click **File → Open**
3. Navigate to and select the `harmonyos` folder
4. Click **OK** and wait for project sync

### 2. Configure SDK Paths

1. Go to **File → Project Structure → SDK Location**
2. Verify the SDK paths are correct:
   - **HarmonyOS SDK location**: Should point to your SDK installation
   - **Node.js location**: Should point to your Node.js installation

3. If paths are incorrect, update the `local.properties` file:
   ```properties
   sdk.dir=/path/to/your/harmonyos/sdk
   nodejs.dir=/path/to/your/nodejs
   ```

### 3. Sync Project

1. Click the **Sync Project with Hvigor Files** button (🔄 icon in toolbar)
2. Wait for Hvigor to download dependencies
3. Check for any sync errors in the **Build** tab

### 4. Configure Signing

HarmonyOS apps require signing before installation.

#### Option A: Automatic Signing (Recommended for Testing)
1. Go to **File → Project Structure → Signing Configs**
2. Select **Automatically generate signature**
3. Click **OK**

#### Option B: Manual Signing
1. Generate a signing certificate if you don't have one
2. Go to **File → Project Structure → Signing Configs**
3. Select **Manually configure signature**
4. Provide your certificate paths
5. Click **OK**

### 5. Build the Project

1. Click **Build → Make Module 'entry'**
2. Wait for the build to complete
3. Check the **Build Output** tab for any errors

### 6. Run the Application

#### On a Physical Device:
1. Connect your HarmonyOS Next device via USB
2. Enable **Developer Mode** on the device
3. Enable **USB Debugging** in device settings
4. Click the **Run** button (▶️) in DevEco Studio
5. Select your device from the list
6. Click **OK**

#### On an Emulator:
1. Click **Tools → Device Manager**
2. Create a new HarmonyOS Next emulator (API 12+)
3. Start the emulator
4. Click the **Run** button (▶️)
5. Select the emulator from the list
6. Click **OK**

## Troubleshooting

### Build Errors

#### "Cannot resolve symbol '@ohos.xxx'"
**Solution**: The SDK is not properly configured.
- Check SDK installation in **File → Settings → SDK**
- Re-sync the project

#### "Hvigor build failed"
**Solution**:
1. Delete `harmonyos/.hvigor` folder
2. Delete `harmonyos/oh_modules` folder
3. Re-sync the project: **File → Sync Project with Hvigor Files**

#### "Module 'entry' not found"
**Solution**:
- Ensure you opened the `harmonyos` folder, not the root folder
- Check that `build-profile.json5` exists in the harmonyos folder

### Runtime Errors

#### "Application installation failed"
**Solution**: Check signing configuration
- Go to **File → Project Structure → Signing Configs**
- Ensure signing is properly configured
- Try regenerating the signature

#### "Ability not found"
**Solution**: Check module.json5
- Verify `entry/src/main/module.json5` contains EntryAbility
- Ensure the mainElement is set to "EntryAbility"

#### Blank screen on launch
**Solution**: Check page loading
- Open DevEco Studio **HiLog** tab
- Look for errors related to HomePage
- Verify `pages/HomePage` is listed in `main_pages.json`

### Empty Pages / No Content

This is **expected** in the current version! The pages are UI shells that need backend integration:

**What's working:**
- ✅ Navigation between pages
- ✅ UI layouts and controls
- ✅ Database operations (history, favorites)
- ✅ Settings storage

**What needs implementation:**
- ❌ API data loading
- ❌ Video playback (needs XComponent native integration)
- ❌ Search results
- ❌ Live TV channels

See [README.md](./README.md) for implementation status.

## Project Structure Verification

After opening, you should see this structure in DevEco Studio:

```
harmonyos
├── AppScope
│   └── app.json5
├── entry
│   ├── src/main
│   │   ├── ets
│   │   │   ├── entryability
│   │   │   │   └── EntryAbility.ets
│   │   │   ├── pages (9 files)
│   │   │   ├── model (3 files)
│   │   │   ├── database (DatabaseManager.ets)
│   │   │   ├── net (HttpClient.ets)
│   │   │   └── common (PreferenceManager.ets)
│   │   ├── resources
│   │   │   └── base
│   │   │       ├── element
│   │   │       └── profile
│   │   └── module.json5
│   ├── build-profile.json5
│   └── hvigorfile.ts
├── hvigor
│   └── hvigor-config.json5
├── build-profile.json5
├── hvigorfile.ts
└── oh-package.json5
```

## Common Tasks

### Viewing Logs
1. Run the app
2. Open **View → Tool Windows → HiLog**
3. Filter by "HBox" or specific tags

### Debugging
1. Set breakpoints in .ets files
2. Click **Run → Debug 'entry'** (🐛 icon)
3. App will pause at breakpoints

### Clean Build
1. Click **Build → Clean Project**
2. Wait for clean to complete
3. Click **Build → Rebuild Project**

## Next Steps

After successfully running the app:

1. **Configure API Source**
   - Navigate to Settings page
   - Enter your video API URL
   - (Note: API parsing is not yet implemented)

2. **Test Navigation**
   - Try navigating between all 9 pages
   - Verify back navigation works

3. **Test Database Features**
   - History and Favorites use real database
   - Try adding/removing items

4. **Review Code**
   - Check [CONVERSION_GUIDE.md](./CONVERSION_GUIDE.md) for architecture details
   - See [README.md](./README.md) for feature status

## Known Limitations

1. **No Image Assets**: Icons are replaced with Unicode characters
2. **No Video Playback**: AVPlayer integration needs native implementation
3. **No API Integration**: Data fetching not implemented
4. **No Network Handling**: HTTP client exists but not connected
5. **Placeholder Data**: Pages show empty or placeholder content

These are documented in [README.md](./README.md) under the "To Be Implemented" section.

## Support

If you encounter issues not covered here:

1. Check DevEco Studio logs: **View → Tool Windows → Event Log**
2. Review build output: **View → Tool Windows → Build**
3. Consult [HarmonyOS Developer Docs](https://developer.harmonyos.com/)
4. Check [CONVERSION_GUIDE.md](./CONVERSION_GUIDE.md) for technical details

## Development Tips

1. **Hot Reload**: Changes to .ets files are auto-reloaded in debug mode
2. **Previewer**: Right-click on a page → **Preview** to see UI without running
3. **Code Completion**: Use Ctrl+Space for ArkTS suggestions
4. **Quick Fix**: Alt+Enter for quick fixes and imports

---

**Last Updated**: 2026-01-09
**Version**: 1.0.0
**DevEco Studio**: 5.0+
**HarmonyOS API**: 12+
