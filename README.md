# One UI 8.5 port for Samsung Galaxy A04 (SM-A045F)

Build scripts, installer and patches for an unofficial One UI 8.5 (Android 16) port adapted for the Samsung Galaxy A04 (SM-A045F / MT6765), based on port work by saantiqz (built with the help of Claude by Anthropic).

**Latest:** v1.0.2, see [CHANGELOG.md](CHANGELOG.md).

This repo contains no Samsung or Google firmware. Patches and build steps are adapted for A04; to build and modify firmware, you need your own stock firmware copies (such as those downloaded via `samloader-rs`) and Galaxy A04 device/vendor/kernel trees.

- `scripts/`: building the super image (`build.sh`), pre-build checklist, post-build verifier, partition extractor, Settings language merge (v1.0.1), v1.0.1 check
- `installer/`: the recovery installer (`update-binary`) and the zip packer (`make_zip.py`)
- `patches/services/`: `services.jar` changes (KnoxGuard, ICCC, platform signature, GPU-memory handling)
- `patches/framework/`: camera/property adjustments (`framework.jar`)
- `patches/settings/`: port info rows and controller in Settings > Software information; DeX menu entry (v1.0.1)
- `patches/camera/`: lock screen shortcut icon tags in the camera manifest (v1.0.2)
- `patches/launcher/`: DeX Quick Settings tile state and long press (v1.0.1)
- `patches/config/`: config changes (floating feature, fstab/FBEv2, vintf, props, codec seccomp; v1.0.1: flashlight init.rc lines, DeX build.prop line)
- `patches/BINARY_PATCHES.md`: binary verification and patching notes for A04

Kernel: Galaxy A04 kernel tree (`android_kernel_samsung_a04` / MT6765), with reference to the original One UI 8.5 port work and the UN1CA project.

Not affiliated with, endorsed by or sponsored by Samsung, Google or Anthropic. All trademarks belong to their owners.
