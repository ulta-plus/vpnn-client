# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

VPNNaruzhu is a cross-platform VPN client forked from Amnezia VPN, supporting multiple VPN protocols (OpenVPN, WireGuard, AmneziaWG, Shadowsocks, Cloak, XRay, IKEv2). Built with Qt 6.6+ and C++17, targeting Windows, macOS, Linux, iOS, and Android.

## Build Commands

### Prerequisites
- CMake >= 3.25.0
- Qt 6.6.2+ with modules: Core, Gui, Network, RemoteObjects, Quick, Svg, QuickControls2, Core5Compat, Concurrent, Widgets (desktop only)
- Go >= v1.16 (for WireGuard components)
- git submodules: `git submodule update --init --recursive`

### Windows Build
Required environment:
- Qt 6.6.3 (msvc2019_64)
- Qt Installer Framework 4.8
- CMake >= 3.25

```bash
set QT_BIN_DIR="<PATH_TO_QT>\Qt\<QT_VERSION>\msvc2019_64\bin"
set QIF_BIN_DIR="<PATH_TO_QT>\Qt\Tools\QtInstallerFramework\4.8\bin"
set BUILD_ARCH=64
set VPNN_VERSION=2.2.0.5
.\deploy\build_windows.bat
```

Output: `VPNNaruzhu_x64_<VERSION>.exe` installer

### macOS Build
```bash
export QT_BIN_DIR="<PATH>/Qt/<QT_VERSION>/macos/bin"
export VPNN_VERSION="2.2.0.5"
./deploy/build_macos.sh
```

For macOS Network Extension variant:
```bash
export QT_MACOS_ROOT_DIR="<PATH>/Qt/<QT_VERSION>/macos"
./deploy/build_macos_ne.sh
```

### Linux Build
```bash
export QT_BIN_DIR="/path/to/Qt/6.6.2/gcc_64/bin"
export VPNN_VERSION="2.2.0.5"
./deploy/build_linux.sh
```

Output: `VPNNaruzhu_Linux_Installer.bin`

### iOS Build
```bash
# Install gomobile first
export PATH=$PATH:~/go/bin
go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init

# Configure and build
export QT_BIN_DIR="<PATH>/Qt/<QT_VERSION>/ios/bin"
export QT_MACOS_ROOT_DIR="<PATH>/Qt/<QT_VERSION>/macos"
export QT_IOS_BIN=$QT_BIN_DIR
mkdir build-ios
$QT_IOS_BIN/qt-cmake . -B build-ios -GXcode -DQT_HOST_PATH=$QT_MACOS_ROOT_DIR -DVPNN_VERSION=2.2.0.5
```

Then open `build-ios/VPNNaruzhu.xcodeproj` in Xcode. If build fails with gomobile error, add user-defined variable `PATH=${PATH}:/usr/local/go/bin` to build settings.

### Android Build
Use Qt Creator with Android SDK 33, JDK 11, CMake 3.25.0. Or via script:
```bash
export ANDROID_SDK_ROOT="/path/to/android-sdk"
export ANDROID_NDK_ROOT="/path/to/ndk"
./deploy/build_android.sh
```

### Development Builds
For debugging with CMake directly:
```bash
mkdir build-debug
cd build-debug
cmake -DCMAKE_BUILD_TYPE=Debug -DVPNN_VERSION=2.2.0.5 ..
cmake --build . -j
```

Debug builds define `MZ_DEBUG` macro for verbose logging.

## Architecture

### Component Structure
```
Client (UI + Core Logic)
    ├── Qt/QML UI Layer (client/ui/)
    │   ├── Controllers (ConnectionController, SettingsController, etc.)
    │   ├── Models (ServersModel, ProtocolsModel, etc.)
    │   └── QML Views (main2.qml, Pages2/, Components/, Controls2/)
    ├── Core Layer (client/core/)
    │   ├── VpnConnection (manages VPN lifecycle in separate thread)
    │   ├── ServerController (server/container management)
    │   └── ErrorHandler (error definitions)
    ├── Protocol Layer (client/protocols/)
    │   ├── VpnProtocol (base class, factory pattern)
    │   └── Protocol implementations (OpenVpnProtocol, WireGuardProtocol, etc.)
    ├── Configurators (client/configurators/)
    │   └── Generate protocol configs via SSH (certificates, keys, .ovpn/.conf files)
    └── Platform Layer (client/platforms/)
        └── Windows/Linux/macOS/iOS/Android specific code

Service (Privileged Operations - Desktop only)
    └── Background daemon/service for routing, DNS, driver management

IPC (Inter-Process Communication - Desktop only)
    └── Qt Remote Objects for client-service communication
```

### Key Design Patterns
- **Factory Pattern**: `VpnProtocol::factory()` creates protocol instances based on container type
- **MVC Pattern**: Controllers handle business logic, Models hold data, QML Views render UI
- **Singleton Pattern**: `IpcClient::Instance()`, `Daemon::instance()`
- **Strategy Pattern**: Pluggable protocol implementations
- **Observer Pattern**: Qt signals/slots for event propagation

### IPC Architecture (Desktop Platforms)
The client uses Qt Remote Objects (`.rep` interface files) to communicate with privileged service:

**IPC Interface** (`ipc/ipc_interface.rep`):
- Route management: `routeAddList()`, `routeDeleteList()`, `clearSavedRoutes()`
- DNS management: `flushDns()`, `updateResolvers()`
- TUN device: `createTun()`, `deleteTun()`
- Kill switch: `enableKillSwitch()`, `disableKillSwitch()`
- Driver operations: `checkAndInstallDriver()`, `getTapList()`

Service runs with elevated privileges to perform system-level operations. Client connects via local socket (`local:VpnNaruzhuIpcInterface` on Windows, `/tmp/local:VpnNaruzhuIpcInterface` on Unix).

### Protocol Support
| Protocol | Container Name | Implementation | Platforms |
|----------|----------------|----------------|-----------|
| OpenVPN | `OpenVpn` | OpenVPN 2.x client | All |
| WireGuard | `WireGuard` | Go-based wireguard-go | All |
| AmneziaWG | `Awg` | Custom WireGuard fork | All |
| Shadowsocks | `ShadowSocks` | Shadowsocks obfuscation | Desktop, Android |
| Cloak | `Cloak` | OpenVPN over Cloak | Desktop, Android |
| XRay | `Xray` | XRay proxy protocol | Desktop |
| IKEv2 | `Ipsec` | Native Windows IPSec | Windows only |

Protocol configurators (`client/configurators/`) connect to servers via SSH, generate certificates/keys, and create client configuration files.

### Platform-Specific Notes

**iOS/macOS Network Extensions:**
- Use Apple's Network Extension framework
- Separate target/process from main app
- Code in `client/ios/` and `client/macos/networkextension/`
- Communication via app groups

**Android:**
- Kotlin/Java bridge in `client/android/`
- Uses Android VPN Service API
- Protocol-specific native libraries (WireGuard, OpenVPN, Cloak, AWG)

**Windows:**
- Service architecture using Qt Service framework
- TAP adapter for OpenVPN (managed via IPC)
- Native IKEv2/IPSec support

**Linux:**
- System daemon using systemd/init
- Direct `ip` command usage for routing
- Package dependency checking (openvpn, wireguard-tools)

### Settings & State Management
- Persistent storage: `SecureQSettings` wrapper around Qt's QSettings
- Hierarchical structure: Servers → Containers → Protocols → Config
- Server list stored in `Servers/serversList` with JSON structure
- VPN connection state managed by `VpnConnection` running in dedicated thread

### Threading Model
- **Main thread**: QML UI event loop
- **VPN thread**: `VpnConnection` operations (avoid blocking UI)
- **Service process**: Separate process for privileged operations (desktop)
- **Worker threads**: Network watchers, protocol-specific operations

### Third-Party Dependencies
Located in `client/3rd/` and `client/3rd-prebuilt/`:
- Qt Keychain (secure credential storage)
- QSimpleCrypto (encryption utilities)
- SortFilterProxyModel (QML list filtering)
- AmneziaWG (custom WireGuard implementation)
- Platform-specific prebuilt binaries (OpenVPN, OpenSSL, WireGuard)

## Common Development Tasks

### Adding a New VPN Protocol
1. Create protocol implementation in `client/protocols/` inheriting from `VpnProtocol`
2. Add configurator in `client/configurators/` inheriting from `ConfiguratorBase`
3. Define container in `client/containers/containers_defs.h`
4. Update `VpnProtocol::factory()` to instantiate your protocol
5. Add UI elements in `client/ui/qml/Pages2/` for protocol-specific settings
6. Update protocol models in `client/ui/models/`

### Modifying UI
- QML files: `client/ui/qml/`
  - Main entry: `main2.qml`
  - Pages: `Pages2/`
  - Reusable components: `Components/`, `Controls2/`
- Controllers: `client/ui/controllers/` (C++ business logic)
- Models: `client/ui/models/` (data exposed to QML)
- Use Qt signals/slots for controller-model communication

### Working with IPC (Desktop)
1. Modify `.rep` files in `ipc/` directory
2. CMake auto-generates replica classes via `qt_add_repc_replicas()`
3. Server-side implementation in `service/src/`
4. Client-side usage via `IpcClient::Instance()` singleton

### Debugging
- Enable debug builds with `-DCMAKE_BUILD_TYPE=Debug`
- Debug macro `MZ_DEBUG` enables verbose logging
- Logs via `common/logger/` utilities
- Platform-specific debugging:
  - Windows: Visual Studio debugger
  - macOS/iOS: Xcode debugger with LLDB
  - Linux: GDB
  - Android: Android Studio with logcat

### Environment Variables
Build scripts require:
- `VPNN_VERSION` - Version string (e.g., "2.2.0.5")
- `QT_BIN_DIR` - Path to Qt binaries
- `QIF_BIN_DIR` - Path to Qt Installer Framework (Windows installer build)

API endpoints configured via environment variables at build time:
- `PROD_AGW_PUBLIC_KEY`, `PROD_S3_ENDPOINT`
- `DEV_AGW_PUBLIC_KEY`, `DEV_AGW_ENDPOINT`, `DEV_S3_ENDPOINT`
- `FREE_V2_ENDPOINT`, `PREM_V1_ENDPOINT`

### Translation Files
- Source: `client/translations/*.ts` (Qt Linguist format)
- Only Russian (`vpnnaruzhu_ru_RU.ts`) is maintained per recent commits
- CMake auto-generates `.qm` files from `.ts` files
- Update translations: `lupdate` tool or Qt Linguist GUI

## Code Style
- C++17 standard
- Qt coding conventions
- Use Qt containers (QList, QMap, QString) for Qt-integrated code
- Signals/slots for event handling
- RAII for resource management
- Platform macros: `Q_OS_WIN`, `Q_OS_MAC`, `Q_OS_LINUX`, `Q_OS_IOS`, `Q_OS_ANDROID`, `AMNEZIA_DESKTOP`
