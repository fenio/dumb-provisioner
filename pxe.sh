mkdir -p pxe netboot
wget -nc https://deb.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/netboot.tar.gz -O netboot/netboot.tar.gz
tar zxf netboot/netboot.tar.gz -C netboot
cp netboot/debian-installer/amd64/linux pxe/
cp netboot/debian-installer/amd64/initrd.gz pxe/
grub-mkimage -d /usr/lib/grub/x86_64-efi/ -O x86_64-efi -o ./pxe/bootx64.efi -p ‘\(pxe\)/grub’ efinet tftp
cp -r netboot/debian-installer/amd64/grub/x86_64-efi pxe/grub/
