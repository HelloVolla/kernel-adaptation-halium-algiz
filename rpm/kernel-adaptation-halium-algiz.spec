# Device details
%define device halium-algiz

# Kernel target architecture
%define kernel_arch arm64

%define kcflags "KCFLAGS="

#Compiler to use
%define makeopts LLVM=1 LLVM_IAS=1 V=1
%define clangtriple aarch64-linux-gnu-
%define crosscompile aarch64-linux-gnu-
%define crosscompile32 arm-linux-androideabi-
%define hostldflags "-fuse-ld=lld --rtlib=compiler-rt"

#Compiler to use
##define compiler CC=clang
##define compileropts CLANG_TRIPLE=aarch64-linux-gnu-
%define compiler %{nil}
%define compileropts %{nil}

# Crossbuild toolchain to use
#define crossbuild aarch64

# RPM target architecture, remove to leave it unaffected
# You should have a good reason to change the target architecture
# (like building on aarch64 targeting an armv7hl repository)
%define device_target_cpu aarch64

# Defconfig to pick-up
%define extra_config sfos-algiz_defconfig
%define defconfig %{extra_config} halium.config

# Linux kernel source directory
%define source_directory linux/

# Build modules
%define build_modules 1

# Build Image
%define build_Image 1

# Apply Patches
%define apply_patches 1

%define ramdisk ramdisk-algiz.img
##define build_dtboimg 1

# Build and pick-up the following devicetrees
##define devicetrees

#Device Info

%define deviceinfo_dtb mediatek/mt6877.dtb
%define deviceinfo_flash_pagesize 2048
%define deviceinfo_flash_offset_base 0x00000000
%define deviceinfo_flash_offset_kernel 0x40080000
%define deviceinfo_flash_offset_ramdisk 0x51100000
%define deviceinfo_flash_offset_second 0x00000000
%define deviceinfo_flash_offset_tags 0x47c80000
%define deviceinfo_flash_offset_dtb 0x47c80000
%define deviceinfo_kernel_cmdline bootopt=64S3,32N2,64N2 systempart=/dev/mapper/system
%define deviceinfo_bootimg_os_version 13
%define deviceinfo_bootimg_os_patch_level 2024-07
%define deviceinfo_bootimg_header_version 2
%define deviceinfo_bootimg_partition_size 41943040
%define deviceinfo_rootfs_image_sector_size 4096
%define deviceinfo_bootimg_qcdt false
%define deviceinfo_bootimg_append_vbmeta false

Version:        4.19.191
Release:        1

%include kernel-adaptation-simplified/kernel-adaptation-simplified.inc
