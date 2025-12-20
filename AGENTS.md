# Repository Guidelines

## Project Structure & Module Organization
Core sources live in `client/`: `core/`, `containers/`, `protocols/`, and `ui/controllers` hold the Qt/C++ logic while `ui/qml` contains reusable QML components. Assets are bundled from `fonts/`, `images/`, `translations/`, and `resources.qrc`. `service/` builds the desktop helper daemon; `common/` plus `ipc/` carry headers shared with the GUI. Release tooling resides in `deploy/` (build scripts, installer config), documentation in `docs/`, and release collateral inside `metadata/`. Pull every third-party dependency by running `git submodule update --init --recursive` after cloning because `client/3rd` and `client/3rd-prebuilt` are submodules.

## Build, Test, and Development Commands

**Recommended: Using CMake Presets**
```bash
# First-time setup
git submodule update --init --recursive
cp CMakeUserPresets.json.template CMakeUserPresets.json
# Edit CMakeUserPresets.json with your Qt path, version, and API endpoints

# Configure and build
cmake --preset dev-debug
cmake --build build-debug
ctest --test-dir build-debug --output-on-failure
```

**Alternative: Manual Configuration**
Set the version string and Qt path before configuring.
```bash
git submodule update --init --recursive
export VPNN_VERSION=2.2.0.5-dev QT_BIN_DIR=$HOME/Qt/6.6.3/macos/bin
$QT_BIN_DIR/qt-cmake -S . -B build -DVPNN_VERSION=$VPNN_VERSION
cmake --build build --config Release
ctest --test-dir build --output-on-failure
```

**Deployment Scripts**
Use the scripted entry points when packaging or targeting stores: `./deploy/build_linux.sh`, `bash deploy/build_macos.sh -n`, `deploy/build_windows.bat`, `bash deploy/build_android.sh`, and `bash deploy/build_ios.sh`. Each script expects the matching Qt kit plus signing credentials (e.g., `MAC_APP_CERT_PW`, `APPLE_DEV_EMAIL`) provided via environment variables.

## Coding Style & Naming Conventions
`.clang-format` (WebKit base) enforces 4-space indentation, 120-column limits, sorted includes, and brace-on-next-line namespaces. Keep member variables prefixed with `m_`, prefer smart pointers, and guard platform specifics with the existing `Q_OS_*` macros. QML files stay PascalCase with `id: root`, lowerCamelCase properties, and palette tokens pulled from `client/ui/qml/Modules/Style`. Add or update translations in `client/translations/*.ts`.

## Testing Guidelines
QtTest- and ctest-backed suites live beside the code they cover (for example, `client/3rd/QJsonStruct/test`). Name fixtures `<Feature>Test`, reuse provisioning data from `client/server_scripts`, and update those mocks whenever container creation flows change. Run `ctest` after each build (set `CTEST_OUTPUT_ON_FAILURE=1` when triaging) and aim to cover the GUI state change plus service IPC path touched by your change before submitting a PR.

## Commit & Pull Request Guidelines
Recent history favors short, imperative subjects (`Add run with test configs.`). Keep commits scoped, add platform tags when helpful (`macos: ...`), and reference GitHub issues in the body. Pull requests should describe the behavior shift, list the build/test commands you ran, attach screenshots for UI updates, and mention any signing or server prerequisites reviewers must satisfy.

## Security & Configuration Tips
Never commit credentials or `.p12` blobs. Feed the secrets referenced in `deploy/build_*` via environment variables, and prefer local keychains over repo storage. For development, use `CMakeUserPresets.json` (which is in `.gitignore`) to store your local Qt paths and API endpoints - copy from `CMakeUserPresets.json.template` and customize. `version.h` is generated from `version.h.in`; change only the template tokens and let CMake emit the concrete header during configure.
