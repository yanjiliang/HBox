# HBox - HarmonyOS Next

> A video streaming application for HarmonyOS Next, converted from the original Android TV project.

## 📱 What is This?

This is a **HarmonyOS Next** port of HBox, originally an Android TV streaming application. The entire project has been rewritten in **ArkTS** (HarmonyOS's TypeScript-based framework) to run natively on HarmonyOS Next devices.

## 🎯 Features

- 📺 Browse movies, TV shows, variety shows, anime, and documentaries
- ▶️ Video playback with full controls
- 🔴 Live TV channel streaming
- 🔍 Search functionality with history
- 📜 Watch history tracking
- ⭐ Favorites/collection management
- ⚙️ Configurable settings and data sources
- 📱 Optimized for TV/tablet devices

## 🚀 Quick Start

### Prerequisites

- **DevEco Studio 5.0+**
- **HarmonyOS SDK API 12+**
- A HarmonyOS Next device or emulator

### Build & Run

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd HBox
   git checkout harmonyos-next
   ```

2. **Open in DevEco Studio**
   - Launch DevEco Studio
   - File → Open → Select the `harmonyos` folder
   - Wait for project sync to complete

3. **Configure signing**
   - File → Project Structure → Signing Configs
   - Add your signing profile

4. **Run the app**
   - Connect a HarmonyOS Next device or start an emulator
   - Click the Run button (or press Ctrl+R)

## 📂 Project Structure

```
harmonyos/
├── entry/                          # Main entry module
│   └── src/main/
│       ├── ets/                    # ArkTS source code
│       │   ├── pages/              # UI pages (9 pages)
│       │   ├── model/              # Data models
│       │   ├── net/                # Network layer
│       │   ├── database/           # Database layer
│       │   └── common/             # Common utilities
│       └── resources/              # App resources
├── README.md                       # Main documentation
├── CONVERSION_GUIDE.md             # Technical conversion reference
└── HARMONYOS_MIGRATION_SUMMARY.md  # Migration details
```

## 📖 Documentation

- **[README.md](harmonyos/README.md)** - Complete project documentation
- **[CONVERSION_GUIDE.md](harmonyos/CONVERSION_GUIDE.md)** - Android to HarmonyOS conversion reference
- **[MIGRATION_SUMMARY.md](harmonyos/HARMONYOS_MIGRATION_SUMMARY.md)** - Detailed migration summary

## 🔄 Conversion Status

### ✅ Completed
- [x] All 9 main pages converted to ArkTS
- [x] Database layer (RelationalStore)
- [x] Network layer (HTTP client)
- [x] User preferences storage
- [x] Video player integration (AVPlayer)
- [x] Navigation system (Router)
- [x] Complete UI layouts

### ⏳ In Progress / To Do
- [ ] API configuration parsing (XML/JSON)
- [ ] Video parser integration
- [ ] Spider/JAR plugin system
- [ ] Image loading and caching
- [ ] Advanced video features (subtitles, speed control)
- [ ] Remote control server

## 🛠️ Technology Stack

| Component | Technology |
|-----------|-----------|
| **Framework** | HarmonyOS Next (ArkUI) |
| **Language** | ArkTS (TypeScript-based) |
| **Database** | RelationalStore (RDB) |
| **Network** | HTTP Module |
| **Video Player** | AVPlayer (XComponent) |
| **State Management** | @State decorator |

## 📝 Configuration

The app requires an API data source URL to be configured in Settings. The API should return video source information compatible with the original format.

## 🤝 Contributing

Contributions are welcome! This is a community-driven port.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project maintains the same license as the original HBox project.

See [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original HBox Android project and contributors
- HarmonyOS development community
- All contributors to this HarmonyOS port

## 🔗 Links

- **Original Android Project**: [HBox on GitHub](https://github.com/Tangsan99999/HBox)
- **HarmonyOS Docs**: [developer.harmonyos.com](https://developer.harmonyos.com/)
- **DevEco Studio**: [Download](https://developer.harmonyos.com/deveco-studio)

## ⚠️ Important Note

This is an **early version** of the HarmonyOS Next port. Core infrastructure is in place, but some features require additional implementation. Please refer to the documentation for details on what's implemented and what's pending.

---

**Platform**: HarmonyOS Next API 12+
**Version**: 1.0.0
**Branch**: `harmonyos-next`
