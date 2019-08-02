#!/bin/bash
	set_usb002() {
		local dev="$1"; shift
		local bs=' ';
		echo 'enter block-size'
		read bs
		mount /dev/mapper/encboot /mnt
		echo 'encboot successfully mounted'
		dd if=/dev/urandom of=/mnt/key.img bs="$bs" count=1
		echo 'key.img successfully created'
		cryptsetup --align-payload=1 luksFormat /mnt/key.img
		cryptsetup open /mnt/key.img lukskey
	}
set_usb002 /dev/disk/by-id/usb-PNY_USB_2.0_FD_0701937F11695628-0:0-part2

	

