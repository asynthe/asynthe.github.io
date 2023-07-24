-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]]

# LTO + Graphite
---
"Interested in running Gentoo at (theoretically) maximum speed? Want to have a nearly fully [LTO-ized](https://gcc.gnu.org/wiki/LinkTimeOptimization) system? Read on to see how it can be done!"

[github page](https://github.com/InBetweenNames/gentooLTO)

add the repositories
```
# eselect repository enable mv
# eselect repository enable lto-overlay
```
sync them
```
individually
# emaint sync -r mv
# emaint sync -r lto-overlay
or sync all
# emerge --sync
```

unmask packages, add in `/etc/portage/package.accept_keywords`
```
#Required by LTO Overlay
sys-config/ltoize ~amd64
app-portage/portage-bashrc-mv ~amd64
app-shells/runtitle ~amd64
sys-devel/gcc ~amd64
```
OR
if you're using this in `/etc/portage/make.conf`, then you <u>don't need</u> to unmask the packages
```
ACCEPT_KEYWORDS="~amd64"
```

update gcc if there's an update for a increased likelihood of success
```
# emerge --ask gcc
choose your newest version of gcc
# eselect gcc list
# eselect gcc <number> set
```

<u>some fixes</u>
go to `/etc/portage/package.cflags/` and edit `ltoworkarounds.conf`, add the next at the end of the file
```
...
dev-libs/libltdl *FLAGS+="-fno-lto"
net-libs/mbedtls *FLAGS+="-fno-lto"
```

<u>fix for neovim error</u>
go to `/etc/portage/package.accept_keywords` and add:
```
media-libs/x264 -~amd64
app-editors/neovim **
```

now it's time for compiling the tools we will need
```
# emerge --ask sys-config/ltoize
```

let's modify `make.conf` and add some more stuff
```
NTHREADS="auto"

source make.conf.lto

COMMON_FLAGS="-march=native $(CFLAGS) -pipe"
...
CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt sse sse2 sse3 sse4_1 sse4_2 ssse3"
USE="pgo lto graphite"
```

__final steps!__

do a dependency clean
```
# emerge --ask --depclean
```
build everything with lto enabled
```
# emerge -e --keep-going @world
or
# emerge -aqve --keep-going @world
```