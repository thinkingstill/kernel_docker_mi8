export PATH=$PATH:/home/test/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9/bin
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

make O=out mrproper
make O=out merge_defconfig
make O=out -j8 2>&1 | tee out/build.log
