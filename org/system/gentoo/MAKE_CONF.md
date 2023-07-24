-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]]

# MAKE.CONF
---
main page

[GCC Optimization](https://wiki.gentoo.org/wiki/GCC_optimization)
[Safe CFLAGS](https://wiki.gentoo.org/wiki/Safe_CFLAGS)

`app-portage/cpuid2cpuflags` `app-misc/resolve-march-native`

__<u>SIMPLE make.conf</u>__

```
COMMON_FLAGS="-march=native -O3 -pipe"
...
MAKEOPTS="-j<nproc+1>"
EMERGE_DEFAULT_OPTS=" --with-bdeps=y --complete-graph=y"

ACCEPT_LICENSE="*"

```

__<u>MAIN make.conf</u>__

```
COMMON_FLAGS="-march=skylake -O3 -pipe"
...
CPU_FLAGS_X86="aes avx avx2 f16c fma3 mmx mmxext pclmul popcnt rdrand sse sse2 sse3 sse4_1 sse4_2 ssse3"
MAKEOPTS="-j6"
EMERGE_DEFAULT_OPTS="--jobs=12 --load-average=13 with-bdeps=y --complete-graph=y"
VIDEO_CARDS="nvidia intel"
ACCEPT_LICENSE="*"
ACCEPT_KEYWORDS="~amd64"
INPUT_DEVICES="libinput synaptics"
L10N="ja"
USE="\
X wayland xwayland gles2 \
jpeg png gif mpv \
pipewire pulseaudio echo-cancel \
mp3 mp4 flac \
\"
```