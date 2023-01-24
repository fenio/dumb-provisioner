# dumb-provisioner

I've got three Dell Wyse 5070 terminals for my home lab and I was tired reinstalling them manually.
This repo has solution for that.

It installs Debian on them and preparations should be also run from Debian.

Do a copy of this repo and run `./pxe.sh`.

That should create directory ready to be uploaded to tftp/pxe server.

In my case it's Mikrotik router but it should work with whatever solution.



