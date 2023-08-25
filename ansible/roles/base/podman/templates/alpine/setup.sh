#!/bin/ash


apk add podman

# Enable cgroups v2
sed -i 's/^#?rc_cgroup_mode=/rc_cgroup_mode="unified"/' /etc/rc.conf
rc-update add cgroups
rc-service cgroups start

modprobe tun
grep '^tun$' /etc/modules || echo "tun" >> /etc/modules

# for non-root
# echo <USER>:100000:65536 >/etc/subuid
# echo <USER>:100000:65536 >/etc/subgid




# # Configure Cgroups
# cat cgroups.update-extlinux >> /etc/update-extlinux.conf
# update-extlinux
# cat cgroups.fstab >> /etc/fstab
# mount /sys/fs/cgroup

# cat >> /etc/cgconfig.conf <
# echo "tun" >> /etc/modules



# echo 'default_kernel_opts="cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"' >> /etc/update-extlinux.conf
# update-extlinux
# echo "cgroup /sys/fs/cgroup cgroup defaults 0 0" >> /etc/fstab
# mount /sys/fs/cgroup
# cat >> /etc/cgconfig.conf <
# echo "tun" >> /etc/modules
