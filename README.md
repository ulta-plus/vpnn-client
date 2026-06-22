# VPNNaruzhu
## _Amnezia based VPN client_

[![Build Status](https://github.com/vpn-naruzhu/vpnn-client/actions/workflows/deploy.yml/badge.svg?branch=dev)](https://github.com/vpn-naruzhu/vpnn-client/actions/workflows/deploy.yml?query=branch:dev)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/vpn-naruzhu/vpnn-client)

### [English]([https://github.com/ulta-plus/vpnn-client/blob/dev/README_RU.md](https://github.com/ulta-plus/vpnn-client/tree/dev?tab=readme-ov-file#)) | [Русский](https://github.com/ulta-plus/vpnn-client/blob/dev/README_RU.md)


[Amnezia](https://amnezia.org?utm_source=github&utm_campaign=amnezia_website-readme-en) is an open-source VPN client, with a key feature that enables you to deploy your own VPN server on your server.

[![Image](https://github.com/ulta-plus/vpnn-client/blob/dev/metadata/img-readme/uipic4.png)](https://amnezia.org)

### [Website](https://amnezia.org?utm_source=github&utm_campaign=amnezia_website-readme-en) | [Alt website link](https://storage.googleapis.com/amnezia/amnezia.org?utm_source=github&utm_campaign=amnezia_website-readme-en-mirror) | [Documentation](https://docs.amnezia.org) | [Troubleshooting](https://docs.amnezia.org/troubleshooting)

<a href="https://github.com/ulta-plus/vpnn-client/releases/download/v2.1.5.0/VPNNaruzhu_Windows_installer_2.1.5.0.zip"><img src="https://github.com/vpn-naruzhu/vpnn-client/blob/vpnn-dev/metadata/img-readme/win.png" width="150" style="max-width: 100%;"></a>

<br>

[All releases](https://github.com/ulta-plus/vpnn-client/releases)

<br/>

<a href="https://www.testiny.io"><img src="https://github.com/ulta-plus/vpnn-client/blob/dev/metadata/img-readme/testiny.png" height="28px"></a>

## Features

- Very easy to use - enter your IP address, SSH login, password and Amnezia will automatically install VPN docker containers to your server and connect to the VPN.
- Classic VPN-protocols: OpenVPN, WireGuard and IKEv2 protocols.
- Protocols with traffic Masking (Obfuscation): OpenVPN over [Cloak](https://github.com/cbeuw/Cloak) plugin, Shadowsocks (OpenVPN over Shadowsocks), [AmneziaWG](https://docs.amnezia.org/documentation/amnezia-wg/) and XRay.
- Split tunneling support - add any sites to the client to enable VPN only for them or add Apps (only for Android and Desktop).
- Windows, MacOS, Linux, Android, iOS releases.
- Support for AmneziaWG protocol configuration on [Keenetic beta firmware](https://docs.keenetic.com/ua/air/kn-1611/en/6319-latest-development-release.html#UUID-186c4108-5afd-c10b-f38a-cdff6c17fab3_section-idm33192196168192-improved).

## Links

- [https://naruzhu.click/appam](https://naruzhu.click/appam) - project website
- [https://www.reddit.com/r/AmneziaVPN](https://www.reddit.com/r/AmneziaVPN) - Reddit of original project
- [https://t.me/vpn_naruzhu_support_bot](https://t.me/vpn_naruzhu_support_bot) - Telegram support
- [https://t.me/vpnnaruzhu](https://t.me/vpnnaruzhu) - Telegram group

## Tech

VPNNaruzhu uses several open-source projects to work:

- [OpenSSL](https://www.openssl.org/)
- [OpenVPN](https://openvpn.net/)
- [Qt](https://www.qt.io/)
- [LibSsh](https://libssh.org)
- [WireGuard](https://www.wireguard.com/)
- [Xray-core](https://xtls.github.io/en/)
- [Conan](https://conan.io/)
- and more...

## Help us with translations

Download the most actual translation files.

Go to ["Actions" tab](https://github.com/ulta-plus/vpnn-client/actions?query=is%3Asuccess+branch%3Adev), click on the first line.
Then scroll down to the "Artifacts" section and download "VPNNaruzhu_translations".

Unzip this file.
Each *.ts file contains strings for one corresponding language.

Translate or correct some strings in one or multiple *.ts files and commit them back to this repository into the ``client/translations`` folder.
You can do it via a web-interface or any other method you're familiar with.

## Checking out the source code

Check deploy folder for build scripts.

### How to build for Windows

1. Install:
    - QT 6.6.3:
        - Qt 5 Compatibility Module
        - Qt Shader Tools
        - Qt Install Framework 4.8
        - Additional Libraries:
            - Qt Image Formats
            - Qt Multimedia
            - Qt Remote Objects
    - cmake >= 3.25
    - go >= v1.16

2. Build:
```
set QT_BIN_DIR="[PATH_TO_QT]\Qt\[QT_VERSION]\msvc2019_64\bin"
set QIF_BIN_DIR="[PATH_TO_QT]\Qt\Tools\QtInstallerFramework\4.8\bin"
set BUILD_ARCH=64
.\deploy\build_windows.bat
```

### How to build an iOS app from source code on MacOS

```bash
git submodule update --init --recursive
```

## Hacking guide

Want to contribute? Welcome!

### Build requirements

* [`CMake`](https://cmake.org/download/)
* Compiler and underlying build system, depending on the target:
  - [Linux] Any of `make` and `gcc`
  - [Apple] [`Xcode`](https://developer.apple.com/xcode/) or [`Xcode command line tools`](https://developer.apple.com/xcode/)
  - [Windows] [`Visual Studio 2022`](https://aka.ms/vs/17/release/vs_community.exe) or [`VS 2022 Build Tools`](https://aka.ms/vs/17/release/vs_buildtools.exe)
  - [Android] [`Android SDK`](#installing-android-sdk) and [`Ninja`](https://ninja-build.org/)
* [`Qt 6.10+`](https://www.qt.io/download-open-source) with the following modules:
  - Core module for targeting platform (Desktop/Android/iOS)
  - Qt 5 Compatibility module
  - Qt Remote Objects
* [`Conan`](https://conan.io/downloads) package manager
  - On MacOS is enough just to use `homebrew` or install it in `.venv` in project root
  - Other systems must have it in `PATH`
* (Optional) Installer dependencies:
  - [Windows/Linux] [`Qt Installer Framework`](https://www.qt.io/download-open-source)
  - [Windows] [`WIX toolset`](https://github.com/wixtoolset/wix/releases)

### Building the project using scripts

* Run scripts located in `deploy` directory
* Basically, if dependencies are located in default installation paths, the scripts will find them automatically.
* If they differ, specify them using the following variables:
  - `QT_INSTALL_DIR` - Qt root installation folder
  - `QT_ROOT_PATH`   - Qt framework root directory
  - `QIF_ROOT_PATH`  - Qt Installer Framework root path
  - `ANDROID_HOME`   - Path to Android SDK root folder
  - and others. Check scripts for more

Unix-like:
```bash
# Build executables for the host platform
deploy/build.sh

# Or just
deploy/build.sh

# Build executables and installers for the host platform
deploy/build.sh --installer all

# Build Android APK and AAB
deploy/build.sh -t android --aab

# Call for help
deploy/build.sh -h


Windows:
```batch
:: Build executables for Windows
deploy/build.bat

:: Build executables with IFW installer for Windows
deploy/build.bat --installer ifw

:: Build executables with IFW and WIX installer for Windows
deploy/build.bat --installer ifw --installer wix

:: Or just
deploy/build.bat --installer all

### Developing the project in IDEs

* Basically, you can use any IDE that handles CMake and Qt kits properly to run configure and build steps, and to navigate through the code nicely. For example:
  - `Qt Creator`
  - `Visual Studio Code` with `Qt Extension Pack`
  - and so on

* To use `Xcode`, you have to configure project first by using `cmake`. The easiest way to do it is to use `Qt Creator` for configuration. Then open `AmneziaVPN.xcodeproj` file from the build folder by using `Xcode`. Note that none of the files changed are saved - the files actually getting changed in build directory. Copy them manually if necessary

* `Android studio` could be used in the same way - just configure the project by using `cmake` manually or by using `Qt Creator`. Open `<build-dir>/client/android-build` in `Android studio` then. Do not forget to copy the changes - everything you do is saved under the build directory actually.

### Installing Android SDK

* Android SDK could be installed using the following methods:
  - Using `Qt Creator`. Use `Preferences`->`SDKs`
  - Using `Android studio`. By default it installs necessary `SDKs` automatically during the installation
  - Manually by using `sdk-manager`. Check [this](https://developer.android.com/tools) page for details

## License

This project is licensed under the GNU General Public License v3.0 (see LICENSE) and also includes third-party components distributed under their own terms (see THIRD_PARTY_LICENSES.md).

## Donate

Patreon: [https://www.patreon.com/amneziavpn](https://www.patreon.com/amneziavpn)

Bitcoin: bc1qdy94rqqye8ez64qy59dl6e5cz3pks4mxku85vk <br>
USDT BEP20: 0x6abD576765a826f87D1D95183438f9408C901bE4 <br>
USDT TRC20: TYR4YCLV5crWB7htBDAZoDve6sRB9AxJJQ <br>
XMR: 48spms39jt1L2L5vyw2RQW6CXD6odUd4jFu19GZcDyKKQV9U88wsJVjSbL4CfRys37jVMdoaWVPSvezCQPhHXUW5UKLqUp3 <br>
TON: UQDpU1CyKRmg7L8mNScKk9FRc2SlESuI7N-Hby4nX-CcVmns

## Acknowledgments

This project is tested with BrowserStack.
We express our gratitude to [BrowserStack](https://www.browserstack.com) for supporting our project.
