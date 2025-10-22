#!/sbin/sh

export ANDRDOID_BUILD_TOOLS_PATH=~/android-build-tools

mkdir -p $ANDRDOID_BUILD_TOOLS_PATH


if [ ! -f "$ANDRDOID_BUILD_TOOLS_PATH/.complete" ]; then
	#Get all the android tools
	echo "Downloading android tools..."

	git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b pie-gsi $ANDRDOID_BUILD_TOOLS_PATH/aarch64-linux-android-4.9 --depth 1 --recursive
	git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b pie-gsi $ANDRDOID_BUILD_TOOLS_PATH/arm-linux-androideabi-4.9 --depth 1 --recursive
	git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 -b android12L-gsi $ANDRDOID_BUILD_TOOLS_PATH/linux-x86 --depth 1 --recursive
	git clone https://android.googlesource.com/platform/external/avb -b android13-gsi $ANDRDOID_BUILD_TOOLS_PATH/avb --depth 1 --recursive
	git clone https://android.googlesource.com/platform/prebuilts/build-tools -b master-kernel-build-2022 $ANDRDOID_BUILD_TOOLS_PATH/build-tools --depth 1 --recursive
	git clone https://android.googlesource.com/kernel/prebuilts/build-tools -b master-kernel-build-2022 $ANDRDOID_BUILD_TOOLS_PATH/kernel-build-tools --depth 1 --recursive
	git clone https://github.com/LineageOS/android_system_tools_mkbootimg -b lineage-20.0 $ANDRDOID_BUILD_TOOLS_PATH/android_system_tools_mkbootimg --depth 1 --recursive

	echo "Tools download complete"
	touch $ANDRDOID_BUILD_TOOLS_PATH/.complete
else
	echo "Skipping tools download as it appears to be done"
fi

#Set up environment
export CLANG_PATH=$ANDRDOID_BUILD_TOOLS_PATH/linux-x86/clang-r416183b/bin/
export BUILD_TOOLS_BIN=$ANDRDOID_BUILD_TOOLS_PATH/build-tools/linux-x86/bin
export BUILD_TOOLS_PATH=$ANDRDOID_BUILD_TOOLS_PATH/build-tools/path/linux-x86
export KERNEL_BUILD_TOOLS_BIN=$ANDRDOID_BUILD_TOOLS_PATH/kernel-build-tools/linux-x86/bin
export GCC_PATH=$ANDRDOID_BUILD_TOOLS_PATH/aarch64-linux-android-4.9/bin
export GCC_ARM32_PATH=$ANDRDOID_BUILD_TOOLS_PATH/arm-linux-androideabi-4.9/bin
export AVB_PATH=$ANDRDOID_BUILD_TOOLS_PATH/avb
export MKBOOTIMG_PATH=$ANDRDOID_BUILD_TOOLS_PATH/android_system_tools_mkbootimg
export PYTHON2_PATH=$ANDRDOID_BUILD_TOOLS_PATH/2.7.5/bin

export PATH=$CLANG_PATH:$BUILD_TOOLS_BIN:$KERNEL_BUILD_TOOLS_BIN:$GCC_PATH:$GCC_ARM32_PATH:$AVB_PATH:$MKBOOTIMG_PATH:$PYTHON2_PATH:$PATH

#Build the RPM
rpmbuild --build-in-place --bb rpm/kernel-adaptation-halium-algiz.spec --buildroot=$PWD/buildroot

