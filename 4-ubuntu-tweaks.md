[[Go back]](README.md)

<br/>

## Table of contents

- [Table of contents](#table-of-contents)
- [4 - Ubuntu tweaks](#4---ubuntu-tweaks)
  - [4.1 - General tweaks](#41---general-tweaks)
  - [4.2 - SysRq REISUB](#42---sysrq-reisub)
    - [4.2.1 - Restart](#421---restart)
    - [4.2.2 - Shutdown](#422---shutdown)
  - [4.3 - Ubuntu 20.04](#43---ubuntu-2004)

<br/>

------

<br/>

## 4 - Ubuntu tweaks

### 4.1 - General tweaks

Install exfat

```bash
sudo apt install exfat-fuse exfat-utils
```

<br/>

Fix *QSync* not being able to synchronize

```bash
sudo apt install libssl1.0
```

<br/>

Add `script` folder to `$PATH` so scripts can be executed anywhere

```bash
sudo gedit ~/.profile

    # CUSTOM: set PATH so it includes the script folder
    if [ -d "$HOME/Programs/0-scripts" ] ; then
      PATH="$PATH:$HOME/Programs/0-scripts"
    fi
```

<br/>

Fix audio hissing (increase third option by one)

```bash
alsamixer
amixer -c 0 set 'Headphone Mic Boost',0 1; exit;
```

<br/>

Launch program after startup

```bash
gnome-session-properties (or search for "startup applications")
```

<br/>

Change applications theme

```bash
gsettings set org.gnome.desktop.interface gtk-theme "vimix-dark-laptop-ruby"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
```

<br/>

Add startup sound (add following line in *"Startup Application Preferences"*)

```bash
paplay /usr/share/sounds/Yaru/stereo/desktop-login.oga
```

<br/>

Disable Error Report Dialog Pop-up in Ubuntu 18.04

```bash
sudo gedit /etc/default/apport

    enable=0
```

<br/>

Shut down without the confirmation prompt

```bash
gsettings set org.gnome.SessionManager logout-prompt false
```

<br/>

Run neofetch on terminal launch

```bash
sudo nano ~/.bashrc

    # On the bottom of the file add:
    echo -e ""
    neofetch
```

<br/>

Add new file option in nautalus

```bash
touch ~/Templates/Untitled\ Document
```

<br/>

Add click on icon and minimize option

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```

<br/>

Change keyboard layout (belgian)

```bash
sudo nano /usr/share/X11/xkb/symbols/be
```

<br/>

Setup firewall (see also [1.8.1 - Firewall](1-general-commands.md#181---firewall))

```bash
sudo ufw enable
```

<br/>

Folders as templates in *nautilus*

[link](https://bitbucket.org/edgimar/nautilus-new-folder-from-template/overview)

<br/>

Increase swapfile size (add 6 gigabytes, 6x1024)

```bash
sudo swapoff /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1M count=6144 oflag=append conv=notrunc
sudo mkswap /swapfile
sudo swapon /swapfile
```

<br/>

Make `.sh` files executable by *nautilus* on double click

```bash
apt install dconf-editor
dfconf-editor
```

1) Go to `org > gnome > nautilus > preferences`
2) Click on executable-text-activation
3) Disable "use default value" and select from dropdown "launch" or "ask"

<br/>

Fix unusable USB to serial converters

```bash
sudo adduser brecht dialout
```

<br/>

Add *ArduinoISP* udev rule

```bash
sudo nano /etc/udev/rules.d/99-USBtiny.rules

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0049", GROUP="adm", MODE="0666"
	
sudo service udev restart
sudo udevadm control --reload-rules
```

<br/>

### 4.2 - SysRq REISUB

Reboot linux systems gracefully, that often works to keep the file system healthy (in contrast to hard poweroff). SysRq is often on the PrintScreen key. `REISSUB = Reboot Even If System Utterly Broken`

<br/>

#### 4.2.1 - Restart

1) Press `Alt` + `PrintScreen` continuously, sometimes the `Fn` key is involved too (in laptops).
2) Slowly (one key after another) press the keys `R E I S U B` to reboot. When you press the "letter keys" you need not specify caps lock or shift.

<br/>

#### 4.2.2 - Shutdown

1) Press `Alt` + `PrintScreen` continuously, sometimes the `Fn` key is involved too (in laptops).
2) Slowly (one key after another) the keys `R E I S U O` to shut down. B "Boot" is replaced by O "Off".

<br/>

### 4.3 - Ubuntu 20.04

Enable remote screen sharing (program missing?)

```bash
sudo apt install vino
```

<br/>

Install exFAT

```bash
sudo apt-get install exfat-utils exfat-fuse
```

<br/>

Auto mount drive (partition) on startup

1) Type `disks` in the launcher.
2) Select the drive and partition in question.
3) Press the *gear icon* and select `Edit Mount Options`.
4) Disable `User Session Defaults` and make sure `Mount at system startup` is checked.
5) Type a `Display Name`.
6) Change the `Mount Point` to one that's easier to remember. 

<br/>

Change *formats*

1) Type `Region & Language` in the launcher.
2) Click on `Managed Installed Languages`.
3) Click on `Install/Remove Languages`.
4) Select `Dutch`.
5) Now select in the tab `Regional Formats` `Nederlands (België)` for the numbers.
6) Restart the computer.
