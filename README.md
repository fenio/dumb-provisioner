# dumb-provisioner
The most straighforward way to autoinstall Dell Wyse 5070 terminals... but probably not only them.

I used Mikrotik router but once you create equivalent using dhcp/tftp software solutions you should be good.
But in case you're using Mikrotik then this is what you have to configure:

```
/ip tftp
add ip-addresses=10.10.20.96/28 real-filename=pxe/
```

```
/ip dhcp-server network
add address=10.10.20.96/28 boot-file-name=bootx64.efi dns-server=10.10.20.97 gateway=10.10.20.97 netmask=28 next-server=10.10.20.97
```



