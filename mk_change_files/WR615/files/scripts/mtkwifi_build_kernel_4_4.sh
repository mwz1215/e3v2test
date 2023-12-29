#!/bin/bash
#[ $# -lt 1 ] || exit 1
wifi_build_dir=$1
echo "mtk wifi build dir is $wifi_build_dir"

pushd $wifi_build_dir
#Makefile modify for drivers/net/wireless/mediatek/Makefile
if grep -q CONFIG_MT_AP_SUPPORT Makefile; then
    echo "Wifi-Prebuild: Makefile already modified. Skip."
else
#    echo "obj-y += wifi_utility/" >> Makefile
	echo -e "\
obj-\$(CONFIG_WIFI_MT7663E) += mt7663/mt_wifi_ap/\n\
obj-\$(CONFIG_WIFI_MT7603E) += mt7603/mt7603_wifi_ap/\n\
" >> Makefile
#	echo "obj-\$(ONFIG_WIFI_MT7663E) += mt7663/mt_wifi_ap/" >> Makefile
#	echo "obj-\$(CONFIG_WIFI_MT7603E) += mt7603/mt7603_wifi_ap/" >> Makefile
#    echo "obj-\$(CONFIG_MT_AP_SUPPORT) += mt_wifi_ap/" >> Makefile
#    echo "obj-\$(CONFIG_MT_STA_SUPPORT) += mt_wifi_sta/" >> Makefile
fi
#Kconfig modify for drivers/net/wireless/mediatek/Kconfig
if grep -q WIFI_DRIVER Kconfig; then
    echo "Wifi-Prebuild: Kconfig already modified. Skip."
else
sed -i 's/endif # WL_MEDIATEK/\
menuconfig WIFI_DRIVER\
	bool "WiFi Driver Support"\
\
if WIFI_DRIVER\
\
choice\
	prompt "Choose First WiFi Interface"\
	default FIRST_IF_NONE\
	config FIRST_IF_NONE\
	bool "None"\
\
	config FIRST_IF_MT7615E\
	bool "MT7615E"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select CHIP_MT7615E\
\
	config FIRST_IF_MT7603E\
	bool "MT7603E"\
	select MT_MAC\
	select RALINK_MT7603E\
	select WIFI_MT7603E\
	select MT7603E_RALINK_MT7603E\
	select MT7603E_MT_MAC\
\
	config FIRST_IF_MT7663E\
	bool "MT7663E"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select CHIP_MT7663E\
	select WIFI_MT7663E\
	select MT7663E_CHIP_MT7663E\
	select MT7663E_MT_MAC\
	select MT7663E_WIFI_MT_MAC\
\
	config FIRST_IF_MT7622\
	bool "MT7622"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select CHIP_MT7622\
\
	config FIRST_IF_MT7626\
	bool "MT7626"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select CHIP_MT7626\
\
	config FIRST_IF_MT7915\
	bool "MT7915"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select CHIP_MT7915\
\
	config FIRST_IF_MT7986\
	bool "MT7986"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select CHIP_MT7986\
\
endchoice\
\
choice\
	prompt "Choose Second WiFi Interface"\
	default SECOND_IF_NONE\
\
	config SECOND_IF_NONE\
	bool "None"\
\
	config SECOND_IF_MT7615E\
	bool "MT7615E"\
	select WIFI_MT_MAC\
	select CHIP_MT7615E\
	select MULTI_INF_SUPPORT\
\
	config SECOND_IF_MT7986\
	bool "MT7986"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select CHIP_MT7986\
\
	config SECOND_IF_MT7603E\
	bool "MT7603E"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select MULTI_INF_SUPPORT\
	select RALINK_MT7603E\
	select WIFI_MT7603E\
	select MT7603E_RALINK_MT7603E\
	select MT7603E_MT_MAC\
\
	config SECOND_IF_MT7663E\
	bool "MT7663E"\
	select WIFI_MT_MAC\
	select MT_MAC\
	select MULTI_INF_SUPPORT\
	select WIFI_MT7663E\
	select MT7663E_CHIP_MT7663E\
	select MT7663E_MT_MAC\
	select MT7663E_WIFI_MT_MAC\
\
endchoice\
\
choice\
	prompt "Choose Third WiFi Interface"\
	default THIRD_IF_NONE\
\
	config THIRD_IF_NONE\
	bool "None"\
\
	config THIRD_IF_MT7615E\
	bool "MT7615E"\
	select WIFI_MT_MAC\
	select CHIP_MT7615E\
	select MULTI_INF_SUPPORT\
\
endchoice\
\
config  RT_FIRST_CARD\
        int\
        depends on ! FIRST_IF_NONE\
		default 7615 if FIRST_IF_MT7615E\
        default 7622 if FIRST_IF_MT7622\
        default 7622 if FIRST_IF_MT7626\
        default 7915 if FIRST_IF_MT7915\
		default 7986 if FIRST_IF_MT7986\
		default 7603 if FIRST_IF_MT7603E\
		default 7663 if FIRST_IF_MT7663E\
\
config  RT_SECOND_CARD\
        int\
        depends on ! SECOND_IF_NONE\
        default 7615 if SECOND_IF_MT7615E\
		default 7915 if SECOND_IF_MT7915\
		default 7603 if SECOND_IF_MT7603E\
		default 7663 if SECOND_IF_MT7663E\
\
config  RT_THIRD_CARD\
        int\
        depends on ! THIRD_IF_NONE\
        default 7615 if THIRD_IF_MT7615E\
\
config  RT_FIRST_IF_RF_OFFSET\
        hex\
        depends on ! FIRST_IF_NONE\
        default 0xc0000\
\
config  RT_SECOND_IF_RF_OFFSET\
        hex\
        depends on ! SECOND_IF_NONE\
        default 0xc8000\
\
config  RT_THIRD_IF_RF_OFFSET\
        hex\
        depends on ! THIRD_IF_NONE\
        default 0xd0000\
\
menuconfig WIFI_MT7603E\
    bool "MT7603E WiFi"\
    default n\
if WIFI_MT7603E\
    source "drivers\/net\/wireless\/mediatek\/mt7603\/mt7603_wifi\/Kconfig"\
endif\
\
menuconfig WIFI_MT7663E\
    bool "MT7663E WiFi"\
    default n\
if WIFI_MT7663E\
    source "drivers\/net\/wireless\/mediatek\/mt7663\/mt_wifi\/embedded\/Kconfig"\
endif\
\
endif # WIFI_DRIVER\
endif # WL_MEDIATEK\
\
/g' Kconfig
fi

popd
exit 0
