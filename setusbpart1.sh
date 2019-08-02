#!/bin/bash
set_usbpart1() {
	local dev="$1"; shift
		mkfs.fat -F32 $dev-part1
		cryptsetup -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random --verify-passphrase luksFormat $dev-part2
		cryptsetup open $dev-part2 encboot

}
set_usbpart1 /dev/disk/by-id/usb-PNY_USB_2.0_FD_0701937F11695628-0:0

#print output to a file
#needed output from file 
#automation add to cryptsetup luksFormat 

#or simpler solution 
#dont allow for automation of processs 
# text editting only
