set_main() {
	local dev="$1"; shift 
	echo 'enter key-file offset'
	local offset=' '
	read offset
	echo 'enter key-file size'
	read size
	truncate -s 16M /mnt/header.img
	cryptsetup --key-file=/dev/mapper/lukskey --keyfile-offset="$offset" keyfile-size="$size" $1 enc
	cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey
	--keyfile-offset=$offset --keyfile-size=$size $DRIVE enc
	cryptsetup close lukskey
	umount /mnt
	pvcreate /dev/mapper/encryptmain
	vgcreate MVG /dev/mapper/encryptmain
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

## figure out way to test script in virtual box or vagrant 
