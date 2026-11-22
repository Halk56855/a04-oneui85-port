# Binary Patches for Galaxy A04 (SM-A045F / MT6765)

Do NOT apply Qualcomm/SM7150 byte offsets directly to Galaxy A04 binaries.
Verify every offset against the stock A04 firmware downloaded via `samloader-rs` before patching.

## Verification steps
1. Extract stock A04 binaries (`vold`, `libstagefright.so`, etc.) from the firmware downloaded with `samloader-rs`.
2. Inspect target functions/bytes with `readelf`, `objdump`, or `xxd` on the exact A04 binary build.
3. Only apply verified byte patches after backing up original files and stock firmware.
