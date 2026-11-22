# Changelog

## v1.0.2 (2026-10-30)

### Fixes
- Camera: photo saving and camera feature entries reviewed for A04 (`patches/config/floating_feature-image_codec.txt`)
- NFC: Settings and antenna guide entries updated for A04 (`patches/settings/NfcSettings-antenna-position.diff`, `patches/settings/NfcAntennaGuideDialog-antenna-position.diff`)
- Lock screen camera shortcut shows the themed icon (`patches/camera/SamsungCamera-keyguard-shortcut-icon.diff`)
- adb: USB debugging keeps working after a reboot by handling `persist.adb.tradeinmode` in `init` (`patches/config/tradeinmode.rc.diff`)

### Other
- Debug logging adjustments (`patches/config/build.prop-v1.0.2-logging.txt`)
- Port Version in Settings and the installer show 1.0.2

### Notes
- PIN auto-confirm needs a PIN of 6+ digits (Android behavior)

## v1.0.1 (2026-10-29)

### Fixes
- Flashlight permissions handed to the camera service at boot (`patches/config/init.rc-flashlight.rc`)
- Settings translations merged via `scripts/merge_langs.py`
- Samsung DeX settings entry enabled in Settings (`patches/settings/DexModePreferenceController-show-dex.diff`)
- DeX Quick Settings tile state and long-press behavior updated (`patches/launcher/DesktopModeTile-dex-tile.diff`)

### New
- Experimental desktop/DeX property flag (`patches/config/build.prop-dex.txt`); test carefully on MT6765 hardware

### Other
- Installer: checks installed system when `/data` is mounted in recovery
- Port Version row in Settings shows 1.0.1
- `scripts/check_v101.sh`: pre-build check script

### Known issues
- Some features (such as DeX/external display or specific camera modes) depend on MT6765 hardware and kernel support
- Some carriers may require manual APN configuration
- Recovery sideload/flashing behavior depends on the recovery build used (e.g., OrangeFox)

## v1.0
- Initial port baseline
