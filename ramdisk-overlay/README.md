# ramdisk-overlay

Files here are appended to the boot ramdisk by kernel-adaptation-simplified
(`find . | cpio -o -H newc | <compressor> >> boot-ramdisk.img`), so they
override the base ramdisk on extraction (last cpio member wins). This carries
the SailfishOS-as-second-OS (ABM / Volla Boot Manager) support for the
SD-less, file-backed algiz layout.

## Contents

- `scripts/halium` — the stock initrd halium script plus `abm_map_partitions()`,
  called from `mountroot()` after the local-premount hooks. When the kernel
  cmdline carries `systempart=/dev/mapper/sfos-system` (set by the ABM entry),
  it recreates the Android `/dev/block/by-name/*` symlinks the uncrypt block
  maps reference, maps the ABM config fs from `/metadata/abm_settings.map`,
  then maps `sfos_system.map`/`sfos_data.map` into `/dev/mapper/sfos-system`
  and `/dev/mapper/sfos-data` with `droidboot_map_to_dm` + `dmsetup`, and
  grows the shrunk rootfs with the initrd's own `resize2fs`. Guarded on the
  cmdline so the same ramdisk still boots standalone (flashed to `boot`).
  The delta from the stock script is tracked in
  `../ramdisk-patches/abm-multiboot-halium.patch` for review/upstream.

- `bin/droidboot_map_to_dm` — static aarch64 build of
  Android-Boot-Manager/droidboot_map_to_dm, vendored as the submodule
  `tools/droidboot_map_to_dm` (converts an uncrypt `.map` to a dm-linear
  table). Rebuild and refresh with:

      podman run --rm -v "$PWD/tools/droidboot_map_to_dm":/src -w /src ubuntu:noble \
        bash -lc 'apt-get update -qq && apt-get install -y -qq gcc make libc6-dev && \
                  gcc -Wall -static -o droidboot_map_to_dm main.c && strip droidboot_map_to_dm'
      cp tools/droidboot_map_to_dm/droidboot_map_to_dm ramdisk-overlay/bin/

  (Build host must target aarch64: run on an arm64 builder, or swap the native
  gcc for `aarch64-linux-gnu-gcc` with static libs.)

`resize2fs`/`e2fsck` are already present in the base ramdisk (`sbin/`), so no
extra binaries are needed for the grow step.
