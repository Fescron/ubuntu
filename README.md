# ubuntu

This repository contains all of the commands I use/have used while running Ubuntu.

<br/>

### Table of contents

[1 - General commands](1-general-commands.md)
- 1.1 - GPIO stuff (µart-adapter)
- 1.2 - USB stuff
- 1.3 - File handling
- 1.4 - Packages
- 1.5 - youtube-dl
- 1.6 - Conversions
- 1.7 - Network
    - 1.7.1 - Firewall
    - 1.7.2 - DHCP
    - 1.7.3 - OpenVPN
- 1.8 - Interesting things

[2 - Timelapse to video with ffmpeg](2-timelapse-ffmpeg.md)
- 2.1 - General commands
- 2.2 - Options explained

[3 - Desktop icons](3-desktop-icons.md)
- 3.1 - Launch Simplicity studio and chance theme (using script)
- 3.2 - Headphone fix
- 3.3 - Check USB to Serial converters

[4 - Ubuntu tweaks](4-ubuntu-tweaks.md)
- 4.1 - 


------

## 2 - Tweaks

#### 2.1 - General tweaks

Bulk convert JPGs to 1920x1080, centered
```
convert input.jpg -resize '1920x1080^' -gravity center -crop '1920x1080+0+0' output.jpg
```

Renaming
```
mkdir renamed; num=0; for f in $(ls -tr); do cp -p "$f" renamed/IMG_$(printf "%04d" $num).JPG; printf "\n\r$num"; num=$((num+1)); done
```

<br/>

#### 2.2 - SysRq REISUB

Reboot linux systems gracefully, that often works to keep the file system healthy (in contrast to hard poweroff). SysRq is often on the PrintScreen key. `REISSUB = Reboot Even If System Utterly Broken`

##### 2.2.1 - Restart
1) Press `Alt` + `PrintScreen` continuously, sometimes the `Fn` key is involved too (in laptops).
2) Slowly (one key after another) press the keys `R E I S U B` to reboot. When you press the "letter keys" you need not specify caps lock or shift.

##### 2.2.2 - Shutdown
1) Press `Alt` + `PrintScreen` continuously, sometimes the `Fn` key is involved too (in laptops).
2) Slowly (one key after another) the keys `R E I S U O` to shut down. B "Boot" is replaced by O "Off".

------

## 3 - Rescue files using the terminal

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

------
