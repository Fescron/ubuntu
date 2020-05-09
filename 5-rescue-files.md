[[Go back]](README.md)

<br/>

## 5 - Rescue files using the terminal

List disks

```bash
lsblk
```

<br/>

Make mount directory

```bash
sudo  mkdir /media/usb
```

<br/>

Mount drive

```bash
sudo mount /dev/sda1 /media/usb
```

<br/>

Unmount (takes long time due to caching?)

```bash
sudo umount /media/usb
```

<br/>

Copy files (the folder `source` is in the present directory, `destination` has been made on the drive with `mkdir`)

```bash
cp -a --verbose source/. /media/usb/destination
```
