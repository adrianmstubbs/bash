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
	mkfs.vfat -F 32 "$dev"
}
cryptsetup_usb() {
        local dev="$1"; shift
	cryptsetup -v --cipher aes-xts-plain64 --key-size=512 --hash=sha512 --iter-time=5000 --use-random --verify-passphrase luksFormat "$dev"
	cryptsetup open "$dev" encboot
	mkfs.ext4 /dev/mapper/encboot
}

set_usb002() {
	mount /dev/mapper/encboot /mnt
	dd if=/dev/urandom of=/mnt/key.img bs=256M count=1
	cryptsetup --align-payload=1 luksFormat /mnt/key.img
	cryptsetup open /mnt/key.img lukskey
}

set_main() {
        local dev="$1"; shift
        truncate -s 16M /mnt/header.img
        cryptsetup --key-file=/dev/mapper/lukskey --keyfile-offset=4 --keyfile-size=8192 luksFormat $dev enc --align-payload 4096 --header /mnt/header.img
        cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=4 --keyfile-size=8192 $dev enc
        cryptsetup close lukskey
	umount /mnt
        pvcreate /dev/mapper/enc
        vgcreate MVG /dev/mapper/enc
	lvcreate -L 8G MVG -n swap
        lvcreate -L 32G MVG -n root
        lvcreate -l 100%FREE MVG -n home
	mkfs.ext4 /dev/MVG/root
        mkfs.ext4 /dev/MVG/home
        mkswap /dev/MVG/swap
        mount /dev/MVG/root /mnt
        mkdir /mnt/home
        mount /dev/MVG/home /mnt/home
        swapon /dev/MVG/swap
}
set_mount() {
	mkdir /mnt/boot
	mkdir /mnt/efi
	mount /dev/mapper/encboot /mnt/boot
	mount /dev/sdb1 /mnt/efi
}

ls -l /dev/disk/by-id/
partition_usb /dev/sdc
format_usb /dev/sdc1
cryptsetup_usb /dev/sdc2
set_usb002
set_main /dev/sda
set_mount 

pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc
locale-gen
echo LANG=en_UTF-8 >> /etc/locale.conf
echo anotherlight >> /etc/hostname


## for customencrypthook porition
##+write file customencrypthook to usb 
##+p file to /etc/initcpio/install/
##+then cp /usr/lib/initpcio/install/encrypt
##+edit mkinitcpio.conf file using sed pattern matching
##+delete pattern 'full string 001' insert pattern 'full string 002'
## example format below
## sed -i s'/replace and substitute000/replace and substitute001/' sedexample.txt
##
## cp /usr/lib/initpcio/install/encrypt /etc/initcpio/install/customencrypthook

#################################################
# 8/14/2019
# pacstrap /mnt base base-devel all other packages
# configuration script after installation
# configuration initial firewall
# configuration home directory 
# custom archiso image for packages
# initial iptables / other config firewall rules firewall rules host
# vpn configuration out of box :: configure vpn alongside firewall out of box
# configuration fresh install all :: or github donwload
# learn all bash special characters 
# impossible to create vagrant archiso image
# watch firewall windows osx and limit ip addresses as neccesary
# kernel nftables
#
#
#
##################################################
#  Security Section
#  OSSEC :: OpenVAS :: AFICK :: Lynis :: AIDE :: Logcheck :: Duplicati
#+ spm :: julia :: python 2 3 :: pandas :: r :: gnuplot :: torch :: tensorflow
#+ remind :: vuurmuur ::
#+ 
#+ 




