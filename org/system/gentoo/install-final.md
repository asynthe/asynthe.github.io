nvme0n1p1 -> fat32 / 1G / bios boot
nvme0n1p2 -> btrfs / 20G / boot partition
nvme0n1p3 -> serpent-encrypted-btrfs / rest of disk / main
    
# gdisk /dev/nvme0n1

# cryptsetup -c serpent-xts-plain64 -s 512 -h whirlpool luksFormat /dev/nvme0n1p3
# cryptsetup luksOpen /dev/nvme0n1p3 gentoo-crypt

# mkfs.vfat -F32 /dev/nvme0n1p1
# mkdir -p /mnt/gentoo/boot/efi
# mount /dev/nvme0n1p1 /mnt/gentoo/boot

# mkfs.btrfs -L "root" /dev/mapper/gentoo-crypt
# mount -o noatime,nodiratime,ssd,compress=zlib /dev/mapper/gentoo-crypt /mnt/gentoo

making a encrypted swap key file
> # mkdir -p /mnt/gentoo/etc/keys
> # dd if=/dev/random of=/mnt/gentoo/etc/keys/swap.key bs=8388607 count=1
formatting and encrypting the swap
> # cryptsetup -c serpent-xts-plain64 -s 512 -h whirlpool luksFormat /dev/nvme0n1p2 /mnt/gentoo/etc/keys/swap.key
> # cryptsetup luksOpen -d /mnt/gentoo/etc/keys/swap.key /dev/nvme0n1p2 swap
> # mkswap /dev/mapper/swap
> # swapon /dev/mapper/swap

# date MMDDhhmmYYYY
cd /mnt/gentoo
# links https://www.gentoo.org/downloads/mirrors
# tar xpvf stage3-* --xattrs-include='*.*' --numeric-owner
# rm stage3-*
# vim /mnt/gentoo/etc/portage/make.conf
[[make.conf-install]]
-> cpuid2cpuflags
-> nproc


# mkdir -p /mnt/gentoo/etc/portage/repos.conf
# cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
# cp --dereference /etc/resolv.conf /mnt/gentoo/etc


# chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

mount /dev/nvme0n1p1 /boot
mkdir /boot/efi

emerge -auvDN @world


eselect kernel list
eselect kernel set

cd /usr/src/linux
make menuconfig
make && make modules_install && make install


for dracut (first one is gentoo-crypt
"rd.luks.uuid=47e7fa0b-2472-4015-96fb-e92ff1c21df7 root=UUID=2c98ff1c-a40a-4b8d-9131-e5fbc0446091"


-> genkernel menu config with menuconfig
genkernel --lvm --luks --btrfs --menuconfig --save-config all
-> editing /etc/genkernel.conf with your desired options (amedeos)
genkernel all

vim /etc/security/passwdqc.conf
> enforce=everyone -> none
passwd (create a pass for the root user)
useradd -mG users,wheel -s /bin/bash asynthe
passwd asynthe
vim /etc/doas.conf
> permit persist :wheel

vim /etc/conf.d/hostname -> your hostname
vim /etc/hosts
> 127.0.0.1 genkai.localdomain	localhost
> ::1	localhost	genkai


add your stuff to /etc/fstab
# boot
UUID=...
# boot/efi
UUID=... vfat defaults 0 0
# root
UUID=<gentoo-crypt UUID>

echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
echo "sys-boot/grub:2 device-mapper" >> /etc/portage/package.use/sys-boot
emerge -a sys-boot/grub

vim /etc/default/grub
> GRUB_CMDLINE_LINUX="crypt_root=UUID=(blkid /dev/nvme0n1p3) root=UUID=(blkid /dev/mapper/gentoo-crypt) rootflags=subvol=@ rootfstype=btrfs dolvm dobtrfs quiet"
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

exit
cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo
reboot

---
links
[amedeos](https://amedeos.github.io/gentoo/2020/12/26/install-gentoo-with-uefi-luks-btrfs-and-systemd.html)
[gingermilk](https://blog.tapiocanation.xyz/post/gentoo-installation-encryption-btrfs-subvolume-multi-boot/)

UUID -> blkid or lsblk -o +UUID

not build bluetooth

time emerge --ask --verbose --update --deep --with-bdeps=y --newuse  --keep-going --backtrack=30 @world