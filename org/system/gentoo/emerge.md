-> [[MAIN メイン]] / [[LINUX リナックス]] / [[Gentoo ジェンツー]]

# emerge
---

### **installing a package**
- check for package use flags with
```
equery u <package-name>
```
or by looking for the app in [gentoo packages](https://packages.gentoo.org/)
- add the use flags
if `package.use` is a file
```
echo '<package-name> <use-flag>' > /etc/portage/package.use
```
if `package.use` is a directory, make a file for your app
```
touch <package-name>
```

example: enabling the `offensive` flag for `sudo`
```
echo 'app-admin/sudo offensive' > /etc/portage/package.use
```

then when you compile you can check what USE flags are going to be compiled with emerge.



writing in japanese:
[[IBUS+ANTHY]]
