#!/bin/bash

#-----------#
## Drives to install to
## Update to /dev/disk/by-id
## Usig Default console keymap "US"
## ls /usr/share/kbd/keymaps/**/*.map.gz
## example: loadkeys de-latin1 :: loads keymap de-latin1
## console fonts found in /usr/share/kbd/consolefonts/
## setfont <font>
## verify boot mode 
#  ls /sys/firmware/efi/efivars
## Run dhcpcd to connect to network 
## assumed ethernet connection

## Network Section ##
## use seperate script network configuration ##
# check driver for card enabled
# lspci -k
# lsusb -v
# PCI(e) and USB respectively 
## check ip interfaces
# ip link show
# ip link set <interface> up
## check firmware loaded
# dmesg | grep firmware
# dhcpcd
## Main Drive






#echo "available drives"
#ls -l /dev/disk/by-id/
#
#echo "listing device by-id"
#ls -l /dev/disk/by-id/
#echo "select drive main_drive by-id"
#echo "example: /dev/disk/by-id/<identification>
#read DRIVE1
#echo "listing device by-id"
#ls   /dev/disk/by-id/
#echo "enter drive usb_drive by-id"
#echo "example: /dev/disk/by-id/<identification>"
#read DRIVE2

##      setup and configuration DRIVE1 DRIVE2
##  partition_usb $DRIVE2



partition_usb() {
        local dev="$1"; shift
        sgdisk --zap-all "$dev"
        sgdisk -p "$dev"
        sgdisk -g "$dev"
        sgdisk -n 1:2048:1050623 -t 1:ef00 -g -p "$dev"
        sgdisk -n 2:1050624:1460223 -g -t 2:8300 -p "$dev"
        sgdisk -c 1:"EFI" -c 2:"LINUX"
}

format_usb() {
	local dev="$1"; shift
	mkfs.fat -F32 "$dev"
}
cryptsetup_usb() {
        local dev="$1"; shift
	cryptsetup -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random --verify-passphrase luksFormat "$dev"
	cryptsetup open "$dev" encboot
	mkfs.ext4 /dev/mapper/encboot
}

set_usb002() {
	local dev="$1"; shift
	mount /dev/mapper/encboot /mnt
	dd if=/dev/urandom of=/mnt/key.img bs=4M count=1
	cryptsetup --align-payload=1 luksFormat /mnt/key.img
	cryptsetup open /mnt/key.img lukskey
}


ls -l /dev/disk/by-id/
partition_usb /dev/sdg
format_usb /dev/sdg1
cryptsetup_usb /dev/sdg2
set_usb002 /dev/sdg2


