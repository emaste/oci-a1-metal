.POSIX:
.PHONY:
.SUFFIXES:

all: clean efi.qcow

clean:
	umount -f mnt               || true
	gpart destroy -F md99       || true
	mdconfig -du md99           || true
	rm -rf efifat efi.* extract src mnt mount mfs*

efi.qcow: mnt/EFI/Boot/BootAA64.efi mnt/boot mfsroot
	cp -r efi/ mnt/
	cp mfsroot mnt/
	umount mnt
	# switch to gpt labelling so that /etc/fstab inside images doesn't
	# need to be changed when device names vary between VM & BM
	gpart modify -i 1 -l efiboot0 md99
	mdconfig -du md99
	# want this on arm64 too please
	qemu-img convert -c -p -f raw -O qcow2 efi.fat efi.qcow

src:
	# or whatever you prefer
	ln -s /downloads/FreeBSD/current/ga40784e/arm64 src

extract: src
	mkdir extract
	tar xpz -C extract -f src/base.txz
	tar xpz -C extract -f src/kernel.txz
	chflags -R noschg extract/*
	touch extract

efifat:
	truncate -s 1G efi.fat
	touch efifat

/dev/md99: efifat
	mdconfig -u 99 -f efi.fat

/dev/gpt/leviathan: /dev/md99
	gpart create -s gpt -f -x /dev/md99
	gpart add -t efi -l leviathan -f -x /dev/md99
	gpart commit /dev/md99

mount: /dev/gpt/leviathan
	newfs_msdos -F16 /dev/gpt/leviathan
	mkdir mnt
	mount -t msdosfs -o longnames /dev/gpt/leviathan mnt
	touch mount

mnt/EFI/Boot/BootAA64.efi: mount extract
	test -d mnt/EFI/Boot || mkdir -p mnt/EFI/Boot
	cp -v extract/boot/loader_lua.efi mnt/EFI/Boot/BootAA64.efi

mnt/boot: mount extract
	cp -r extract/boot mnt/boot

mfsroot: extract
	mkdir -p mfs/dev mfs/etc/ssh mfs/tmp mfs/var/run/dhclient mfs/var/tmp mfs/sbin mfs/mnt
	tar  -C extract -c -f - rescue boot/kernel/tmpfs.ko | tar -C mfs/ -x -v -f -
	# help dhclient a bit further
	echo 'nameserver 169.254.169.254' > mfs/etc/resolv.conf
	echo 'tmpfs	/tmp	tmpfs	rw,mode=01777	0	0' > mfs/etc/fstab
	cp -rv overlay/ mfs/
	makefs -M 32m mfsroot mfs/

qemu: efi.qcow
	qemu-system-aarch64 -m 4096M -cpu cortex-a57 -M virt -nodefaults \
		-bios edk2-aarch64-code.fd \
		-serial telnet::4444,server -nographic -monitor none -vga none \
		-drive if=none,file=efi.qcow,id=hd0 \
		-snapshot \
		-device virtio-blk-device,drive=hd0 \
		-device virtio-net-device,netdev=net0 \
		-netdev user,id=net0
