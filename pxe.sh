mkdir -p pxe netboot
wget -nc https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/current/images/netboot/netboot.tar.gz -O netboot/netboot.tar.gz
tar zxf netboot/netboot.tar.gz -C netboot
cp netboot/debian-installer/amd64/linux pxe/
cp netboot/debian-installer/amd64/initrd.gz pxe/
grub-mkstandalone --compress=xz -d /usr/lib/grub/x86_64-efi/ -O x86_64-efi –fonts=”unicode” -o ./pxe/bootx64.efi "boot/grub/grub.cfg=./grub.cfg"
