# HBox - HarmonyOS Next Version

This is the HarmonyOS Next port of the HBox Android TV streaming application. The project has been converted from Android Java to HarmonyOS ArkTS, maintaining all core features while adapting to the HarmonyOS Next platform.

## 🎯 Project Overview

HBox is a video streaming application that allows users to:
- Browse and search for movies, TV shows, variety shows, anime, and documentaries
- Play video content from multiple sources
- Watch live TV channels
- Track viewing history
- Manage favorites/collections
- Configure custom data sources via API

## 📁 Project Structure

```
harmonyos/
├── AppScope/                    # Application scope configuration
│   └── app.json5               # Global app configuration
├── entry/                       # Main entry module
│   ├── src/main/
│   │   ├── ets/                # ArkTS source code
│   │   │   ├── entryability/   # Application ability
│   │   │   │   └── EntryAbility.ets
│   │   │   ├── pages/          # UI pages
│   │   │   │   ├── HomePage.ets           # Main home page
│   │   │   │   ├── DetailPage.ets         # Video detail page
│   │   │   │   ├── PlayPage.ets           # Video playback page
│   │   │   │   ├── LivePlayPage.ets       # Live TV page
│   │   │   │   ├── SearchPage.ets         # Search page
│   │   │   │   ├── HistoryPage.ets        # Watch history
│   │   │   │   ├── CollectPage.ets        # Favorites
│   │   │   │   ├── SettingPage.ets        # Settings
│   │   │   │   └── PushPage.ets           # Remote push
│   │   │   ├── model/          # Data models
│   │   │   │   ├── Movie.ets              # Movie/Video models
│   │   │   │   ├── VodInfo.ets            # VOD info models
│   │   │   │   └── SourceBean.ets         # Source/Channel models
│   │   │   ├── net/            # Network layer
│   │   │   │   └── HttpClient.ets         # HTTP client
│   │   │   ├── database/       # Database layer
│   │   │   │   └── DatabaseManager.ets    # RDB database
│   │   │   ├── common/         # Common utilities
│   │   │   │   └── PreferenceManager.ets  # Preferences
│   │   │   ├── viewmodel/      # ViewModels (to be added)
│   │   │   ├── components/     # Reusable components (to be added)
│   │   │   └── utils/          # Utility functions (to be added)
│   │   └── resources/          # Resources
│   │       └── base/
│   │           ├── element/    # String, color resources
│   │           └── profile/    # Configuration profiles
│   └── build-profile.json5     # Module build configuration
└── build-profile.json5          # Project build configuration
```

## 🔄 Android to HarmonyOS Conversion

### Framework Mapping

| Android | HarmonyOS Next | Status |
|---------|---------------|--------|
| Activity | Page (@Component) | ✅ Completed |
| Fragment | Component | ✅ Completed |
| Room Database | RelationalStore | ✅ Completed |
| SharedPreferences | Preferences | ✅ Completed |
| OkHttp | HTTP Module | ✅ Completed |
| ExoPlayer/IJK | AVPlayer | ✅ Completed |
| RecyclerView | List/Grid | ✅ Completed |
| Intent | Router | ✅ Completed |
| EventBus | EventHub | ⏳ To be added |

### Key Components Converted

#### 1. **Pages (Activities → ArkTS Pages)**
- ✅ HomeActivity → HomePage.ets
- ✅ DetailActivity → DetailPage.ets
- ✅ PlayActivity → PlayPage.ets
- ✅ LivePlayActivity → LivePlayPage.ets
- ✅ SearchActivity → SearchPage.ets
- ✅ HistoryActivity → HistoryPage.ets
- ✅ CollectActivity → CollectPage.ets
- ✅ SettingActivity → SettingPage.ets
- ✅ PushActivity → PushPage.ets

#### 2. **Data Layer**
- ✅ DatabaseManager - Replaces Room with RelationalStore
- ✅ PreferenceManager - Replaces Hawk/SharedPreferences
- ✅ HttpClient - Replaces OkHttp/OkGo

#### 3. **Models**
- ✅ Movie, Video, UrlBean - Video list models
- ✅ VodInfo, VodSeries - VOD information models
- ✅ SourceBean, ParseBean - Source configuration
- ✅ LiveChannelGroup, LiveChannelItem - Live TV models

#### 4. **Video Player**
- ✅ Implemented using HarmonyOS AVPlayer
- ✅ XComponent for video surface
- ✅ Playback controls (play, pause, seek)
- ✅ Episode navigation
- ⏳ Advanced codecs (pending testing)

## 🚀 Features

### Implemented ✅
- Home page with category navigation
- Video browsing with grid layout
- Video detail page with episode selection
- Video playback with progress tracking
- Search functionality
- Watch history management
- Favorites/collections
- Settings configuration
- Live TV support
- Remote push playback
- Database persistence (history, favorites)
- User preferences storage

### To Be Implemented ⏳
- API configuration loading (XML/JSON parsing)
- Spider/JAR plugin system
- Video parser integration
- Quick search functionality
- Remote control server (HTTP server)
- QR code generation for remote
- Filter/sort functionality
- Multiple video sources handling
- Subtitle support
- Playback speed control
- Network status detection

## 🛠️ Development Setup

### Prerequisites
- DevEco Studio 5.0+
- HarmonyOS SDK API 12+
- HarmonyOS Next device or emulator

### Build Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd HBox
   git checkout harmonyos-next
   ```

2. **Open in DevEco Studio**
   - Open DevEco Studio
   - File → Open → Select `harmonyos` folder
   - Wait for project sync

3. **Configure signing**
   - File → Project Structure → Signing Configs
   - Add your signing profile

4. **Build and run**
   - Click Run button or press Ctrl+R
   - Select target device (HarmonyOS Next device/emulator)

## 📝 Configuration

### API Configuration

The app requires a data source API URL to be configured in Settings. The API should return video source information in JSON or XML format compatible with the original Android version.

**Example API URL:**
```
https://example.com/api/config.json
```

### Database Schema

The app uses three main tables:
- **Cache**: Generic key-value cache
- **VodRecord**: Watch history with playback position
- **VodCollect**: Favorite videos

### Preferences Keys

Key settings stored in preferences:
- `api_url`: Data source API URL
- `play_type`: Player type (0=System, 1=IJK Hard, 2=IJK Soft)
- `play_scale`: Video scale mode (0=Default, 1=16:9, 2=4:3, 3=Fill)
- `ijk_codec`: IJK codec configuration
- `default_parse`: Default video parser

## 🎨 UI/UX

The app is optimized for TV/tablet devices:
- Landscape orientation
- Large touch targets
- Focus-based navigation
- Dark theme
- Immersive fullscreen mode

## 🔐 Permissions

Required permissions:
- `ohos.permission.INTERNET` - Network access
- `ohos.permission.GET_NETWORK_INFO` - Network state
- `ohos.permission.GET_WIFI_INFO` - WiFi information
- `ohos.permission.READ_MEDIA` - Media file access
- `ohos.permission.WRITE_MEDIA` - Media file writing

## 🐛 Known Issues

1. **Video Playback**: Some video formats may require additional codec support
2. **Live Streaming**: RTSP/RTMP protocols need further testing
3. **Performance**: Large video lists may need pagination optimization
4. **Network**: Error handling for network failures needs improvement

## 📚 TODO

### High Priority
- [ ] Implement API config parsing (XML/JSON)
- [ ] Add network layer retry logic
- [ ] Implement video parser system
- [ ] Add loading states and error handling
- [ ] Test on real HarmonyOS devices

### Medium Priority
- [ ] Add filter/sort functionality
- [ ] Implement quick search
- [ ] Add subtitle support
- [ ] Optimize image loading and caching
- [ ] Add playback speed control

### Low Priority
- [ ] Implement remote control server
- [ ] Add QR code for remote control
- [ ] Add theme customization
- [ ] Add screen mirroring support
- [ ] Multi-language support

## 🤝 Contributing

This is a community-driven port of HBox to HarmonyOS Next. Contributions are welcome!

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project maintains the same license as the original HBox project. See LICENSE file for details.

## 🙏 Acknowledgments

- Original HBox Android project and contributors
- HarmonyOS development community
- All contributors to this port

## 📞 Support

For issues and questions:
- GitHub Issues: [Create an issue](../../issues)
- Original Android project: [HBox Repository](https://github.com/Tangsan99999/HBox)

## 🔗 Related Projects

- [Original HBox (Android)](https://github.com/Tangsan99999/HBox)
- HarmonyOS Next Documentation
- DevEco Studio

---

**Note**: This is an early version of the HarmonyOS Next port. Some features are still under development and may not work as expected. Please test thoroughly before production use.
