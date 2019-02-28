[[Go back]](README.md)

## Table of contents

[4 - Ubuntu tweaks](4-ubuntu-tweaks.md)
- [4.1 - General tweaks](4-ubuntu-tweaks.md#41---general-tweaks)
- [4.2 - SysRq REISUB](4-ubuntu-tweaks.md#42---sysrq-reisub)
    - [4.2.1 - Restart](4-ubuntu-tweaks.md#421---restart)
    - [4.2.2 - Shutdown](4-ubuntu-tweaks.md#422---shutdown)

------

## 4 - Ubuntu tweaks

#### 4.1 - General tweaks

Install exfat
```
sudo apt install exfat-fuse exfat-utils
```

Fix audio hissing (increase third option by one)
```
alsamixer
amixer -c 0 set 'Headphone Mic Boost',0 1; exit;
```

Launch program after startup
```
gnome-session-properties (or search for "startup applications")
```

Change applications theme
```
gsettings set org.gnome.desktop.interface gtk-theme "vimix-dark-laptop-ruby"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
```

Disable Error Report Dialog Pop-up in Ubuntu 18.04
```
sudo gedit /etc/default/apport

    enable=0
```

Shut down without the confirmation prompt
```
gsettings set org.gnome.SessionManager logout-prompt false
```

Run neofetch on terminal launch
```
sudo nano ~/.bashrc

    # On the bottom of the file add:
    echo -e ""
    neofetch
```

Add new file option in nautalus
```
touch ~/Templates/Untitled\ Document
```

Add click on icon and minimize option
```
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```

Change keyboard layout (belgian)
```
sudo nano /usr/share/X11/xkb/symbols/be
```

Setup firewall
```
sudo ufw enable
```

Folders as templates in Nautilus

[link](https://bitbucket.org/edgimar/nautilus-new-folder-from-template/overview)

<br/>

Increase swapfile size (add 6 gigabytes, 6x1024)
```
sudo swapoff /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1M count=6144 oflag=append conv=notrunc
sudo mkswap /swapfile
sudo swapon /swapfile
```
<br/>

Make `.sh` files excecutable by nautilus on double click
```
apt install dconf-editor
dfconf-editor
```
1) Go to `org > gnome > nautilus > preferences`
2) Click on executable-text-activation
3) Disable "use default value" and select from dropdown "launch" or "ask"

<br/>

Fix unusable USB to serial converters
```
sudo adduser brecht dialout
```

Add ArduinoISP udev rule
```
sudo nano /etc/udev/rules.d/99-USBtiny.rules

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0049", GROUP="adm", MODE="0666"
	
sudo service udev restart
sudo udevadm control --reload-rules
```

<br/>

#### 4.2 - SysRq REISUB

Reboot linux systems gracefully, that often works to keep the file system healthy (in contrast to hard poweroff). SysRq is often on the PrintScreen key. `REISSUB = Reboot Even If System Utterly Broken`

##### 4.2.1 - Restart
1) Press `Alt` + `PrintScreen` continuously, sometimes the `Fn` key is involved too (in laptops).
2) Slowly (one key after another) press the keys `R E I S U B` to reboot. When you press the "letter keys" you need not specify caps lock or shift.

##### 4.2.2 - Shutdown
1) Press `Alt` + `PrintScreen` continuously, sometimes the `Fn` key is involved too (in laptops).
2) Slowly (one key after another) the keys `R E I S U O` to shut down. B "Boot" is replaced by O "Off".

