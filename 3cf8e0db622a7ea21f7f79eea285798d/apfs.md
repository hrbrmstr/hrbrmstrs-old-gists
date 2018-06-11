```
hdiutil create -fs APFS -size 1GB foo.sparseimage
diskutil apfs createContainer /dev/disk1s1
diskutil apfs addVolume disk1s1 APFS newAPFS
fsck_apfs
```