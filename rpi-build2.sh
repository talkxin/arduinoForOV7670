TOOLCHAIN=arm-linux-gnueabihf
COMMIT=rpi-4.9.y
if [ -f build-kernel-qemu.conf ] ; then
	. build-kernel-qemu.conf
fi

if [ "$INSTALL_PACKAGES" ] ; then
	sudo apt-get update
	sudo apt-get install git libncurses5-dev gcc-arm-linux-gnueabihf
fi

if [ -f linux-${COMMIT}.zip ] ; then
  wget -c https://github.com/raspberrypi/linux/archive/${COMMIT}.zip -O linux-${COMMIT}.zip
fi

rm -rf linux-${COMMIT}
unzip linux-${COMMIT}.zip
cd linux-${COMMIT}

make ARCH=arm versatile_defconfig
rm .config
cp arch/arm/configs/bcm2835_defconfig ./.config
wget https://github.com/dhruvvyas90/qemu-rpi-kernel/blob/master/tools/config_ip_tables
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
CONFIG_MMC_BCM2835=y
CONFIG_MMC_BCM2835_DMA=y
CONFIG_DMADEVICES=y
CONFIG_DMA_BCM2708=y
CONFIG_FHANDLE=y
CONFIG_OVERLAY_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_FS_POSIX_ACL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
EOF
cat ./config_ip_tables >> .config
make -j 4 -k ARCH=arm CROSS_COMPILE=${TOOLCHAIN}- menuconfig
make -j 4 -k ARCH=arm CROSS_COMPILE=${TOOLCHAIN}-
