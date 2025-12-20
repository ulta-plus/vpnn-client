# Windows Development Environment Setup Guide

## Goal
Set up a lightweight Windows 11 VM environment for VPNNaruzhu development with focus on:
- Building and debugging Windows client/service
- Editing C++ and QML code
- Testing bug fixes locally before CI builds
- Minimal disk usage where possible

## High-Level Steps

1. **Install Core Build Tools** (~4-7GB)
   - Visual Studio Build Tools 2019+ with MSVC compiler
   - CMake 3.25+

2. **Install Qt Framework** (~8-12GB)
   - Qt 6.6.2+ (or latest 6.6.x) with required modules
   - Skip Qt Creator if disk space is tight (can use VS Code for editing)

3. **Install Code Editor** (~500MB - 2GB)
   - VS Code (lightweight, recommended for editing)
   - OR Visual Studio Community (better debugging, heavier)

4. **Optional: Configure WSL** (~2-5GB, recommended for better terminal experience)
   - WSL2 with Ubuntu for POSIX-compliant terminal
   - Git and development tools

5. **Clone Repository & Build** (~2-3GB)
   - Clone with submodules
   - Configure environment variables
   - Initial build to verify setup

6. **Configure Debugging**
   - Set up VS Code or Visual Studio for debugging
   - Configure CMake integration

## Detailed Installation Steps

### Step 1: Install Visual Studio Build Tools

**Download:** Visual Studio 2019 or 2022 Build Tools
- https://visualstudio.microsoft.com/downloads/
- Scroll to "Tools for Visual Studio" → "Build Tools for Visual Studio 2022"

**Components to Install (Minimal):**
- ✅ Desktop development with C++
  - MSVC v142/v143 - VS 2019/2022 C++ x64/x86 build tools
  - Windows 10/11 SDK (latest version)
  - CMake tools for Windows
  - C++ CMake tools for Windows

**Skip:**
- ❌ MFC/ATL libraries (not needed)
- ❌ C++/CLI support (not needed)
- ❌ Address Sanitizer (optional, can add later)

**Disk Space:** ~4-6GB

**Alternative (If Disk Space Allows):**
Install full Visual Studio Community 2022 instead (~7-10GB) for integrated debugging experience.

---

### Step 2: Install CMake (If Not Included Above)

**Download:** https://cmake.org/download/
- Get Windows x64 Installer (latest 3.25+)

**Installation:**
- ✅ Add CMake to system PATH for all users

**Verify:**
```bash
cmake --version  # Should show 3.25+
```

---

### Step 3: Install Qt Framework

**Download:** Qt Online Installer
- https://www.qt.io/download-qt-installer
- Sign up for free Qt account (open-source)

**Qt Version to Install:** 6.6.2 or 6.6.3

**Components to Select:**

Under "Qt 6.6.x":
- ✅ MSVC 2019 64-bit (or MSVC 2022 64-bit if using VS 2022)
- ✅ Qt 5 Compatibility Module
- ✅ Qt Shader Tools
- ✅ Additional Libraries:
  - Qt Image Formats
  - Qt Multimedia
  - Qt Remote Objects
- ❌ Android/iOS/WebAssembly (not needed for Windows)
- ❌ Sources (not needed, saves ~2GB)
- ❌ Qt Debug Information Files (skip unless you need deep Qt debugging)

Under "Developer and Designer Tools":
- ❌ Qt Creator (skip if tight on space, use VS Code instead)
- ❌ Qt Installer Framework (not needed, CI builds installers)
- ❌ CMake, Ninja (already installed separately)

**Installation Path:** Default is fine (C:\Qt\6.6.x)

**Disk Space:** ~8-10GB (without Qt Creator), ~12GB (with Qt Creator)

---

### Step 4: Install Code Editor

**Option A: VS Code (Recommended for Lightweight Setup)**

**Download:** https://code.visualstudio.com/

**Extensions to Install:**
- C/C++ (Microsoft) - IntelliSense, debugging
- CMake Tools - CMake integration
- QML (bbenoist.QML) - QML syntax highlighting
- Qt for Python (optional, for Qt documentation)

**Disk Space:** ~500MB

**Pros:**
- Lightweight
- Fast startup
- Good for editing C++ and QML
- Decent debugging with C++ extension

**Cons:**
- Debugging setup requires manual configuration
- Less integrated than full Visual Studio

**Option B: Visual Studio Community (Best Debugging Experience)**

**Download:** https://visualstudio.microsoft.com/vs/community/

**Workloads to Install:**
- ✅ Desktop development with C++
- ✅ Optional: Qt VS Tools extension (from marketplace)

**Disk Space:** ~7-10GB

**Pros:**
- Best debugging experience for MSVC binaries
- Native CMake support
- Integrated profiler and diagnostics
- Qt Visual Studio Tools available

**Cons:**
- Much heavier than VS Code
- Slower startup

**Recommendation:** If you have 50GB+ disk space → Visual Studio. If tight on space → VS Code.

---

### Step 5: Configure WSL (Optional, Recommended)

**What is WSL?**

Windows Subsystem for Linux (WSL2) provides a native Linux environment on Windows. It's the modern standard for POSIX-compliant development on Windows in 2025.

**Important:** WSL is ONLY used for terminal/git operations. All compilation still uses Windows tools (MSVC, Windows Qt).

**Installation:**

1. Open PowerShell as Administrator and run:
   ```powershell
   wsl --install
   ```
   This installs WSL2 with Ubuntu by default.

2. Restart your computer when prompted.

3. After restart, Ubuntu will launch automatically. Create a username and password.

4. Update packages and install git:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install git build-essential -y
   ```

**Why WSL2?**

✅ **Native POSIX environment** - Full Linux experience, not emulated
✅ **Better Git performance** - Linux git is faster than Windows git
✅ **Familiar for Mac users** - bash, ls, grep, sed, awk, ssh work exactly like Mac
✅ **Can call Windows tools** - Run Windows .exe files from WSL (cmake.exe, code.exe)
✅ **Access Windows files** - Your C:\ drive is at `/mnt/c/`

**How WSL Interop Works:**

```bash
# In WSL, you can call Windows executables:
cmake.exe --version           # Calls Windows CMake
code.exe .                    # Opens Windows VS Code
/mnt/c/Qt/6.6.2/msvc2019_64/bin/qmake.exe --version
```

**Important Notes:**

- **Compilation happens on Windows**: MSVC, Qt, and all build tools run natively on Windows
- **WSL is just your terminal**: You use it for git, editing with vim/nano, running scripts
- **Files are on Windows**: Clone repository to `/mnt/c/Users/YourName/Projects` (Windows drive)
- **Performance**: Accessing Windows files from WSL is slightly slower, but acceptable for development

**Disk Space:** ~2-5GB for WSL2 + Ubuntu

**Alternative:** If you prefer not to use WSL:
- Use PowerShell (built into Windows)
- Use Windows Terminal (modern terminal app from Microsoft Store)
- Install Git for Windows (includes Git Bash, ~300MB)

---

### Step 6: Clone Repository

**Option A: Using WSL (Recommended if you installed WSL):**

```bash
# Navigate to your Windows projects folder (via WSL)
cd /mnt/c/Users/YourUsername/Projects

# Clone with submodules (IMPORTANT!)
git clone --recursive https://github.com/vpn-naruzhu/vpnn-client.git

# Or if already cloned without submodules:
cd vpnn-client
git submodule update --init --recursive
```

**Verify Submodules:**
```bash
# Should see populated directories:
ls client/3rd/
ls client/3rd-prebuilt/
```

**Option B: Using PowerShell or Command Prompt:**

```powershell
# Navigate to your projects folder
cd C:\Users\YourUsername\Projects

# Clone with submodules (IMPORTANT!)
git clone --recursive https://github.com/vpn-naruzhu/vpnn-client.git

# Or if already cloned without submodules:
cd vpnn-client
git submodule update --init --recursive
```

**Note:** If using PowerShell and git is not installed, install Git for Windows from https://git-scm.com/download/win

---

### Step 7: Set Up Environment Variables

**Option A: Set Permanently (Recommended)**

Using PowerShell (Run as Administrator):
```powershell
# Set Qt bin directory (adjust version/path as needed)
[System.Environment]::SetEnvironmentVariable('QT_BIN_DIR', 'C:\Qt\6.6.2\msvc2019_64\bin', 'User')

# Set version for local builds
[System.Environment]::SetEnvironmentVariable('VPNN_VERSION', '2.2.0.5-dev', 'User')

# Set build architecture
[System.Environment]::SetEnvironmentVariable('BUILD_ARCH', '64', 'User')
```

**Option B: Set Per-Session**

Create a batch file `setup_env.bat` in project root:
```batch
@echo off
set QT_BIN_DIR=C:\Qt\6.6.2\msvc2019_64\bin
set VPNN_VERSION=2.2.0.5-dev
set BUILD_ARCH=64
set PATH=%QT_BIN_DIR%;%PATH%
echo Environment configured for VPNNaruzhu development
```

Run before each build session: `setup_env.bat`

---

### Step 8: Configure Build (CMake)

**Option A: Using WSL:**

```bash
# Navigate to project root (Windows path via WSL)
cd /mnt/c/Users/YourUsername/Projects/vpnn-client

# Create build directory
mkdir build-debug
cd build-debug

# Configure with CMake (calling Windows CMake)
cmake.exe .. -G "Visual Studio 17 2022" -A x64 \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_PREFIX_PATH="C:/Qt/6.6.2/msvc2019_64" \
  -DVPNN_VERSION=2.2.0.5-dev
```

**Note:** Use `cmake.exe` (not `cmake`) to call Windows CMake from WSL.

**Option B: Using PowerShell:**

```powershell
# Navigate to project root
cd C:\Users\YourUsername\Projects\vpnn-client

# Create build directory
New-Item -ItemType Directory -Path build-debug -Force
cd build-debug

# Configure with CMake (Debug build for development)
cmake .. -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_BUILD_TYPE=Debug `
  -DCMAKE_PREFIX_PATH="C:/Qt/6.6.2/msvc2019_64" `
  -DVPNN_VERSION=2.2.0.5-dev
```

**Note on Generator:**
- Use "Visual Studio 17 2022" for VS 2022
- Use "Visual Studio 16 2019" for VS 2019
- Adjust based on what you installed

---

### Step 9: Build the Project

**Option A: Command Line (WSL or PowerShell)**

From WSL:
```bash
# From build-debug directory:
cmake.exe --build . --config Debug -j 8

# -j 8 uses 8 parallel jobs (adjust based on VM CPU cores)
```

From PowerShell:
```powershell
# From build-debug directory:
cmake --build . --config Debug -j 8
```

**Option B: Visual Studio**

```
1. Open build-debug/VPNNaruzhu.sln in Visual Studio
2. Set build configuration to Debug
3. Build > Build Solution (Ctrl+Shift+B)
```

**Expected Output:**
- `build-debug/client/Debug/VPNNaruzhu.exe` - Main application
- `build-debug/service/server/Debug/VPNNaruzhu-service.exe` - Background service

**First Build:** May take 10-20 minutes depending on VM performance.

---

### Step 10: Run and Test

**Running the Application:**

```bash
# From build directory:
cd client/Debug
./VPNNaruzhu.exe
```

**Note:** The service component (`VPNNaruzhu-service.exe`) requires administrator privileges for full functionality (routing, DNS, TUN device management).

**Testing Without Service (Limited):**
- UI will launch
- You can test non-privileged operations
- VPN connections will fail without service running

**Testing With Service:**

From WSL:
```bash
# Run as Administrator:
cd service/server/Debug
./VPNNaruzhu-service.exe
```

From PowerShell (Run as Administrator):
```powershell
cd service\server\Debug
.\VPNNaruzhu-service.exe
```

---

### Step 11: Configure Debugging

#### VS Code Debugging Setup

Create `.vscode/launch.json` in project root:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug VPNNaruzhu Client",
      "type": "cppvsdbg",
      "request": "launch",
      "program": "${workspaceFolder}/build-debug/client/Debug/VPNNaruzhu.exe",
      "args": [],
      "stopAtEntry": false,
      "cwd": "${workspaceFolder}/build-debug/client/Debug",
      "environment": [],
      "console": "integratedTerminal"
    },
    {
      "name": "Debug VPNNaruzhu Service",
      "type": "cppvsdbg",
      "request": "launch",
      "program": "${workspaceFolder}/build-debug/service/server/Debug/VPNNaruzhu-service.exe",
      "args": [],
      "stopAtEntry": false,
      "cwd": "${workspaceFolder}/build-debug/service/server/Debug",
      "environment": [],
      "console": "integratedTerminal"
    }
  ]
}
```

Create `.vscode/settings.json`:

```json
{
  "cmake.configureOnOpen": false,
  "cmake.buildDirectory": "${workspaceFolder}/build-debug",
  "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools"
}
```

**Using the Debugger:**
1. Open source file (e.g., `client/main.cpp`)
2. Set breakpoint (F9)
3. Press F5 or Run > Start Debugging
4. Select "Debug VPNNaruzhu Client"

#### Visual Studio Debugging Setup

1. Open `build-debug/VPNNaruzhu.sln`
2. Right-click `VPNNaruzhu` project → Set as Startup Project
3. Press F5 to debug
4. Breakpoints, watch windows, call stack all work natively

**Debugging Tips:**
- Debug builds have `MZ_DEBUG` macro defined for verbose logging
- Check logs in Windows Event Viewer for service issues
- Use Qt Creator's QML debugger if you need to debug QML (optional install)

---

## Development Workflow

### Typical Bug Fix Workflow:

1. **Edit Code:** Use VS Code or Visual Studio
   - C++ files: `client/`, `service/`
   - QML files: `client/ui/qml/`
   - Protocol implementations: `client/protocols/`

2. **Rebuild:**
   ```bash
   cd build-debug
   cmake --build . --config Debug -j 8
   ```
   Or use Visual Studio Build Solution.

3. **Test:**
   - Run `VPNNaruzhu.exe` from `build-debug/client/Debug/`
   - Launch service separately if testing IPC functionality

4. **Debug:**
   - Set breakpoints in VS Code or Visual Studio
   - Use F5 to start debugging
   - Step through code, inspect variables

5. **Commit:**
   ```bash
   git add .
   git commit -m "Fix: description of bug fix"
   git push origin your-branch
   ```

6. **CI Build:** GitHub Actions will build installer and run full tests

### Quick Rebuild After Changes:

```bash
# Incremental build (only changed files):
cmake --build build-debug --config Debug -j 8

# Clean rebuild if CMake changes:
cd build-debug
cmake ..
cmake --build . --config Debug -j 8
```

---

## Disk Space Summary

**Minimal Setup (~15-20GB):**
- Visual Studio Build Tools: ~4-6GB
- CMake: ~100MB
- Qt 6.6.2 (minimal): ~8GB
- VS Code: ~500MB
- WSL2 + Ubuntu (optional): ~2-5GB
- Repository + Build: ~2-3GB

**Comfortable Setup (~27-32GB):**
- Visual Studio Community: ~7-10GB
- CMake: ~100MB
- Qt 6.6.2 (with Qt Creator): ~12GB
- WSL2 + Ubuntu: ~2-5GB
- Repository + Build: ~2-3GB

---

## QML Editing Tools

### Lightweight Option: VS Code
- Install QML extension (bbenoist.QML)
- Syntax highlighting and basic code completion
- No live preview

### Full-Featured Option: Qt Creator
- Install via Qt Installer (add to existing Qt installation)
- QML live preview and design mode
- Qt Quick Designer for visual editing
- ~2GB additional disk space

**Recommendation:**
- If only fixing C++ bugs → Skip Qt Creator, use VS Code
- If editing QML UI → Install Qt Creator later if needed

---

## Common Issues and Solutions

### Issue: CMake can't find Qt
**Solution:** Ensure CMAKE_PREFIX_PATH points to Qt installation:
```bash
-DCMAKE_PREFIX_PATH="C:/Qt/6.6.2/msvc2019_64"
```

### Issue: Missing MSVC compiler
**Solution:**
- Verify Visual Studio Build Tools installed with C++ workload
- Run CMake from "Developer Command Prompt for VS 2022"

### Issue: Submodules not populated
**Solution:**
```bash
git submodule update --init --recursive
```

### Issue: Build fails with OpenSSL errors
**Solution:** Prebuilt binaries are in `client/3rd-prebuilt/`, should work automatically. Check CMake output for path detection.

### Issue: Service won't start (Access Denied)
**Solution:** Run service executable as Administrator (required for network operations)

---

## Critical Files Reference

### Build Configuration:
- `/CMakeLists.txt` - Root CMake configuration
- `/client/CMakeLists.txt` - Client build configuration
- `/service/CMakeLists.txt` - Service build configuration

### Windows-Specific Code:
- `/client/platforms/windows/` - Windows platform implementation
- `/service/src/` - Service daemon implementation
- `/ipc/` - IPC interface definitions

### Main Entry Points:
- `/client/main.cpp` - Client application entry
- `/client/amnezia_application.cpp` - Main application class
- `/service/server/` - Service entry point

---

## Next Steps After Setup

1. **Verify Build Works:**
   - Complete a full Debug build
   - Launch the application
   - Confirm UI loads

2. **Test Debugging:**
   - Set a breakpoint in `main.cpp`
   - Start debugger
   - Verify breakpoint hits

3. **Identify Bug to Fix:**
   - Review bug reports
   - Locate relevant code
   - Make changes and test

4. **Optional: Configure Git:**
   ```bash
   git config user.name "Your Name"
   git config user.email "your.email@example.com"
   ```

---

## Estimated Total Time to Setup

- **Downloads:** 1-2 hours (depending on internet speed)
- **Installations:** 30-45 minutes
- **Configuration & First Build:** 30-45 minutes
- **Total:** 2-3.5 hours for complete setup

---

## Summary: Recommended Minimal Setup for Bug Fixes

1. ✅ Visual Studio Build Tools 2022 (MSVC compiler)
2. ✅ CMake 3.25+
3. ✅ Qt 6.6.2+ (MSVC 2019/2022 64-bit + required modules)
4. ✅ VS Code (for editing) + C/C++ extension
5. ✅ WSL2 (optional but recommended - better terminal than Git Bash or PowerShell)
6. ❌ Skip: Qt Creator (unless editing QML)
7. ❌ Skip: Qt Installer Framework (CI handles installers)
8. ❌ Skip: Code signing tools (CI handles signing)

This gives you a working development environment in ~15-20GB that can:
- Build Debug/Release builds locally
- Debug with breakpoints and step-through
- Edit C++ and QML code
- Test changes before pushing to CI
