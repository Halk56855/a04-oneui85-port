#!/usr/bin/env python3
import hashlib, os, sys, zipfile

H = os.path.expanduser
SRC = H('~/a04port/work/out/super.raw.img')
BOOT, DTBO = H('~/a04port/work/kernel/boot.img'), H('~/a04port/work/kernel/dtbo.img')
UB, NOTICE = H('~/a04port/release/update-binary'), H('~/a04port/release/NOTICE.txt')
OUT = H(sys.argv[1]) if len(sys.argv) > 1 else H('~/a04port/release/A04_OneUI8.5_Port.zip')
CH = 64 * 1024 * 1024

size = os.path.getsize(SRC)
if size % CH:
    sys.exit(f"STOP: super.raw.img size {size} is not a multiple of {CH}")

n, zero, man = size // CH, bytes(CH), []
with zipfile.ZipFile(OUT, 'w', allowZip64=True) as z:
    z.write(UB, 'META-INF/com/google/android/update-binary', compress_type=zipfile.ZIP_STORED)
    z.writestr('META-INF/com/google/android/updater-script', '# installer logic is in update-binary\n')
    with open(SRC, 'rb') as f:
        for i in range(n):
            c = f.read(CH)
            if c == zero:
                man.append(f'{i} Z -')
            else:
                man.append(f'{i} D {hashlib.sha256(c).hexdigest()}')
                z.writestr(f'super/{i:03d}.bin', c, compress_type=zipfile.ZIP_DEFLATED, compresslevel=1)
            print(f'\r  packing system: {100*(i+1)//n}% ({i+1}/{n})', end='', flush=True)
    print()
    z.writestr('super/manifest.txt', '\n'.join(man) + '\n')
    for name, p in (('boot', BOOT), ('dtbo', DTBO)):
        if os.path.exists(p):
            d = open(p, 'rb').read()
            z.writestr(f'kernel/{name}.img', d, compress_type=zipfile.ZIP_DEFLATED, compresslevel=6)
            z.writestr(f'kernel/{name}.sha', f'{len(d)} {hashlib.sha256(d).hexdigest()}\n')
        else:
            print(f'warning: {p} not found, skipping kernel/{name}.img')
    if os.path.exists(NOTICE):
        z.write(NOTICE, 'NOTICE.txt')

data = sum(1 for m in man if ' D ' in m)
print(f'done: {OUT}\n  {n} parts ({data} with data, {n-data} empty), {os.path.getsize(OUT)/1e9:.2f} GB')
