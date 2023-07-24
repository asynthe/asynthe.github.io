put in install guide -> user doas
in /etc/doas.conf
> permit (user) as root

# Portage
### system - wayland
hikari sway waybar wofi swaylock sddm
### cli
fish ranger redshift mpvpaper dunst
### gui
alacritty lightdm sddm display-manager-init virt-manager mpv firefox-bin aegisub keepassxc lxappearance wayland qtwayland discord-bin emacs
fish ranger imv nyxt lynx zathura zathura-cb zathura-pdf-mupdf neofetch cmatrix cava unzip acpi libreoffice nitrogen xournalpp
no feh
### fonts
source-pro fira-code fira-mono ubuntu-font-family libertine liberation-fonts noto noto-emoji noto-cjk source-han-sans umeplus-fonts shinonome  

#### making display managers usable
in /etc/conf.d/display-manager
> DISPLAY MANAGER="xdm" -> "lightdm" or "sddm"

then
># rc-update add dbus default
># rc-update add display-manager default
># rc-service dbus start
># rc-service display-manager start

# Nvidia Drivers
install
># emerge --ask x11-drivers/nvidia-drivers
Prime run

---
# Pipewire
> Device Drivers  --->
>     <*> Sound card support  --->
>         <*> Advanced Linux Sound Architecture  --->
>             [*]   Sound Proc FS Support
>             [*]     Verbose procfs contents
install pipewire
># emerge --ask pipewire wireplumber

edit this in ~/.xprofile
># gentoo-pipewire-launcher &

if replacing PulseAudio
in /etc/portage/package.use add
> media-video/pipewire sound-server
> media-sound/pulseaudio -daemon
then
># emerge -a -uvDU @world

sudo emerge --ask gentoolkit
sudo equery d alsa-plugins
if installed -> sudo emerge -C alsa-plugins

Check if pipewire is active
>LANG=C pactl info | grep "Server Name"

---
# layman
># layman -L // list all existing repositories
># layman -l // list installed repositories
># layman -a // add a repository
># layman -d // delete a repository
># layman -s (repo-name) // update repository
># layman -S // update all repositories 

### install:
># emerge --ask app-portage/layman
># layman-updater -R

#### megasync (not working)
layout: guru
name: app-misc/megasync
#### obsidian
layout: r7l
name: app-text/obsidian
##### optimus manager - notion-app-enhanced
layout: gig
name: x11-misc/optimus-manager
name: app-misc/notion-app-enhanced
#### steam
layout: steam-overlay
name: games-util/steam-launcher games-util/steam-meta
sudo dispatch.conf -> use-new: u
if ncurses error -> sudo USE="-gpm" emerge --ask ncurses
#### pfetch
layout: ricerlay
name: app-misc/pfetch

---
# Virt-manager

---

# Tiling Window Managers
## Hyprland
> git clone --recursive https://github.com/vaxerski/Hyprland
> cd Hyprland
> sudo make install

>meson <_build_>
>ninja -C <_build>
>ninja -C <_build> install

config file -> .config/hypr/hyprland.conf

---
## Hikari
> mkdir ~/.config/hikari
> cp /etc/hikari/hikari.conf ~/.config/hikari

config file -> .config/hikari/hikari.conf

---
# Cron jobs

---

# building from source
oh-my-fish hyprland ly doom-emacs starfetch