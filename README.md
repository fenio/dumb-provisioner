# dumb-provisioner

Do you want to automatically install Debian on Dell Wyse 5070 terminals?
You're at right place.  

Do you want to automatically install Debian on other servers/computers? 
You're at right place most probably.

You will find here complete and the most basic solution to do that.

Do you want to partition two drives without using LVM/RAID?
You're covered.

Do you want to preseed root SSH key to new system?
You're covered.

Yeah. Here you'll find working solution to make it happen.
*WORKING* cause I spent a lot of hours trying *NOT* working solutions.

It's the beginning of 2023 when I'm writing this so we're talking about installing bullseye.

I used Mikrotik router for booting purpose but once you create equivalent using dhcp/tftp software solutions you should be good.
But in case you're using Mikrotik then this is what you have to configure:

```
/ip tftp
add ip-addresses=10.10.20.96/28 real-filename=pxe/
```

Of course adapt it to your network configuration.

```
/ip dhcp-server network
add address=10.10.20.96/28 boot-file-name=bootx64.efi dns-server=10.10.20.97 gateway=10.10.20.97 netmask=28 next-server=10.10.20.97
```

Again adapt it to your network configuration.

Then just upload content of this repot to the pxe directory on your Mikrotik device.
And you're all set.


