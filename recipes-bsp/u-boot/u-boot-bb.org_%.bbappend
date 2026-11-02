# Copyright (c) 2026 Nagesh Sonwane <nagesh.sonwane@hotmail.com>
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:beaglebone-custom = " file://bootdelay.cfg"
UBOOT_EXTLINUX_ROOT:beaglebone-custom = "root=/dev/mmcblk0p2"
