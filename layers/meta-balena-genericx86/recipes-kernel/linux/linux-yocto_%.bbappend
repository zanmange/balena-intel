inherit kernel-resin

FILESEXTRAPATHS_prepend := "${THISDIR}/files:${THISDIR}/genericx86-64-ext:${THISDIR}/surface-go:"

SRC_URI += " \
    file://0001-Add-support-for-Quectel-EC20-modem.patch \
    file://0002-Revert-random-fix-crng_ready-test.patch \
"

# Rest of the machines that are on kernel 5.8.18
# already have these patches
SRC_URI_append_surface-pro-6 = " \
    file://0007-BUGFIX-iwlwifi-mvm-Allow-multicast-~ta-frames-only-when-associated.patch \
    file://0008-BUGFIX-iwlwifi-mvm-Allow-multicast-~ta-frames-only-when-authorized.patch \
    file://0001-ovl-fix-regression-caused-by-overlapping-layers-dete.patch \
    file://0003-ipts.patch \
"
# SP6 is still on a kernel older than 5.2 so no need for the overlay regression fix patch
SRC_URI_remove_surface-pro-6 = "file://0001-ovl-fix-regression-caused-by-overlapping-layers-dete.patch"

SRC_URI_append_genericx86-64-ext = " \
    file://defconfig \
"

do_kernel_configme[depends] += "virtual/${TARGET_PREFIX}binutils:do_populate_sysroot"
do_kernel_configme[depends] += "virtual/${TARGET_PREFIX}gcc:do_populate_sysroot"
do_kernel_configme[depends] += "bc-native:do_populate_sysroot bison-native:do_populate_sysroot"

COMPATIBLE_MACHINE_smartcube-kbox-a250 = "smartcube-kbox-a250"

RESIN_CONFIGS_append-surface-go = " sgo_camera"
RESIN_CONFIGS[sgo_camera] = " \
    CONFIG_MEMSTICK=m \
    CONFIG_MEMSTICK_REALTEK_PCI=m \
    CONFIG_PINCTRL_INTEL=y \
    CONFIG_V4L2_FWNODE=m \
    CONFIG_PINCTRL_SUNRISEPOINT=y \
    CONFIG_MEDIA_PCI_SUPPORT=y \
    CONFIG_VIDEO_IPU3_CIO2=m \
    CONFIG_CIO2_BRIDGE=y \
    CONFIG_VIDEOBUF2_DMA_SG=m \
    CONFIG_VIDEO_OV5693=m \
    CONFIG_STAGING_MEDIA=y \
    CONFIG_VIDEO_IPU3_IMGU=m \
    CONFIG_IOMMU_IOVA=m \
    CONFIG_ARCH_HAS_COPY_MC=y \
"

#
# EHCI drivers
#
RESIN_CONFIGS_append = " ehci"
RESIN_CONFIGS[ehci] = " \
    CONFIG_USB_EHCI_HCD_PLATFORM=y \
    "

#
# Support for NVME block devices
#
RESIN_CONFIGS_append = " nvme"
RESIN_CONFIGS[nvme] = " \
    CONFIG_BLK_DEV_NVME=y \
    "

#
# Support Intel wrieless LAN adapter
#
RESIN_CONFIGS_append = " iwlwifi"
RESIN_CONFIGS_DEPS[iwlwifi] = " \
    CONFIG_PCI=m \
    CONFIG_MAC80211=m \
    CONFIG_HAS_IOMEM=m \
    "
RESIN_CONFIGS[iwlwifi] = " \
    CONFIG_IWLMVM=m \
    CONFIG_IWLDVM=m \
    CONFIG_IWLWIFI=m \
    "

#
# Support Intel NUC Bluetooth
#
RESIN_CONFIGS_append = " nuc_bluetooth"
RESIN_CONFIGS[nuc_bluetooth] = " \
    CONFIG_BT_HCIUART=m \
    CONFIG_BT_HCIUART_INTEL=y \
    CONFIG_BT_HCIBTUSB=m \
    "

#
# Support for DLM module
#
RESIN_CONFIGS_append = " dlm"
RESIN_CONFIGS[dlm] = " \
    CONFIG_DLM=m \
    "

#
# Support for serial console and more than 4 serial ports
#
RESIN_CONFIGS_append = " serial_8250"
RESIN_CONFIGS[serial_8250] = " \
    CONFIG_SERIAL_8250_CONSOLE=y \
    CONFIG_SERIAL_8250_NR_UARTS=32 \
    CONFIG_SERIAL_8250_RUNTIME_UARTS=32 \
    "

#
# Support Intel(R) 82575/82576 PCI-Express Gigabit Ethernet
#
RESIN_CONFIGS_append = " igb"
RESIN_CONFIGS_DEPS[igb] = " \
    CONFIG_PCI=m \
    "
RESIN_CONFIGS[igb] = " \
    CONFIG_IGB=m \
    "

# Support for RTL8723BE and RTL8821AE based WiFi/BT cards
RESIN_CONFIGS_append = " rtl8723be_rtl8821ae"
RESIN_CONFIGS_DEPS[rtl8723be_rtl8821ae] = " \
        CONFIG_RTL_CARDS=m \
"
RESIN_CONFIGS[rtl8723be_rtl8821ae] = " \
    CONFIG_RTL8723BE=m \
    CONFIG_RTL8821AE=m \
"

# Enable Intel Low Power Subsystem Support
# (for detecting the eMMC on some Atom based Intel SoCs)
RESIN_CONFIGS_append = " lpss"
RESIN_CONFIGS[lpss] = " \
    CONFIG_X86_INTEL_LPSS=y \
"

# Enable vxlan support (requested by customer)
RESIN_CONFIGS_append = " vxlan"
RESIN_CONFIGS[vxlan] = " \
    CONFIG_VXLAN=m \
"

# enable audio over HDMI (requested by customer for the Intel Compute Stick)
RESIN_CONFIGS_append = " hdmi_lpe_audio"
RESIN_CONFIGS[hdmi_lpe_audio] = " \
    CONFIG_HDMI_LPE_AUDIO=m \
"

RESIN_CONFIGS_append = " quectel_ec20"
RESIN_CONFIGS_DEPS[quectel_ec20] = "\
    CONFIG_USB_SERIAL_OPTION=m \
    CONFIG_USB_SERIAL_WWAN=m \
"
RESIN_CONFIGS[quectel_ec20] ="\
    CONFIG_USB_SERIAL_QUALCOMM=m \
"

RESIN_CONFIGS_append = " batman"
RESIN_CONFIGS[batman] = "\
    CONFIG_BATMAN_ADV=m \
    CONFIG_BATMAN_ADV_DAT=y \
    CONFIG_BATMAN_ADV_MCAST=y \
    CONFIG_BATMAN_ADV_DEBUGFS=y \
    CONFIG_BATMAN_ADV_DEBUG=y \
"

# Enable USB audio support
RESIN_CONFIGS_append = " usb_audio"
RESIN_CONFIGS[usb_audio]=" \
    CONFIG_SND_USB_AUDIO=m \
"

# Enable WiFi adapters that use Realtek chipset (like Edimax EW-7811Un)
RESIN_CONFIGS_append = " rtl_wifi"
RESIN_CONFIGS[rtl_wifi]=" \
    CONFIG_RTL8192CU=m \
"

# Add overlayfs module in the rootfs (some user containers need this even though we do not yet switch from aufs to overlay2 as balena storage driver)
RESIN_CONFIGS_append = " overlayfs"
RESIN_CONFIGS[overlayfs] = " \
    CONFIG_OVERLAY_FS=m \
"

# keep overlay as built-in for the following machines as they are using overlay instead of aufs
RESIN_CONFIGS_remove_surface-pro-6 = "overlayfs"
RESIN_CONFIGS_remove_surface-go = "overlayfs"
RESIN_CONFIGS_remove_genericx86-64-ext = "overlayfs"

# Add CAN support (requested by customer)
RESIN_CONFIGS_append = " enable_can"
RESIN_CONFIGS[enable_can] = " \
    CONFIG_CAN=m \
    CONFIG_CAN_DEV=m \
    CONFIG_CAN_RAW=m \
    CONFIG_CAN_SLCAN=m \
"

RESIN_CONFIGS_append = " huawei_modems"
RESIN_CONFIGS_DEPS[huawei_modems] = " \
    CONFIG_USB_SERIAL_OPTION=m \
    CONFIG_USB_USBNET=m \
"
RESIN_CONFIGS[huawei_modems] ="\
    CONFIG_USB_NET_HUAWEI_CDC_NCM=m \
"

RESIN_CONFIGS_append = " rndis"
RESIN_CONFIGS_DEPS[rndis] = " \
    CONFIG_USB_SERIAL_OPTION=m \
    CONFIG_USB_USBNET=m \
"
RESIN_CONFIGS[rndis] ="\
    CONFIG_USB_NET_RNDIS_HOST=m \
"

# requested by customer
RESIN_CONFIGS_append = " netfilter_time"
RESIN_CONFIGS[netfilter_time] = " \
    CONFIG_NETFILTER_XT_MATCH_TIME=m \
"

# requested by customer (support for Kontron PLD devices)
RESIN_CONFIGS_append = " gpio_i2c_kempld"
RESIN_CONFIGS_DEPS[gpio_i2c_kempld] = " \
    CONFIG_GPIOLIB=y \
    CONFIG_I2C=y \
    CONFIG_HAS_IOMEM=y \
    CONFIG_MFD_KEMPLD=m \
"
RESIN_CONFIGS[gpio_i2c_kempld] = " \
    CONFIG_GPIO_KEMPLD=m \
    CONFIG_I2C_KEMPLD=m \
"

# requested by customer
RESIN_CONFIGS_append = " snd_dyn_minors"
RESIN_CONFIGS[snd_dyn_minors] = " \
    CONFIG_SND_DYNAMIC_MINORS=y \
"

# requested by customer
RESIN_CONFIGS_append = " tulip"
RESIN_CONFIGS[tulip] = " \
    CONFIG_NET_TULIP=y \
    CONFIG_TULIP=m \
"

# requested by customer
RESIN_CONFIGS_append = " hyperv_net"
RESIN_CONFIGS_DEPS[hyperv_net] = " \
    CONFIG_HYPERV=y \
    CONFIG_HYPERVISOR_GUEST=y \
"
RESIN_CONFIGS[hyperv_net] = " \
    CONFIG_HYPERV_NET=m \
"

# requested by user
RESIN_CONFIGS_append = " temp_sensors"
RESIN_CONFIGS[temp_sensors] = " \
    CONFIG_SENSORS_CORETEMP=m \
    CONFIG_SENSORS_NCT6775=m \
"

# requested by user
RESIN_CONFIGS_append = " acpi_wmi"
RESIN_CONFIGS[acpi_wmi] = " \
    CONFIG_ACPI_WMI=m \
"

RESIN_CONFIGS_append = " mwifiex_pcie"
RESIN_CONFIGS[mwifiex_pcie] = " \
    CONFIG_MWIFIEX=m \
    CONFIG_MWIFIEX_PCIE=m \
"

RESIN_CONFIGS_append = " uinput"
RESIN_CONFIGS_DEPS[uinput] = " \
    CONFIG_INPUT_MISC=y \
"
RESIN_CONFIGS[uinput] = " \
    CONFIG_INPUT_UINPUT=m \
"

RESIN_CONFIGS_append = " ath10k_pci"
RESIN_CONFIGS_DEPS[ath10k_pci] = " \
    CONFIG_ATH10K=m \
"
RESIN_CONFIGS[ath10k_pci] = " \
    CONFIG_ATH10K_PCI=m \
"

RESIN_CONFIGS_append = " mmc_realtek_pci"
RESIN_CONFIGS_DEPS[mmc_realtek_pci] = " \
    CONFIG_MISC_RTSX_PCI=m \
"
RESIN_CONFIGS[mmc_realtek_pci] = " \
    CONFIG_MMC_REALTEK_PCI=m \
"

# enable touchscreen driver for the Microsoft Surface Pro 6
RESIN_CONFIGS_append_surface-pro-6 = " ipts_touchscreen_sp6"
RESIN_CONFIGS[ipts_touchscreen_sp6] = " \
    CONFIG_INTEL_IPTS=m \
"

# the following are not compile deps but rather runtime deps
RESIN_CONFIGS_append_surface-pro-6 = " touchscreen_surfaces"
RESIN_CONFIGS_append_surface-go = " touchscreen_surfaces"
RESIN_CONFIGS_DEPS[touchscreen_surfaces] = " \
    CONFIG_INTEL_MEI=m \
    CONFIG_INTEL_MEI_ME=m \
    CONFIG_HID_MULTITOUCH=m \
"

RESIN_CONFIGS_append = " tpm"
RESIN_CONFIGS_DEPS[tpm] = " \
    CONFIG_HW_RANDOM_TPM=y \
    CONFIG_SECURITYFS=y \
"
RESIN_CONFIGS[tpm] = " \
    CONFIG_TCG_TPM=m \
    CONFIG_TCG_TIS_CORE=m \
    CONFIG_TCG_TIS=m \
    CONFIG_TCG_CRB=m \
"

# enable the Intel TCO Watchdog
RESIN_CONFIGS_append = " watchdog"
RESIN_CONFIGS[watchdog] = " \
    CONFIG_ITCO_WDT=m \
"

# requested by user
RESIN_CONFIGS_append_genericx86-64 = " ad5593r"
RESIN_CONFIGS[ad5593r] = " \
    CONFIG_AD5593R=m \
"
RESIN_CONFIGS_DEPS[ad5593r] = " \
    CONFIG_IIO=m \
"

# set ATA_PIIX as built-in so we can boot legacy IDE mode without adding the ata_piix driver in the initramfs
# (some boards do not support AHCI mode)
RESIN_CONFIGS_append_genericx86-64 = " ata_piix"
RESIN_CONFIGS[ata_piix] = " \
    CONFIG_ATA_PIIX=y \
"

# requested by customer
RESIN_CONFIGS_append_genericx86-64 = " pinctrl_baytrail"
RESIN_CONFIGS[pinctrl_baytrail] = " \
    CONFIG_PINCTRL_BAYTRAIL=y \
"

# requested by user (this module was previously available but apparently got removed when we updated to warrior and a new kernel)
RESIN_CONFIGS_append_genericx86-64 = " ch341"
RESIN_CONFIGS[ch341] = " \
    CONFIG_USB_SERIAL_CH341=m \
"

RESIN_CONFIGS_append_genericx86-64 = " i2c_designware"
RESIN_CONFIGS[i2c_designware] = " \
    CONFIG_I2C_DESIGNWARE_PLATFORM=m \
    CONFIG_I2C_DESIGNWARE_PCI=m \
"

# requested by user for mounting HFS drives
RESIN_CONFIGS_append_genericx86-64 = " apple_hfs"
RESIN_CONFIGS[apple_hfs] = " \
    CONFIG_HFS_FS=m \
    CONFIG_HFSPLUS_FS=m \
"

# enable Intel Low Power Subsystem support in PCI mode in order to have the Designware I2C chip functioning on the Microsoft Surface Go
RESIN_CONFIGS_append_surface-go = " mfd_lpss_pci"
RESIN_CONFIGS[mfd_lpss_pci] = " \
    CONFIG_MFD_INTEL_LPSS_PCI=m \
"

# required to get the i2c touchscreen working on the Microsoft Surface Go
RESIN_CONFIGS_append_surface-go = " i2c_hid"
RESIN_CONFIGS[i2c_hid] = " \
    CONFIG_I2C_HID=m \
"

# requested by customer
RESIN_CONFIGS_append_genericx86-64 = " ixgbe"
RESIN_CONFIGS[ixgbe] = " \
    CONFIG_IXGBE=m \
"

# requested by customer
RESIN_CONFIGS_append_genericx86-64 = " xillybus"
RESIN_CONFIGS[xillybus] = " \
    CONFIG_XILLYBUS=m \
    CONFIG_XILLYBUS_PCIE=m \
"

# requested by customer
RESIN_CONFIGS_append_genericx86-64 = " i40e"
RESIN_CONFIGS[i40e] = " \
    CONFIG_I40E=m \
"

#
# Do not include debugging info in kernel and modules
#
RESIN_CONFIGS_append_genericx86-64-ext = " no-debug-info"
RESIN_CONFIGS[no-debug-info] ?= " \
    CONFIG_DEBUG_INFO=n \
    "

SRC_URI_append_surface-go = " \
    file://0001-ARM-LPAE-Invalidate-the-TLB-for-module-addresses-dur.patch \
    file://0002-arm-ARM-EABI-socketcall.patch \
    file://0003-vexpress-Pass-LOADADDR-to-Makefile.patch \
    file://0004-arm-Makefile-Fix-systemtap.patch \
    file://0005-malta-uhci-quirks-make-allowance-for-slow-4k-e-c.patch \
    file://0006-4kc-cache-tlb-hazard-tlbp-cache-coherency.patch \
    file://0007-mips-Kconfig-add-QEMUMIPS64-option.patch \
    file://0008-mips-vdso-fix-jalr-t9-crash-in-vdso-code.patch \
    file://0009-powerpc-Add-unwind-information-for-SPE-registers-of-.patch \
    file://0010-powerpc-kexec-fix-for-powerpc64.patch \
    file://0011-powerpc-add-crtsavres.o-to-archprepare-for-kbuild.patch \
    file://0012-powerpc-Disable-attribute-alias-warnings-from-gcc8.patch \
    file://0013-powerpc-ptrace-Disable-array-bounds-warning-with-gcc.patch \
    file://0014-crtsavres-fixups-for-5.4.patch \
    file://0015-Revert-platform-x86-wmi-Destroy-on-cleanup-rather-th.patch \
    file://0016-arm-serialize-build-targets.patch \
    file://0017-powerpc-serialize-image-targets.patch \
    file://0018-kbuild-exclude-meta-directory-from-distclean-process.patch \
    file://0019-modpost-mask-trivial-warnings.patch \
    file://0020-menuconfig-mconf-cfg-Allow-specification-of-ncurses-.patch \
    file://0021-mount_root-clarify-error-messages-for-when-no-rootfs.patch \
    file://0022-check-console-device-file-on-fs-when-booting.patch \
    file://0023-nfs-Allow-default-io-size-to-be-configured.patch \
    file://0024-Resolve-jiffies-wrapping-about-arp.patch \
    file://0025-vmware-include-jiffies.h.patch \
    file://0026-compiler.h-Undef-before-redefining-__attribute_const.patch \
    file://0027-uvesafb-print-error-message-when-task-timeout-occurs.patch \
    file://0028-uvesafb-provide-option-to-specify-timeout-for-task-c.patch \
    file://0029-linux-yocto-Handle-bin-awk-issues.patch \
    file://0030-arm64-perf-fix-backtrace-for-AAPCS-with-FP-enabled.patch \
    file://0031-initramfs-allow-an-optional-wrapper-script-around-in.patch \
    file://0032-yaffs2-import-git-revision-b4ce1bb-jan-2020.patch \
    file://0033-yaffs2-adjust-to-proper-location-of-MS_RDONLY.patch \
    file://0034-fs-yaffs2-replace-CURRENT_TIME-by-other-appropriate-.patch \
    file://0035-Yaffs-check-oob-size-before-auto-selecting-Yaffs1.patch \
    file://0036-yaffs-Avoid-setting-any-ACL-releated-xattr.patch \
    file://0037-yaffs2-fix-memory-leak-in-mount-umount.patch \
    file://0038-yaffs-Fix-build-failure-by-handling-inode-i_version-.patch \
    file://0039-yaffs-repair-yaffs_get_mtd_device.patch \
    file://0040-yaffs-add-strict-check-when-call-yaffs_internal_read.patch \
    file://0041-yaffs2-fix-memory-leak-when-proc-yaffs-is-read.patch \
    file://0042-yaffs2-v5.6-build-fixups.patch \
    file://0043-yaffs-fix-misplaced-variable-declaration.patch \
    file://0044-aufs5-aufs5-kbuild.patch \
    file://0045-aufs5-aufs5-base.patch \
    file://0046-aufs5-aufs5-mmap.patch \
    file://0047-aufs5-aufs5-standalone.patch \
    file://0048-aufs5-core.patch \
    file://0049-FAT-Add-CONFIG_VFAT_FS_NO_DUALNAMES-option.patch \
    file://0050-FAT-Add-CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES-option.patch \
    file://0051-FAT-Added-FAT_NO_83NAME.patch \
    file://0052-fat-don-t-use-obsolete-random32-call-in-namei_vfat.patch \
    file://0053-perf-force-include-of-stdbool.h.patch \
    file://0054-perf-add-libperl-not-found-warning.patch \
    file://0055-perf-change-root-to-prefix-for-python-install.patch \
    file://0056-perf-add-sgidefs.h-to-for-mips-builds.patch \
    file://0057-perf-add-SLANG_INC-for-slang.h.patch \
    file://0058-perf-fix-bench-numa-compilation.patch \
    file://0059-perf-mips64-Convert-__u64-to-unsigned-long-long.patch \
    file://0060-perf-x86-32-explicitly-include-errno.h.patch \
    file://0061-perf-perf-can-not-parser-the-backtrace-of-app-in-the.patch \
    file://0062-defconfigs-drop-obselete-options.patch \
    file://0063-arm64-perf-Fix-wrong-cast-that-may-cause-wrong-trunc.patch \
    file://0064-perf-Alias-SYS_futex-with-SYS_futex_time64-on-32-bit.patch \
    file://0065-ext4-fix-Wstringop-truncation-warnings.patch \
    file://0066-tipc-fix-Wstringop-truncation-warnings.patch \
    file://0067-media-device-property-Add-a-function-to-test-is-a-fw.patch \
    file://0068-media-v4l2-async-Pass-notifier-pointer-to-match-func.patch \
    file://0069-property-Add-support-to-fwnode_graph_get_endpoint_by.patch \
    file://0070-property-Return-true-in-fwnode_device_is_available-f.patch \
    file://0071-software_node-Fix-failure-to-put-and-get-references-.patch \
    file://0072-software_node-Enforce-parent-before-child-ordering-o.patch \
    file://0073-software_node-Alter-software_node_unregister_nodes-t.patch \
    file://0074-software_node-amend-software_node_unregister_node_gr.patch \
    file://0075-software_node-Add-support-for-fwnode_graph-family-of.patch \
    file://0076-lib-test_printf.c-Use-helper-function-to-unwind-arra.patch \
    file://0077-ipu3-cio2-Add-T-entry-to-MAINTAINERS.patch \
    file://0078-ipu3-cio2-Rename-ipu3-cio2.c-to-allow-module-to-be-b.patch \
    file://0079-media-v4l2-core-v4l2-async-Check-possible-match-in-m.patch \
    file://0080-acpi-Add-acpi_dev_get_next_match_dev-and-macro-to-it.patch \
    file://0081-ipu3-cio2-Add-functionality-allowing-software_node-c.patch \
    file://0082-ov5693-camera-sensor-driver.patch \
"
