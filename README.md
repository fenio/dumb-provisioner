## dumb-provisioner

### What's that?

Just a basic script and set of config files that will help you generate files needed to boot/install Wyse terminals with the Debian stable over network.
Well now I'm also using it for installing VMs in my homelab so it can be used for other purposes as well.

### Why didn't you use foreman/packer/\<whatever\>?

It was just overkill for my needs. Also such tools assume you have IPMI/ILO or other advanced BMC management in your HW.
It's not the case with Wyse terminals. But I found a way to force them to netboot from working Linux system.

Also. While there are plenty of guides to make your own netbooting/bootstrapping I found that majority of them use legacy/BIOS and solutions like pxelinux and while I was experimenting with them I found them really unreliable.
So if you're trying to boot UEFI based systems do NOT try to do this with pxelinux. They say they support it but it's really poor and buggy support. Don't waste time like me and go straight to the grub2 based solutions. 

### What exactly is pxe.sh doing?

It downloads the netboot tarball, extracts kernel/initrd and creates boot image based on grub bootloader.
And it keeps all relevant files in pxe/ subdirectory.
It should be run from Debian system... well Ubuntu should probably work too.

Final solution should install fresh Debian system and create/modify some files to make that machine more capable of being k8s node.
Take a look at node.cfg file. Especially end of it.

### How to use it?

After pxe.sh is successfully finished all the content of pxe/ directory should be copied to the place from which it will be served over tftp.
In my case it's Mikrotik router with below configuration:

DHCP & TFTP:

```
/interface bridge
add comment=LAB name=bridge_lab protocol-mode=none
/interface list
add name=lab
/ip pool
add name=dhcp_lab ranges=10.10.20.105-10.10.20.110
/ip dhcp-server
add address-pool=dhcp_lab bootp-support=dynamic interface=bridge_lab lease-time=10m name=dhcp_lab
/interface bridge port
add bridge=bridge_lab ingress-filtering=no interface=ether6
add bridge=bridge_lab ingress-filtering=no interface=ether7
add bridge=bridge_lab ingress-filtering=no interface=ether8
add bridge=bridge_lab ingress-filtering=no interface=ether9
add bridge=bridge_lab ingress-filtering=no interface=ether10
/interface list member
add interface=ether6 list=lab
add interface=ether7 list=lab
add interface=ether8 list=lab
add interface=ether9 list=lab
add interface=ether10 list=lab
/ip address
add address=10.10.20.97/28 comment=LAB interface=bridge_lab network=10.10.20.96
/ip dhcp-server
add address-pool=dhcp_vlan interface=*21 lease-time=10m name=dhcp_vlan
/ip dhcp-server network
add address=10.10.20.96/28 boot-file-name=pxe/bootx64.efi dns-server=10.10.20.97 gateway=10.10.20.97 netmask=28 next-server=10.10.20.97
/ip tftp
add allow-rollover=yes ip-addresses=10.10.20.96/28 real-filename=pxe/bootx64.efi req-filename=bootx64.efi
add allow-rollover=yes ip-addresses=10.10.20.96/28 real-filename=pxe/linux req-filename=linux
add allow-rollover=yes ip-addresses=10.10.20.96/28 real-filename=pxe/initrd.gz req-filename=initrd.gz
add allow-rollover=yes ip-addresses=10.10.20.96/28 real-filename=/pxe/master.cfg req-filename=.*/master.cfg
add allow-rollover=yes ip-addresses=10.10.20.96/28 real-filename=/pxe/node.cfg req-filename=.*/node.cfg
/ip tftp settings
set max-block-size=8192
```

So all files from pxe/ directory needs to be copied into pxe/ directory on the router.
You should change MAC adresses in grub.cfg.

### I don't have Mikrotik router.

You can use software equivalents instead. Some DHCP server and some TFTP server.

### What's rationale behind it?

Well I've got 3 Dell Wyse terminals for my homelab. And since it's homelab then from time to time I need to reinstall everything from scratch which means I have to connect keyboard and monitor to all three nodes. 
I was tired of it. Now all I have to do is `ssh root@nodeX ./reinstall.sh`

![lab](IMG_0891.jpeg)

### Wait what? 

Configuration included in this repo will not only install these nodes but also tools from Dell that allows to change UEFI boot settings from Linux system.
So yeah after you invoke ./reinstall.sh on node it will reconfigure UEFI and try to boot from network automatically.

