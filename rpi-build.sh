TOOLCHAIN=../tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf
rm -rf kernel-qemu
mkdir kernel-qemu
cd kernel-qemu
wget https://github.com/polaco1782/raspberry-qemu/blob/master/linux-arm.patch
git clone git://github.com/raspberrypi/linux.git --branch rpi-4.9.y --single-branch --depth 1
git clone git://github.com/raspberrypi/tools.git
cd linux
diff -ur ../linux-arm.patch ../linux-arm.patch > ../linux-arm.patch
patch -p1 < ../linux-arm.patch

 # yum -y install bc libstdc++-4.8.5-16.el7.i686 libstdc++.so.6 zlib.i686 ncurses-libs ncurses-devel
make ARCH=arm versatile_defconfig
cat >> .config << EOF
CONFIG_CROSS_COMPILE="$TOOLCHAIN"
CONFIG_CPU_V6=y
CONFIG_ARM_ERRATA_411920=y
CONFIG_ARM_ERRATA_364296=y
CONFIG_AEABI=y
CONFIG_OABI_COMPAT=y
CONFIG_PCI=y
CONFIG_SCSI=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_TMPFS=y
CONFIG_INPUT_EVDEV=y
CONFIG_EXT3_FS=y
CONFIG_EXT4_FS=y
CONFIG_VFAT_FS=y
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_VFP=y
CONFIG_CGROUPS=y
EOF

make -j 4 -k ARCH=arm CROSS_COMPILE=${TOOLCHAIN}- menuconfig
make -j 4 -k ARCH=arm CROSS_COMPILE=${TOOLCHAIN}-
cd ..
cp linux/arch/arm/boot/zImage kernel-qemu



# qemu-system-arm -kernel kernel-qemu -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" -hda 2017-11-29-raspbian-stretch.img
#
#
#
# qemu-system-arm -kernel kernel-qemu  -M versatilepb -cpu arm1176 -hda 2017-11-29-raspbian-stretch.img -m 256 -append "root=/dev/sda2"
#
#
# qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -hda 2017-11-29-raspbian-stretch.img
#
#
#
# qemu-system-arm -drive format=raw,file=2016-11-25-raspbian-jessie.img -kernel kernel-qemu  -M versatilepb -cpu arm1176 -m 256 -append "root=/dev/sda2"
#
#
# qemu-img resize -f raw 2016-11-25-raspbian-jessie.img +5G
# qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -drive "file=2016-11-25-raspbian-jessie.img,index=0,media=disk,format=raw" -redir tcp:2222::22
# qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -serial stdio -append "console=ttyAMA0 root=/dev/mmcblk0p1 rootfstype=ext3" -drive "file=2017-11-29-raspbian-stretch.img,index=0,media=disk,format=raw" -redir tcp:2222::22


# http://blog.csdn.net/xdw1985829/article/details/39077611
