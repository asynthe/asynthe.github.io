# Gentoo Encrypted Disk with btrfs/rEFInd/Wayland

sudo gdisk /dev/nvme0n1

nvme0n1p1 //  512mb -> EFI partition for UEFI boot (vfat, grub)
nvme0n1p2 // 512mb -> boot partition required by encrypted root (btrfs, root)
nvme0n1p3 // The rest -> the encrypted system
	-> dev/lvm/root (btrfs, root)
    -> dev/lvm/swap (swap)

sudo cryptsetup --cipher aes-xts-plain -s 512 luksFormat /dev/nvme0n1p3
sudo cryptsetup luksOpen /dev/nvme0n1p3 gentoo-crypt

pvcreate /dev/mapper/gentoo-crypt
vgcreate lvm /dev/mapper/gentoo-crypt
vgchange -a y lvm
lvcreate -L 8G -n swap lvm
lvcreate -l 100%FREE -n root lvm

sudo mkfs.vfat -F32 /dev/nvme0n1p1
sudo mkfs.vfat -F32 /dev/nvme0n1p2
(sudo mkfs.btrfs /dev/mapper/gentoo-crypt # root)
sudo mkswap /dev/lvm/swap
sudo swapon /dev/lvm/swap
sudo mkfs.btrfs /dev/lvm/root

sudo mkdir -p /mnt/gentoo/
sudo mount /dev/lvm/root /mnt/gentoo

date MMDDhhmmYYYY
cd /mnt/gentoo
sudo links https://www.gentoo.org/downloads/mirrors
sudo tar xpvf stage3-* --xattrs-include='*.*' --numeric-owner
sudo rm stage3-*
sudo emerge vim
sudo nano -w /mnt/gentoo/etc/portage/make.conf

> ### IN MAKE.CONF ###
> COMMON_FLAGS="-march=native -O2 -pipe"
> MAKEOPTS="-j6" # number of cores plus one
> EMERGE_DEFAULT_OPTS="-j3"
> VIDEO_CARDS="nvidia intel"
> ACCEPT_KEYWORDS="~amd64" # comment this one out for a faster compile time
> ACCEPT_LICENSE="*"
> GENTOO_MIRRORS="https://gentoo.osuosl.org/ http://gentoo.osuosl.org/ https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/" # find your closest mirrors [here](https://www.gentoo.org/downloads/mirrors/)

sudo mkdir -p /mnt/gentoo/etc/portage/repos.conf
sudo cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
sudo cp --dereference /etc/resolv.conf /mnt/gentoo/etc
sudo mount --types proc /proc /mnt/gentoo/proc
sudo mount --rbind /sys /mnt/gentoo/sys
sudo mount --make-rslave /mnt/gentoo/sys
sudo mount --rbind /dev /mnt/gentoo/dev
sudo mount --make-rslave /mnt/gentoo/dev
sudo mount --bind /run /mnt/gentoo/run
sudo mount --make-slave /mnt/gentoo/run
sudo test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
sudo mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
sudo mkdir /run/shm
sudo chmod 1777 /dev/shm /run/shm
sudo chroot /mnt/gentoo /bin/bash
-
source /etc/profile
export PS1="(chroot) ${PS1}"
mount /dev/nvme0n1p1 /boot
mkdir /boot/efi
mount /dev/nvme0n1p2 /boot/efi
emerge-webrsync
emerge --sync
eselect profile list
eselect profile set <number>
emerge -auvDN @world
-
[my gentoo make.conf](x)
-
ls /usr/share/zoneinfo
echo "America/Santiago" > /etc/timezone
emerge --config sys-libs/timezone-data
-
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
echo ja_JP.UTF-8 UTF-8> /etc/locale.gen
locale-gen
eselect locale list
eselect locale set <number>
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
-
emerge --ask gentoo-sources genkernel intel-microcode cryptsetup lvm2 btrfs-progs ntfs3g vim sudo
eselect kernel list
eselect kernel set 1
ls -l /usr/src/linux # check for symbolic link
cd /usr/src/linux
blkid or lsblk -o +UUID -> find your boot partition UUID
> #/dev/nvme0n1p1
echo UUID=<UUID>	/boot		fat		defaults,noatime		0 2
genkernel --lvm --luks --btrfs --menuconfig --save-config all

> #btrfs support
> File systems  --->
>     <*> Btrfs filesystem
> 
> #luks support
> [*] Enable loadable module support
> Device Drivers --->
>     [*] Multiple devices driver support (RAID and LVM) --->
>         <*> Device mapper support
>         <*>   Crypt target support
> [*] Cryptographic API --->
>     <*> XTS support
>     <*> SHA224 and SHA256 digest algorithm
>     <*> AES cipher algorithms
>     <*> AES cipher algorithms (x86_64)
>     <*> User-space interface for hash algorithms
>     <*> User-space interface for symmetric key cipher algorithms
> General setup  --->
>     [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support
> 
> #lvm support
> Device Drivers  --->
>    Multiple devices driver support (RAID and LVM)  --->
>       <*> Device mapper support
>            <*> Crypt target support
>            <*> Snapshot target
>            <*> Mirror target
>            <*> Multipath target
>                <*> I/O Path Selector based on the number of in-flight I/Os
>                <*> I/O Path Selector based on the service time
> 
> #ntfs support
> File systems  --->
>   <*> FUSE (Filesystem in Userspace) support
>     DOS/FAT/NT Filesystems  --->
>         <*> NTFS file system support
>         <*>   NTFS write support
> 
> #nvme support
> Device Drivers →
>   NVME Support →
>     <*> NVM Express block device
>     [*] NVMe multipath support
>     [*] NVMe hardware monitoring
>     <M> NVM Express over Fabrics FC host driver
>     <M> NVM Express over Fabrics TCP host driver
>     <M> NVMe Target support
>           [*]   NVMe Target Passthrough support
>         <M>   NVMe loopback device support
>         <M>   NVMe over Fabrics FC target driver
>         < >     NVMe over Fabrics FC Transport Loopback Test driver (NEW)
>         <M>   NVMe over Fabrics TCP target support

emerge --ask sys-kernel/linux-firmware
if linux firmware license error -> echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" | tee -a /etc/portage/package.license

nano -w /etc/security/passwdqc.conf # enforce=everyone -> none
passwd
useradd -mG wheel -s /bin/bash <user>
passwd <user>

sudo vim /etc/doas.conf
> permit (user) as root

blkid or lsblk -o +UUID
> #/dev/nvme0n1p1
> UUID=<UUID> /boot vfat defaults,noatime 0 2
> #/dev/nvme0n1p2
> UUID=<UUID> /boot/efi vfat defaults 0 0
> #/dev/mapper/gentoo-crypt
> UUID=<UUID> / btrfs relatime,rw 0 

sudo vim /etc/conf.d/hostname
sudo vim /etc/hosts
> IPv4 and IPv6 localhost aliases
> 127.0.0.1	<hostname>.localdomain localhost
> ::1		localhost	<hostname>

emerge --ask net-misc/dhcpcd net-misc/networkmanager syslog-ng cronie
rc-update add syslog-ng default
rc-update add cronie default

echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
echo "sys-boot/grub:2 device-mapper" >> /etc/portage/package.use/sys-boot
rc-update add dmcrypt boot
emerge -a sys-boot/grub:2

sudo vim /etc/default/grub
-> first UUID is your raw partition (/dev/nvme0n1p3)
-> second UUID is your opened luks device (/dev/mapper/gentoo-crypt)
> GRUB_CMDLINE_LINUX="crypt_root=UUID=<UUID_of_your_luks_partition> real_root=UUID=>>><UUID_of_your_decrypted_luks_device> rootfstype=btrfs dolvm dobtrfs quiet"

grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable /dev/nvme0n1p2
grub-mkconfig -o /boot/grub/grub.cfg
exit
cd
sudo umount -l /mnt/gentoo/dev{/shm,/pts,}
sudo umount -R /mnt/gentoo
sudo reboot
---