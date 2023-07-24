-> [[linux/gentoo/gentoo/install/install-gentoo]]
-> [[GENTOO_INSTALL]]

# Gentoo Post-Install
---

change from rsync to git
lto package

ADD THIS TO INSTALL GUIDE
```
# emerge terminus-font rsync zsh-completions zsh-syntax-highlighting gentoo-zsh-completions zsh-lovers btrfs-progs
```

__changing the console font__
edit `/etc/conf.d/consolefont`
```
consolefont="lat9w-16" -> "ter-132n"
```

add to boot level
```
# rc-update add consolefont boot
```

__repositories__
for this list of apps
guru -> `megasync`, `rpcs3`
gentoo-zh ->
wayland-desktop -> wayland related
brave-overlay -> brave browser

```
# eselect repository enable guru
# eselect repository enable gentoo-zh
# eselect repository enable wayland-desktop
# eselect repository enable brave-overlay
```

sync them
```
# emaint -r guru sync
# emaint
```

__main suite of packages__
i will include librewolf-bin then replace it for the compiled
```
# emerge -aq --keep-going btop cmus cpu-x app-shells/dash easytag emacs feh ffmpeg htop ibus ibus-anthy imagemagick irssi ja-ipafonts keepassxc lf libvirt libqalculate media-sound/mpc mpd mpv ncmpcpp neofetch nsxiv plocate qbittorrent screenkey stellarium syncthing takao-fonts texlive texlive-xetex latexmk texlive-langchinese texlive-langcjk texlive-langspanish vimtex weechat wireshark xdg-utils yt-dlp zathura zathura-meta qemu fftw cmake libpulse pulseaudio trash-cli net-p2p/monero brave-bin tor lolcat figlet sl pv net-misc/ntp xrandr lightdm-gtk-greeter-settings gpm links betterlockscreen xournalpp kakoune x11-misc/xclip

arandr
```

the long ones, leave them running somewhere
```
# emerge librewolf libreoffice telegram-desktop ncdu
```

```
# updatedb
# ntpd -q -g
# hwclock --systohc

# xdg-mime default $ zathura.desktop application/pdf
```
updatedb for plocate

gpasswd -a asynthe libvirt



uncompress them
### just uncompress everything and its ok

setting up all fonts, themes, icons, cursors (system level)
```
# cp -r ~/main/system/fonts/* /usr/share/fonts
# cp -r ~/main/system/gtk-qt/themes/* /usr/share/themes
# cp -r ~/main/system/gtk-qt/icons/* /usr/share/icons
# mkdir /usr/share/icons/cursors

cursors need to be in .tar.gz format
# cp -r ~/main/system/gtk-qt/cursors/* /usr/share/icons/cursors
```

prefer this one
setting up all fonts, themes, icons, cursors (user level)
```
$ mkdir -p .local/share/{fonts,icons/cursors,themes}
# cp -r ~/main/system/fonts/* ~/.local/share/fonts

# cp -r ~/main/system/gtk-qt/themes/* /usr/share/themes

# cp -r ~/main/system/gtk-qt/icons/* ~/.local/share/icons
# mkdir /usr/share/icons/cursors
# cp -r ~/main/system/gtk-qt/cursors/* /usr/share/icons/cursors
```

services (systemd)
```
# 
# 
# 
# 
# 
```

services (OpenRC)
```
# rc-update add mpd default
# rc-update add gpm default
# rc-update add monerod default
# rc-update add libvirt default
# rc-update add ntp-client default
```

packer.nvim
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\

~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

__japanese__
[[ibus-anthy]]
[[fcitx5-mozc]]

__build__
-> [[unimatrix]]
-> pfetch
-> [[cli-visualizer]]
-> [[peaclock]]

__configuring__
-> [[Librewolf]]
-> [[system/a_guide_to/VIM/NVIM]]
-> [[zathura]]



```
Custom Kernel
O3 LTO Graphite
systemd
ly
xmonad / hyprland