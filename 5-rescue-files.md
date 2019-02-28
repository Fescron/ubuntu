[[Go back]](README.md)

## 5 - Rescue files using the terminal

List disks
```
lsblk
```

Make mount directory
```
sudo  mkdir /media/usb
```

Mount drive
```
sudo mount /dev/sda1 /media/usb
```

Unmount (takes long time due to caching?)
```
sudo umount /media/usb
```

Copy files (the folder "source" is in the present directory, "destination" has been made on the drive with mkdir)
```
cp -a --verbose source/. /media/usb/destination
```
