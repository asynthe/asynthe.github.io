-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]]

# equery
---
[main page](https://wiki.gentoo.org/wiki/Equery)

install -> `app-portage/gentoolkit`

__COMMANDS__
```
list use flags of a package
$ equery uses <pkg>

list dependent packages
$ equery depends <pkg>

list dependencies
$ equery depgraph <pkg>

list installed files
$ equery files <pkg>

query which package files belongs to
$ equery belongs <file>
```