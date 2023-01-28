## dumb-provisioner

### What's that?

Just a basic script and set of config files that will help you boot/install Wyse terminals with the Debian stable over network.

### Why didn't you use foreman/packer/<whatever>?

It was just overkill for my needs. Also such tools assume you have IPMI/ILO or other advanced BMC management in your hw.
It's not the case with Wyse terminals. But I managed to force them to autoboot from network ;)

### What exactly is pxe.sh doing?

It downloads the netboot tarball, extracts kernel/initrd and creates boot image.
And it keeps all relevant files in pxe/ subdirectory.

Except installing fresh Debian system it also creates/modifies some files to make that machine more capable of being k8s node.
Take a look at node.cfg file. Especially end of it.

### How to use it?

After pxe.sh is successfully finished all the content of pxe/ directory should be copied to the place from which it will be served over tftp.
In my case it's Mikrotik router with below configuration:

DHCP & TFTP:

    [admin@Mikrotik] /ip> export
    # jan/25/2023 18:05:26 by RouterOS 7.7
    /ip pool
    add name=dhcp_lab ranges=10.10.20.105-10.10.20.110
    /ip dhcp-server
    add address-pool=dhcp_lab interface=bridge_lab name=dhcp_lab
    /ip address
    add address=10.10.20.97/28 comment=LAB interface=bridge_lab network=10.10.20.96
    /ip dhcp-server network
    add address=10.10.20.96/28 boot-file-name=bootx64.efi dns-server=10.10.20.97 gateway=10.10.20.97 netmask=28 next-server=10.10.20.97
    /ip tftp
    add ip-addresses=10.10.20.96/28 real-filename=pxe/
    /ip tftp settings
    set max-block-size=8192

So all files from pxe/ directory needs to be copied into pxe/ directory on the router.
Of course you can use software solutions instead. 

### What's rationale behind it?

Well I've got 3 Dell Wyse terminals for my homelab. And since it's homelab then from time to time I need to reinstall everything from scratch which means I have to connect keyboard and monitor to all three nodes. 
I was tired of it. Now all I have to do is `ssh root@nodeX ./reinstall.sh`

![lab](IMG_0891.jpeg)

### Wait what? 

Configuration included in this repo will not only install these nodes but also tools from Dell that allows to change BIOS/UEFI settings from Linux system.
So yeah after you invoke ./reinstall.sh on node it will reboot and try to boot from network automatically.

