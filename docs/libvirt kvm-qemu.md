# Libvirt and kvm/qemu under arch

VMs under arch require much more manual setup for whatever reason.

Networking should now be provided with `core.json`. The default `nftables` backend[^1] should be installed and enabled automagically with the whole stack. However, the network still needs to be set up and started

The network has to be at least set to start, and potentially created depending on when it's called:

```
sudo virsh net-define /usr/share/libvirt/networks/default.xml
sudo virsh net-autostart default
sudo virsh net-start default

sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```

On failure:
* Try a reboot. `nftables` inexplicably started working after a reboot. Maybe there's more deps that need to start that aren't started automatically with systemctl commands?
* If all else fails: set the network backend to `iptables` in `/etc/libvirt/network.conf`. `nftables` appears to be functionally experimental with how unstable it is

Unknowns:
* Does nftables need to be started as well?

[^1]: firewalld + nftables is supposed to be better with , but because of https://github.com/firewalld/firewalld/issues/1370, firewalld is unusable. nftables in general seems to be much harder to get to work. During testing, switching to iptables just works, while nftables required a reboot and took my connection with it. `nftables` is supposed to be the successor to `iptables`, but it's just so much worse. If it wasn't for `nftables` being a successor to iptables resulting in a potential `iptables` deprecation that'll force the `nftables` migration at some point anyway, I wouldn't bother and just stick with `iptables`, which has worked well for like 25 years.
 
