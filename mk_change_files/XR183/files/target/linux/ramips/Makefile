#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=mipsel
BOARD:=ramips
BOARDNAME:=MediaTek MIPS SoC
SUBTARGETS:=rt305x mt7620 mt7621 mt7628 mt7688 rt3883 rt288x
FEATURES:=squashfs gpio
MAINTAINER:=John Crispin <john@phrozen.org>

KERNEL_PATCHVER:=4.4

define mtk-wifi-prepare
        python $(TOPDIR)/scripts/mtkwifi.py --linuxdir=$(LINUX_DIR) --topdir=$(TOPDIR) clean prepare
endef

define Target/Description
	Build firmware images for Ralink RT288x/RT3xxx based boards.
endef

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES += \
	kmod-leds-gpio kmod-gpio-button-hotplug swconfig oem \
	kmod-eeprom-api-ralink ralink-wifi-base kmod-ledtrig-gpio \
	kmod-ledtrig-netdev kmod-ledtrig-default-on kmod-ledtrig-gpio kmod-ledtrig-timer \
	rpcd rpcd-mod-rpcsys rpcd-mod-iwinfo rpcd-mod-file

$(eval $(call BuildTarget))
