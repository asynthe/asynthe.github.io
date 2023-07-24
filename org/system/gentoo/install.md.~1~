# Gentoo Encrypted Disk with rEFInd/btrfs+subvolumes/Wayland
---
#### Note
/# -> this means root user, so run with sudo

### Let's Start !
create your USB with ventoy, choose the GUI Live CD as it has more tools and can help us
ventoy -> [link](https://www.ventoy.net/en/download.html)
gentoo livecd -> [link](https://www.gentoo.org/downloads/)

make your partitions with cfdisk or gdisk, we will use nvme0n1 as this is 
> cfdisk /dev/nvme0n1
> gdisk /dev/nvme0n1
nvme0n1p1 //  512mb -> EFI partition for UEFI boot
nvme0n1p2 // 512mb -> boot partition required by encrypted root
nvme0n1p3 // The rest -> the encrypted system

encrypt and open the root partition
># cryptsetup luksFormat /dev/nvme0n1p3
># cryptsetup luksOpen /dev/nvme0n1p3 gentoo-crypt

format the partitions and volumes
> mkfs.vfat -F32 /dev/nvme0n1p1 # This is the EFI partition
> mkfs.vfat -F32 /dev/nvme0n1p2 # This is the meow
># mkfs.btrfs /dev/mapper/gentoo-crypt

creathe the directories and mount the top volume first, then after creating the subvolumes, unmount.
># mkdir -p /mnt/gentoo/{home,boot,.snapshots}
># mount /dev/mapper/gentoo-crypt /mnt/gentoo
-> make the btrfs subvolumes, we'll make 3: root, home and snapshots
># btrfs subvolume create /mnt/gentoo/root
># btrfs subvolume create /mnt/gentoo/home
># btrfs subvolume create /mnt/gentoo/.snapshots
-> unmount and mount
># umount /dev/mapper/gentoo-crypt
># mount -o subvol=root /dev/mapper/gentoo-crypt /mnt/gentoo

---
### Stage 3 Install

fix your time
># date MMDDhhmmYYYY

move to the directory and download the stage 3 tarball with links
> cd /mnt/gentoo 
># links https://www.gentoo.org/downloads/mirrors
choose 
the mirror -> releases -> amd64 -> autobuilds -> current-stage3-amd64-desktop-openrc -> stage3-amd64-desktop-openrc-[DATE].tar.xz

unpack the stage tarball
># tar xpvf stage3-* --xattrs-include='*.*' --numeric-owner
># rm stage3-* # for a cleaner install

##### Time to configure the make.conf
># nano -w /mnt/gentoo/etc/portage/make.conf 
and make the following changes
> ### IN MAKE.CONF ###
> COMMON_FLAGS="-march=native -O2 -pipe"
> MAKEOPTS="-j6" # number of cores plus one
> VIDEO_CARDS="nvidia intel" # intel, nvidia, radeon, vesa
> ACCEPT_KEYWORDS="~amd64" # comment this one out for a faster compile time
> ACCEPT_LICENSE="*"
> GENTOO_MIRRORS="https://gentoo.osuosl.org/ http://gentoo.osuosl.org/ https://mirror.leaseweb.com/gentoo/ http://mirror.leaseweb.com/gentoo/ rsync://mirror.leaseweb.com/gentoo/" # find your closest mirrors [here](https://www.gentoo.org/downloads/mirrors/)

-> if you're on the minimal install iso, you can use this command and select the mirrors
> mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

create repos.conf dir and copy the file to the new dir
># mkdir -p /mnt/gentoo/etc/portage/repos.conf
># cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
copy DNS info:
># cp --dereference /etc/resolv.conf /mnt/gentoo/etc

mount all required filesystems
># mount --types proc /proc /mnt/gentoo/proc
># mount --rbind /sys /mnt/gentoo/sys
># mount --make-rslave /mnt/gentoo/sys
># mount --rbind /dev /mnt/gentoo/dev
># mount --make-rslave /mnt/gentoo/dev
># mount --bind /run /mnt/gentoo/run
># mount --make-slave /mnt/gentoo/run
run these commands after if doing on live usb
># test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
># mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
># sudo mkdir /run/shm
># chmod 1777 /dev/shm /run/shm

---
### time to enter the new environment
># chroot /mnt/gentoo /bin/bash
> source /etc/profile
> export PS1="(chroot) ${PS1}"

now is good to mount the boot and efi partition (don't do it before chrooting)
> mount /dev/nvme0n1p1 /boot
> mkdir /boot/efi
> mount /dev/nvme0n1p2 /boot/efi

install a snapshot of the gentoo ebuild repository and update it
> emerge-webrsync
> emerge --sync

choose a profile
check the available profiles through <eselect profile list>
then select a profile with <eselect profile set (number)>
you can select the default stable one, otherwise select the desktop version

update the @world set
> emerge -auvDN @world

EDIT THE USE FLAGS HERE
[System - make.conf]

set the timezone and locales
> ls /usr/share/zoneinfo -> check your timezone theno
> echo "America/Santiago" > /etc/timezone
> emerge --config sys-libs/timezone-data
> echo en_US.UTF-8 UTF-8 > /etc/locale.gen # you can add more if you like
> (ADD JAPANESE HERE)
> locale-gen

set system-wide locale
first check with <eselect locale list> then choose with <eselect locale set (number)>
reload the environment
> env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

---
### Configuring the Kernel 

emerge linux firmware
> emerge --ask sys-kernel/linux-firmware 
##### linux firmware license error
fix with this
> echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" | tee -a /etc/portage/package.license

#### making your kernel with genkernel
emerge the next packages
> emerge --ask gentoo-sources genkernel intel-microcode cryptsetup lvm2 btrfs-progs ntfs3g

if the output ask you to review changed config files, do dispatch-conf and u -> use-new, then run the command again

create a symbolic link by running the next commands
> eselect kernel list
> eselect kernel set 1

you should have a symbolic link called <linux> pointing to the kernel source, check with ls and changing your directory
> ls -l /usr/src/linux
> cd /usr/src/linux

now there are two things to do. first, to add your boot partition to </etc/fstab>
> blkid or lsblk -o +UUID -> find your boot partition UUID
> #/dev/nvme0n1p1
> UUID=<UUI> /boot	fat	defaults,noatime	0 2
second, make sure you have corresponding package for the compression
emerge -p lz4

run genkernel with all the options below
> genkernel --lvm --luks --btrfs --menuconfig --save-config all
when menu opens, do the next configs
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

now, build the linux firmware package
> emerge --ask sys-kernel/linux-firmware

change the root password and make a user
> nano -w /etc/security/passwdqc.conf # enforce=everyone -> none
> passwd
> useradd -mG wheel -s /bin/bash <user>
> passwd <user>

as user is on the wheel group, install and allow for sudo
> emerge --ask sudo
> EDITOR=nano visudo
> XXXX

now in /etc/fstab add the next so your system can automatically mount the necessary partitions

> blkid or lsblk -o +UUID
> #/dev/nvme0n1p1
> UUID=CFBE-CD84 /boot vfat defaults,noatime 0 2
> #/dev/nvme0n1p2
> UUID=CFD8-E79D /boot/efi vfat defaults 0 0
> #/dev/mapper/gentoo-crypt/root
> UUID=c48ad5fb-40cc-48b5-bb89-10e9578caf57 / btrfs subvol=root,subvolid=256,relatime,rw 0 1
> #/dev/mapper/gentoo-crypt/home
> UUID=c48ad5fb-40cc-48b5-bb89-10e9578caf57 /home btrfs subvol=home,subvolid=257,relatime,rw 0 2
> #/dev/mapper/gentoo-crypt/.snapshots
>UUID=c48ad5fb-40cc-48b5-bb89-10e9578caf57 /.snapshots btrfs subvol=.snapshots,subvolid=258,relatime,rw 0 2


change hostname in /etc/conf.d/hostname

edit /etc/hosts as followed
/ # IPv4 and IPv6 localhost aliases
/ 127.0.0.1	<hostname>.localdomain localhost
/ ::1		localhost	<hostname>

install wpa_supplicant, dhcpcd, networkmanager
> emerge --ask net-misc/dhcpcd net-misc/networkmanager

> emerge -a syslog-ng cronie
> rc-update add syslog-ng default
> rc-update add cronie default

### Configuring the Bootloader
echo the following and add dmcrypt to openRC before emerging grub
> echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
> echo "sys-boot/grub:2 device-mapper" >> /etc/portage/package.use/sys-boot
> rc-update add dmcrypt boot
> emerge -a sys-boot/grub:2

edit the grub config file so luks with the btrfs subvolume works
in /etc/default/grub
-> first UUID is your raw partition
-> second UUID is your opened luks device

GRUB_CMDLINE_LINUX="crypt_root=UUID=<UUID_of_your_luks_partition> real_root=UUID=<UUID_of_your_decrypted_luks_device> rootflags=subvol=gentoo rootfstype=btrfs dolvm dobtrfs quiet"

grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable /dev/nvme0n1p2 #change it to your disk

> grub-mkconfig -o /boot/grub/grub.cfg

> exit
># cd
># umount -l /mnt/gentoo/dev{/shm,/pts,}
># umount -R /mnt/gentoo
># reboot


root passwd -> inside=Rotate4Trip
user passwd -> extend7cone9Expect

> emerge --ask sys-kernel/gentoo-kernel-bin


# How to chroot
># cryptsetup luksOpen /dev/nvme0n1p3 gentoo-crypt
># mkdir /mnt/gentoo
># mount -o subvol=root /dev/mapper/gentoo-crypt /mnt/gentoo
> cd /mnt/gentoo
># mount --types proc /proc /mnt/gentoo/proc
># mount --rbind /sys /mnt/gentoo/sys
># mount --make-rslave /mnt/gentoo/sys
># mount --rbind /dev /mnt/gentoo/dev
># mount --make-rslave /mnt/gentoo/dev
># mount --bind /run /mnt/gentoo/run
># mount --make-slave /mnt/gentoo/run
run these commands after if doing on live usb
># test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
># mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
># sudo mkdir /run/shm
># chmod 1777 /dev/shm /run/shm
-meow
># cp /etc/resolv.conf /mnt/gentoo/etc
># chroot /mnt/gentoo /bin/bash
> env-update && . /etc/profile
> export PS1="(chroot) $PS1"
> mount /dev/nvme0n1p1 /boot
> mount /dev/nvme0n1p2 /boot/efi

---
asynthe, 12022

USEFUL LINKS
https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base
https://blog.tapiocanation.xyz/post/gentoo-installation-encryption-btrfs-subvolume-multi-boot/
https://forums.gentoo.org/viewtopic-t-947396-start-0.html
https://wiki.gentoo.org/wiki/Full_Disk_Encryption_From_Scratch_Simplified
https://amedeos.github.io/gentoo/2020/12/26/install-gentoo-with-uefi-luks-btrfs-and-systemd.html