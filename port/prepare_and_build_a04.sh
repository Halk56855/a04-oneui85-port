#!/bin/bash
# Prepare Galaxy A04 (SM-A045F) port workspace, inspect stock super, and run build + packaging + verification
set -e

STOCK_RAW="${STOCK_RAW:-$HOME/a04port/work/stock/super/super_stock.raw.img}"
PORT_DIR="${PORT_DIR:-$HOME/a04port/work/port}"
OUT_DIR="${OUT_DIR:-$HOME/a04port/work/out}"
KERNEL_DIR="${KERNEL_DIR:-$HOME/a04port/work/kernel}"
RELEASE_DIR="${RELEASE_DIR:-$HOME/a04port/release}"
LOGS_DIR="${LOGS_DIR:-$HOME/a04port/logs}"
REPO_DIR="${REPO_DIR:-$HOME/a04port/work/adapted_repo}"

mkdir -p \
  "$PORT_DIR/system" \
  "$PORT_DIR/vendor" \
  "$PORT_DIR/product" \
  "$OUT_DIR" \
  "$KERNEL_DIR" \
  "$RELEASE_DIR" \
  "$LOGS_DIR"

echo "== 1. Inspect stock super image (if available) =="
if [ -f "$STOCK_RAW" ] && command -v lpdump >/dev/null 2>&1; then
  lpdump "$STOCK_RAW" | tee "$LOGS_DIR/stock-super-lpdump.txt"
  DETECTED_SUPER_SIZE=$(stat -c %s "$STOCK_RAW")
  echo "Detected stock super size: $DETECTED_SUPER_SIZE bytes"
else
  DETECTED_SUPER_SIZE="${SUPER_SIZE:-8053063680}"
  echo "Stock super not found at $STOCK_RAW; using SUPER_SIZE=$DETECTED_SUPER_SIZE"
fi

echo "== 2. Stage system / vendor / product into port/ =="
if [ -d "$HOME/work/sys85/system" ] && [ -n "$(ls -A "$HOME/work/sys85/system" 2>/dev/null)" ]; then
  cp -a "$HOME/work/sys85/system/." "$PORT_DIR/system/"
fi

if [ -d "$HOME/work/vendor_src" ] && [ -n "$(ls -A "$HOME/work/vendor_src" 2>/dev/null)" ]; then
  cp -a "$HOME/work/vendor_src/." "$PORT_DIR/vendor/"
fi

echo "== 3. Remove any raw patch files (.diff / .smali) from port/ =="
find "$PORT_DIR" -type f \( -name "*.diff" -o -name "*.smali" \) -delete

echo "== 4. Ensure kernel & installer files are in place =="
[ -f "$OUT_DIR/boot.img" ] && [ ! -f "$KERNEL_DIR/boot.img" ] && cp "$OUT_DIR/boot.img" "$KERNEL_DIR/boot.img"
[ -f "$REPO_DIR/installer/update-binary" ] && cp "$REPO_DIR/installer/update-binary" "$RELEASE_DIR/update-binary"
[ -f "$REPO_DIR/installer/NOTICE.txt" ] && cp "$REPO_DIR/installer/NOTICE.txt" "$RELEASE_DIR/NOTICE.txt"
[ -f "$REPO_DIR/NOTICE.txt" ] && [ ! -f "$RELEASE_DIR/NOTICE.txt" ] && cp "$REPO_DIR/NOTICE.txt" "$RELEASE_DIR/NOTICE.txt"

echo "== 5. Run build.sh & make_zip.py =="
export PORT="$PORT_DIR"
export OUT="$OUT_DIR"
export LOGS="$LOGS_DIR"
export SUPER_SIZE="$DETECTED_SUPER_SIZE"

if [ -f "$REPO_DIR/scripts/build.sh" ]; then
  bash "$REPO_DIR/scripts/build.sh"
fi

if [ -f "$REPO_DIR/installer/make_zip.py" ] && [ -f "$OUT_DIR/super.raw.img" ] && [ -f "$KERNEL_DIR/boot.img" ] && [ -f "$RELEASE_DIR/update-binary" ]; then
  python3 "$REPO_DIR/installer/make_zip.py" "$RELEASE_DIR/A04_OneUI8.5_Port.zip"
fi

echo "== 6. Run verify_build.sh if present =="
if [ -f "$REPO_DIR/scripts/verify_build.sh" ] && [ -f "$OUT_DIR/super.raw.img" ]; then
  sudo HOME="$HOME" \
    W="$HOME/a04port/work" \
    OUT="$OUT_DIR" \
    SUPER="$OUT_DIR/super.raw.img" \
    EXPECTED_SUPER_SIZE="$DETECTED_SUPER_SIZE" \
    bash "$REPO_DIR/scripts/verify_build.sh" "$RELEASE_DIR/A04_OneUI8.5_Port.zip" || true
fi

echo ">>> DONE"
