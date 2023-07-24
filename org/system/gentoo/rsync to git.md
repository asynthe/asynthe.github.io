-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]]

# changing sync rsync to git
---
"making `emerge --sync` be __mega__ fast."

delete your repos configuration files.
```
# doas rm -rf /var/db/repos
```

as root, do this config in -> `/etc/portage/repos.conf/gentoo.conf`
```
[DEFAULT]
main-repo = gentoo
sync-allow-hardlinks = no
sync-depth = 1

[gentoo]
priority = 100
location = /var/db/repos/gentoo
auto-sync = yes

#sync-type = rsync
#sync-uri = rsync://rsync.gentoo.org/gentoo-portage
sync-depth = 1
sync-type = git
sync-uri = https://github.com/gentoo/gentoo.git

#sync-rsync-verify-jobs = 1
#sync-rsync-verify-metamanifest = yes
#sync-rsync-verify-max-age = 24
sync-openpgp-key-path = /usr/share/openpgp-keys/gentoo-release.asc
#sync-openpgp-keyserver = hkps://keys.gentoo.org
sync-openpgp-key-refresh-retry-count = 40
sync-openpgp-key-refresh-retry-overall-timeout = 1200
sync-openpgp-key-refresh-retry-delay-exp-base = 2
sync-openpgp-key-refresh-retry-delay-max = 60
sync-openpgp-key-refresh-retry-delay-mult = 4
#sync-webrsync-verify-signature = yes
sync-git-verify-commit-signature = true
```

__error `no valid signature found unable to verify signature`__
change in `/etc/portage/repos.conf/gentoo.conf`
```
sync-git-verify-commit-signature = true -> false
```

now do, and see the magic
```
# emerge --sync
```
