#!/bin/bash

#-----------#

# list available console layout
 ls /usr/share/kbd/keymaps/**/*.map.gz
# loadkeys input
# read input
  echo -n "loadkeys: ' '"
  read keyboard
  echo -n
  loadkeys ${keyboard}

echo -n "Hostname: "
read hostname
: "${hostname:?"Missing hostname"}"

# verify uefi mode list efivars directory
 ls /sys/firmware/efi/efivars
# connection internet :: assumed ethernet
 ip link
# configure network connection :: enabled on boot for wired
 dhcpcd
# verify connection
 ping archlinux.org
# update system clock
 timedatectl set-ntp true
# check service status
 timedatectl status
echo -n "Password Root: "
read -s password000
echo
echo -n "Repeat Password: "
read -s password001
echo
[[ "$password000" == "$password001" ]] || ( echo "Passwords did not match"; exit 1; )
hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0 || exit 1
: ${hostname:?"nein"})
password=$(dialog --stdout --passwordbox "Enter hostname" 0 0 || exit 1
: ${password:?"nein"})


#################################################################################################
# POSSIBLE ADDENDUMS
# incorporation devicelist into rest tentative #
  echo -n "Select Main"
  device_list=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
  device=$(dialog --stdout --menu "select installation disk" 0 0 0 ${devicelist}) || exit 1
  echo -n
  echo -n "Select Usb"
  device_list_usb=$(lsblk -dplnx size -o name, size | grep -Ev "boot|rpmb|loop" | tac)
  device_usb=$(dialog --stdout --menu "Select Usb Drive" 0 0 0 ${device_list_usb}) || exit 1
 echo -n
  echo -n "Select Name Logical Volume Boot Partition"
  logical_boot_name=$(dialog --stdout --inputbox "boot device name" 0 0 || exit 1
  : ${logical_boot_name:?"boot_device cannot be empty"})

# something akin to ${deviceby-id} = lsblk -o name,model,serial | awk something something

partition_usb() {
        local dev="$1"; shift
        sgdisk --zap-all ${dev}
        sgdisk -p ${dev}
        sgdisk -g ${dev}
        sgdisk -n 1:2048:1050623 -t 1:ef00 -g -p ${dev}
        sgdisk -n 2:1050624:1460223 -g -t 2:8300 -p ${dev}
        sgdisk -c 1:"EFI" -c 2:"LINUX"
}

format_usb() {
        local dev="$1"; shift
        mkfs.vfat -F 32 $"dev"
}
cryptsetup_usb() {
        local dev="$1"; shift
        echo -n "--key-size"
        echo -n
        read key_size
        key_size=$(dialog --stdout --inputbox "--key-size" 0 0 || exit 1
        : ${key_size:?"key_size cannot be empty"})
        echo -n
        echo -n "--hash"
        echo -n
        hash_type=$(dialog --stdout --inputbox "--hash" 0 0 || exit 1
        : ${hash_type:?"hash_type cannot be empty"})
        echo -n
        echo -n "iter-time"
        echo -n
        iter_time=$(dialog --stdout --inputbox "--iter_time" 0 0 || exit 1
        : ${iter_time:?"iter_time cannot be empty"})
        echo -n
        echo -n "/dev/mapper/<logical_boot_name>"
        echo -n
        logical_boot_name=$(dialog --stdout --inputbox "boot device name" 0 0 || exit 1
        : ${logical_boot_name:?"logical volume name cannot be empty"})
        cryptsetup -v --cipher aes-xts-plain64 --key-size=${key_size} --hash=${hash_type} --iter-time=${iter_time} --use-random --verify-passphrase luksFormat "$dev"
        cryptsetup open "$dev" ${logical_boot_name}
        mkfs.ext4 /dev/mapper/${logical_boot_name}
}

set_usb002() {
        local dev="$1": shift
        mount /dev/mapper/"$dev" /mnt
        echo -n
        echo -n "block-size"
        bs=$(dialog --stdout --inputbox "boot device name" 0 0 || exit 1
        : ${bs:?"block size cannot be empty format i.e. 777M"})
        count=$(dialog --stdout --inputbox "count name" 0 0) || exit 1
        : ${count:?"count cannot be empty"}
        payload_align=$(dialog --stdout --inputbox "payload alignment" 0 0 || exit 1
        : ${payload_align:?"payload alignment cannot be empty"})
        dd if=/dev/urandom of=/mnt/key.img bs=${bs} count=${count}
        cryptsetup --align-payload=${payload_align} luksFormat /mnt/key.img
        cryptsetup open /mnt/key.img lukskey
}

set_main() {
        local dev="$1"; shift
        echo -n "setting main"
        echo -n "allocate truncate_size /mnt/header.img"
        read truncate_size
        truncate -s ${truncate_size} /mnt/header.img
        echo -n "setting lukskey"
        echo -n
        echo -n "--keyfile-offset= :"
        read key_file_offset
        echo -n
        echo -n "--keyfile-size= :"
        read key_file_size
        echo -n
        echo -n "name /dev/mapper/<device>"
        read device_name
        echo -n
        echo -n "align payload set to 4096 for lukskey"
        echo -n "mono no aware"
        cryptsetup --key-file=/dev/mapper/lukskey --keyfile-offset=${key_file_offset} --keyfile-size=${key_file_size} luksFormat $dev ${device_name} --align-payload 4096 --header /mnt/header.img
        cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=${key_file_offset} --keyfile-size=${key_file_size} $dev ${device_name}
        cryptsetup close lukskey
        umount /mnt
        echo -n
        echo -n "creating logical volumes"
        echo -n
        pvcreate /dev/mapper/${device_name}
        vgcreate MVG /dev/mapper/${device_name}
        echo -n "size_swap: "
        echo -n "#M or #G or #T"
        echo -n "i.e. 8M 8G 8T"
        read size_swap
        lvcreate -L ${size_swap} MVG -n swap
        echo -n "enter size root: "
        echo -n "80M or 80G or 80T"
        read size_root
        lvcreate -L ${size_root} MVG -n root
        echo -n "ich liebe dich"
        echo -n
        echo -n "ich liebe dich auch"
       lvcreate -l 100%FREE MVG -n home
        mkfs.ext4 /dev/MVG/root
        mkfs.ext4 /dev/MVG/home
        mkswap /dev/MVG/swap
        echo -n "nani mo - nothing"
        echo -n
        echo -n "nani mo mienai - i see whatever"
        mount /dev/MVG/root /mnt
        mkdir /mnt/home
        mount /dev/MVG/home /mnt/home
        swapon /dev/MVG/swap
}
set_mount() {
        mkdir /mnt/boot
        echo -n "god is in his heaven"
        mkdir /mnt/efi
        echo -n "all is right with the world"
        mount /dev/mapper/${logical_boot_name} /mnt/boot
        echo -n "wouldnt you agree?"
        mount /dev/sdb1 /mnt/efi
}


partition_usb ${device_usb}
format_usb ${device_usb}1
cryptsetup_usb ${device_usb}2
set_usb002 ${logical_boot_name}
set_main ${device}
set_mount

pacstrap /mnt base base-devel grub
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /mnt/usr/share/zoneinfo/Asia/Tokyo /mnt/etc/localtime
echo LANG=en_UTF-8 >> /mnt/etc/locale.conf
echo light >> /mnt/etc/hostname
echo -n
echo -n "customencrypthook echo"
echo -n
touch /mnt/etc/initcpio/hooks/customencrypthook
echo "#!/usr/bin/ash
run_hook() {
        modprobe -a -q dm-crypt >/dev/null 2>&1
        modprobe loop
        [ "${quiet}" = "y" ] && CSQUIET=">/dev/null"
        while [ ! -L '/dev/disk/by-id/usb-part2' ];
        do
         echo 'WAITING FOR USB'
         sleep 1
        done

        cryptsetup open /dev/disk/by-id/usb-part2 ${logical_boot_name}
        mkdir -p /mnt
        mount /dev/mapper/encboot /mnt
        cryptsetup open /mnt/key.img lukskey
        cryptsetup --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=4 --keyfile-size=8192 open /dev/disk/by-id/main ${device}
        cryptsetup close lukskey
        umount /mnt
}" >> /mnt/etc/initcpio/hooks/customencrypthook
echo -n "input usb-part-two by-id value"
echo -n "/dev/disk/by-id"
echo -n "i.e /dev/disk/by-id/usb-part2"
ls -l /dev/disk/by-id
read usb_part_two
sed 's/usb-part2/${usb_part_two}/g' /mnt/initcpio/hooks/customencrypthook
echo -n
echo -n "input main by-id value"
echo -n "/dev/disk/by-id"
echo -n "i.e /dev/disk/by-id/main"
read main
sed 's/main/${main}/g' /mnt/initcpio/hooks/customencrypthook
## copy paste source destination encrypt and customencrypthook
cp /mnt/usr/lib/initcpio/install/encrypt /mnt/etc/initcpio/install/customencrypthook
## edit mkinitcpio.conf with replacement text
sed 's/MODULES=()/MODULES=(loop)/g' /mnt/etc/mkinitcpio.conf
sed 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck/HOOKS=(base udev autodetect modconf block customencrypthook lvm2 filesystems keyboard fsck)/g' /mnt/etc/mkinitcpio.conf
mkinitcpio -p linux
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
## edit /etc/default/grub
sed 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
passwd=${password}
##  example format sed below
##  sed -i s'/replace and substitute000/replace and substitute001/' sedexample.txt
##
## cp /usr/lib/initpcio/install/encrypt /etc/initcpio/install/customencrypthook

#################################################
# 8/14/2019
# configuration initial firewall
# configuration home directory
# custom archiso image for packages
# kernel nftables
# 
# my works shall come to nothing 
# my efforts are in vain 
# yet i choose to endure 
# porque 
# ces't la vie
# warum
# ich habe keine idee
# aber die sterne halten nicht
# mein deutsch ist sehr schwerig
# i need sleep
# 
# 
#################################################
