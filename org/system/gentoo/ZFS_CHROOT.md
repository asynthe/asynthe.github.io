-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]] / [[GENTOO_INSTALL_ZFS]]
-> [[MAIN メイン]] / [[GUIDES ガイド]] / [[FILESYSTEMS]] / [[ZFS]]

# EASY ZFS CHROOT
---

```
# mkdir /mnt/gentoo
```

```
zpool import  
zpool import rpool  
  
zfs get all rpool (get all info)  
  
zfs load-key rpool (enter encrypted key)  
zfs list  
zfs set mountpoint=/mnt/gentoo rpool/ROOT/gentoo  
zfs mount -R rpool/ROOT/gentoo  
or  
zfs mount -a (for mounting everything)  
```

```
# mount --types proc /proc /mnt/gentoo/proc  
# mount --rbind /sys /mnt/gentoo/sys  
# mount --make-rslave /mnt/gentoo/sys  
# mount --rbind /dev /mnt/gentoo/dev  
# mount --make-rslave /mnt/gentoo/dev  
# mount --bind /run /mnt/gentoo/run  
# mount --make-slave /mnt/gentoo/run 
```

```
# mount /dev/nvme1n1p1 /mnt/gentoo/efi
# chroot /mnt/gentoo /bin/bash
(chroot) # source /etc/profile
(chroot) # export PS1="(chroot) ${PS1}"
```

---
```
zfs set mountpoint=/ rpool/ROOT/gentoo  
zfs umount -a  
zpool export rpool 
```
...  
exit  
 
  
^ This does not work, maybe we can reboot, see if it works.  
If not, rescd: change mountpoint and export  
  
IN DRACUT SHELL
```dracut
# zpool import -f rpool
# zfs load-key rpool
# zfs set mountpoint=/ rpool/ROOT/gentoo
# reboot -f
```