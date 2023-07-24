-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]]
-> [[MAIN メイン]] / [[GUIDES ガイド]] / [[FILESYSTEMS]] / [[ZFS]]

# __GENTOO INSTALL__
---
__ENCRYPTED ZFS / SYSTEMD__

[[ZFS_CHROOT]]

__ADD__
efibootmgr quiet options
zfsbootmenu
https://github.com/zbm-dev/zfsbootmenu
__info__
[ap4y - gentoo on zfs encrypted root with efi stub](https://ap4y.me/2020/06/08/gentoo-on-zfs-encrypted-root-with-efi-stub/)
https://wiki.gentoo.org/wiki/User:Fearedbliss/Installing_Gentoo_Linux_On_ZFS
https://old.reddit.com/r/Gentoo/comments/4npwe9/zfs_on_gentoo_anyone/

2GB EFI
32GB ZFS SWAP (16*2)
REST HOME

download the latest sysresccd with openzfs here
[gentoo livecd with OpenZFS](https://xyinn.org/gentoo/livecd/)

dracut (?)
efistub

```
# setfont ter-128n
```

gdisk (efi-1GB / swap-20GB / rest-XGB)
```
gdisk /dev/vda
n
.
.
+2G
ef00
n
.
.
.
bf00)
w
Y
```
format in vfat
```
# mkfs.vfat -F32 /dev/vda1
```

set time
```
# date MMDDhhmmYYYY
```

remove existing zfs hostid file and genereate a new zfs hostid record
```
# rm -f /etc/hostid && zgenhostid
```

creating the root pool
```
# zpool create -f -o ashift=12 \
> -o cachefile=/etc/zfs/zpool.cache \
> -O acltype=posixacl \
> -O relatime=on \
> -O xattr=sa \
> -O dnodesize=auto \
> -O normalization=formD \
> -O mountpoint=none \
> -O compression=lz4 \
> -O encryption=on \
> -O keyformat=passphrase \
> -O keylocation=prompt \
> -R /mnt/gentoo \
> rpool /dev/vda3
```

creating rootfs dataset
```
# zfs create -o mountpoint=none -o canmount=off rpool/ROOT
# zfs create -o mountpoint=/ rpool/ROOT/gentoo
```

set boot flag for zfs root dataset
```
# zpool set bootfs=rpool/ROOT/gentoo rpool
```

creating `/usr`, `/var`, `/var/lib` and `/home` zfs dataset containers
```
# zfs create -o canmount=off rpool/usr
# zfs create -o canmount=off rpool/var
# zfs create -o canmount=off rpool/var/lib
# zfs create -o canmount=off rpool/home
```

creating the swap volume
```
# zfs create -V 32G -b $(getconf PAGESIZE) \
-o compression=zle \
-o logbias=throughput \
-o sync=always \
-o primarycache=metadata \
-o secondarycache=none \
-o com.sun:auto-snapshot=false \
rpool/swap
```
activate it
```
# mkswap -f /dev/zvol/rpool/swap
# swapon /dev/zvol/rpool/swap
```

verify everything looks good with:
```
# zpool status
# zfs list
```

mount
```
cd /mnt/gentoo/
mkdir efi
mount /dev/nvme1n1p1 efi
```

do a straight `wget` for the stage3 `.tar.xz`:
```
# wget https://mirror.aarnet.edu.au/pub/gentoo/releases/amd64/autobuilds/current-stage3-amd64-desktop-openrc/stage3-amd64-desktop-openrc-20221127T170156Z.tar.xz
# tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
# rm stage3-*
```

copy the zpool cache
```
# mkdir etc/zfs
# cp /etc/zfs/zpool.cache etc/zfs
```

copy network settings
```
# cp --dereference /etc/resolv.conf /mnt/gentoo/etc
```
mounting the filesystems
```
# mount --types proc /proc /mnt/gentoo/proc
# mount --rbind /sys /mnt/gentoo/sys
# mount --make-rslave /mnt/gentoo/sys
# mount --rbind /dev /mnt/gentoo/dev
# mount --make-rslave /mnt/gentoo/dev
# mount --bind /run /mnt/gentoo/run
# mount --make-slave /mnt/gentoo/run
```

__CHROOT__
```
# chroot /mnt/gentoo /bin/bash
# source /etc/profile
# export PS1="(chroot) ${PS1}"
```

check if date was saved
```
# date MMDDhhmmYYYY
```

__FSTAB__
check your devices `UUID` with
```
# blkid | grep nvme1n1p1
check your EFI and SWAP UUID and echo append them into fstab
# echo 'UUID=<efi-UUID>' >> /etc/fstab
```
now edit `/etc/fstab` file with an editor like `nano`
```
UUID=<efi-UUID>  /efi  vfat  noauto,defaults 1 2
/dev/zvol/<pool>/swap none swap discard 0 0
```
you don't need to worry about the zfs partition, because it is managed by it's own tools.

__LOCALE__
choose your system __locale__
```
for US english
# echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
for Japanese locale
echo 'ja_JP.UTF-8 UTF-8' > /etc/locale.gen
```
generate it
```
# locale-gen
```
set it on eselect
```
# eselect locale list
# eselect locale set <number>
```
finally, update your environment
```
# env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```

__HOSTNAME__
edit `/etc/conf.d/hostname` with your hostname
```
# echo 'genkai' > /etc/conf.d/hostname
```
also edit `/etc/hosts` file
```
# 127.0.0.1 genkai.localdomain	localhost
# ::1	localhost	genkai
```


__PORTAGE__

copy default portage config
```
# mkdir /etc/portage/repos.conf
# cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
```

update Portage
```
# emerge-webrsync
__in case of a Portage update, then__
# emerge --oneshot sys-apps/portage
```

select your system profile, in this case
```
# eselect profile list
# eselect profile set <number>
```

i like creating these as folders
```
# mkdir -p /etc/portage/package.{accept_keywords,license,mask,unmask,use}
```

intel microcode at initramfs
```
# echo "sys-firmware/intel-microcode initramfs" > /etc/portage/package.use/intel-microcode
# emerge --ask intel-microcode mirrorselect cpuid2cpuflags
```

__MAKE.CONF__
now it's time to do a [[make.conf]]
don't forget to write your cpu flags
# cpuid2flags
```
using mirrorselect for selecting close mirrors
```
# mirrorselect -i -o >> /etc/portage/make.conf
```

emerging main apps and tools
```
# emerge --ask neovim efibootmgr dracut gptfdisk ntfs3g dosfstools cronie sudo doas networkmanager pciutils mirrorselect cpuid2cpuflags eselect-repository bash-completion dev-vcs/git gentoolkit eix intel-microcode
```

__TIMEZONE__
configure your timezone
```
# echo 'Australia/Perth' > /etc/timezone
# emerge --config sys-libs/timezone-data
```

__using a kernel bin__

this way makes for a fast install and you don't need to compile the kernel.

if going this way remember to add this to your `make.conf

```
...
USE="dist-kernel"
...
```

install the binary kernel (change the kernel bin version for which one the zfs is requiring)
```
check for the zfs k
# emerge --ask sys-fs/zfs-kmod sys-fs/zfs
# emerge =gentoo-kernel-bin-6.0.18 linux-firmware
```

set and check the kernel symlink
```
# eselect kernel list
# eselect kernel set <number>
# ls -l /usr/src/
```

installing zfs software and kernel modules, this should be installed after kernel configuration is complete.
```
# emerge sys-fs/zfs
```
enabling ZFS services
__systemd__
``` 
# systemctl enable zfs.target
# systemctl enable zfs-import-cache
# systemctl enable zfs-mount
# systemctl enable zfs-import.target
```
__open-rc__
```
# rc-update add zfs-import boot
# rc-update add zfs-mount boot
# rc-update add zfs-share default
# rc-update add zfs-zed default
```
generate and verify the zfs hostid file
```
# zgenhostid
# file /etc/hostid
```

copy the kernel into the efi directory
```
# mkdir -p /efi/efi/gentoo
# cd /efi/efi/gentoo
# cp /boot/vmlinuz-5.15.41-gentoo .
# mv vmlinuz-5.15.41-gentoo vmlinuz-5.15.41-gentoo.efi
```

using __dracut__ for the initramfs
```
# dracut -H --kver X.Y.Z-gentoo
```
```
# dracut --hostonly -k /lib/modules/5.15.41-gentoo --kver 5.15.41-gentoo -f /boot/initramfs-5.15.41-gentoo.img
# cp /boot/initramfs-5.15.41-gentoo.img .
```

### __installing the bootloader onto the drive__
now we need to configure the bootloader to direct boot the linux kernel and initramfs
- note: remove a efibootmgr entry with: `efibootmgr -b <number> -B`
```
# ls /efi/efi/gentoo
# efibootmgr --disk /dev/nvme1n1 \
# --part 1 --create --label "Gentoo" \
# --loader "efi\gentoo\vmlinuz-5.15.41-gentoo.efi" \
# --unicode 'initrd=\efi\gentoo\initramfs-5.15.41-gentoo.img \
# dozfs loglevel=3 quiet rw rd.systemd.show_status=false \
# rd.udev.log_level=3 root=ZFS=rpool/ROOT/gentoo'
```
`efibootmgr` will print the uefi firmware loader table contents

---

Services
__systemd__
```
(syslog-ng replaced by journalctl)
# systemctl enable cronie
# systemctl enable NetworkManager
```

__OpenRC__
```
# rc-update add syslog-ng default
# rc-update add cronie default
# rc-update add NetworkManager default
# rc-update add elogind boot
# rc-update add dbus default
```

### __FINAL STEPS__

__USER__
create your user
```
# useradd -m -s /bin/bash -G wheel,portage <username>
```

edit `/etc/doas.conf`
```
permit persist <username>
```
- `persist` will ask you for password every 5 minutes
- `nopass` will let you execute without password

changing the password security
in `/etc/security/passwdqc.conf`, edit
```
...
enforce=everyone -> none
...
```


now add a password for root and your user
```
Add a password for root
# passwd
for user
# passwd <username>
```

```
(chroot)# exit
# zfs umount -a
# zpool export rpool
# reboot
```

__We're finished!__

What's left now it's to `exit` and then `reboot`, i hope your system works perfectly!

---

__AFTER INSTALL__




i like setting a japanese locale after i have a functional system, another terminal that can display japanese characters.

### __LOCALE__
choose your system __locale__
```
for US english
# echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
for Japanese locale
echo 'ja_JP.UTF-8 UTF-8' > /etc/locale.gen
```
generate it
```
# locale-gen
```
set it on eselect
```
# eselect locale list
# eselect locale set <number>
```
finally, update your environment
```
# env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```

CHECK ! ADD?
ZFSBootMenu
https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS

ZFS Cheatsheet
https://lildude.co.uk/zfs-cheatsheet

systemd
https://wiki.gentoo.org/wiki/Systemd
https://habets.io/wiki/silent-boot/
https://www.reddit.com/r/archlinux/comments/qs60hg/get_a_simplified_and_textless_boot_process_with/
https://wiki.archlinux.org/title/silent_boot

edward snowden
https://www.youtube.com/watch?v=e9yK1QndJSM
