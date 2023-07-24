## How to chroot
---

sudo cryptsetup luksOpen /dev/nvme0n1p3 gentoo-crypt

sudo mkdir /mnt/gentoo
sudo mount -o subvol=root /dev/mapper/gentoo-crypt /mnt/gentoo
cd /mnt/gentoo

```
sudo mount --types proc /proc /mnt/gentoo/proc && sudo mount --rbind /sys /mnt/gentoo/sys && sudo mount --make-rslave /mnt/gentoo/sys && sudo mount --rbind /dev /mnt/gentoo/dev && sudo mount --make-rslave /mnt/gentoo/dev && sudo mount --bind /run /mnt/gentoo/run && sudo mount --make-slave /mnt/gentoo/run
```

sudo test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
sudo mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
sudo sudo mkdir /run/shm
sudo chmod 1777 /dev/shm /run/shm
sudo cp /etc/resolv.conf /mnt/gentoo/etc
sudo chroot /mnt/gentoo /bin/bash
env-update && . /etc/profile
export PS1="(chroot) $PS1"

mount /dev/nvme0n1p1 /boot
mount /dev/nvme0n1p2 /boot/efi
