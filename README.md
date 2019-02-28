# ubuntu

This file contains all of the commands I use/have used while running Ubuntu.

<br/>

## 1 - General commands

#### 1.1 - GPIO stuff (µart-adapter)
```
sudo gpiodetect
sudo gpioinfo

sudo gpioset gpiochip1 0=1  # Set GPO high
sudo gpioset gpiochip1 0=0  # Set GPO low
sudo gpioget gpiochip1 3    # Read GPI
```

Set GPO low for one second
```
sudo gpioset --mode=time --sec=1 gpiochip1 0=0; sudo gpioset gpiochip1 0=1
```

#### 1.2 - USB stuff

Find UART to USB converter
```
dmesg | grep tt
```

List USB devices
```
lsusb
```

#### 1.3 - File handling

Move RAF files to directory
```
mv *.RAF RAF
```

Find directory (case insensitive ("i"name), directories, wildcards with *)
```
sudo find / -iname '*qnap*' -type d
```

Fix locked folders (7: Full - Read, Write & Execute)
```
sudo chmod 777 -R /path/to/folder
```

Make directory
```
sudo mkdir /path/to/folder
```

Copy files
```
cp -a --verbose path/to/source/folder/. /path/to/destination/folder
```

#### 1.4 - Packages

Package handling
```
aptitude
```

APT commands (better version op apt-get and apt-cache combined)
```
apt update        # Refreshes repository index
apt upgrade       # Upgrades all upgradable packages

apt instal        # Installs a package
apt remove        # Removes a package
apt purge         # Removes package with configuration
apt autoremove    # Removes unwanted packages
apt full-upgrade  # Upgrades packages with auto-handling of dependencies
apt search        # Searches for the program
apt show          # Shows package details
apt list          # Lists packages with criteria (installed, upgradable etc)
apt edit-sources  # Edits sources list
```

#### 1.5 - youtube-dl

Install youtube-dl
```
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```

Update youtube-dl
```
youtube-dl -U
```

Download best mp4 format available or any other best if no mp4 available
```
youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' <Video-URL>
```

Download youtube videos as a best quality audio mp3
```
youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 <Video-URL>
```

#### 1.6 - Conversions

Combine MP4 & M4A
```
ffmpeg -i mpd.mp4 -i mpd.m4a -map 0:0 -map 1:0 -vcodec copy -acodec copy newvideo.mp4
```

Convert MP4 to MP3
```
ffmpeg -i 'input.mp4' -q:a 0 -map a 'output.mp3'
```

Convert color PDF to black & white
```
convert -density 300 -threshold 50% input.pdf output.pdf
convert -verbose -density 300 -threshold 80% input.pdf output.pdf
```

#### 1.7 - Network

##### 1.7.1 - Firewall

Basic firewall stuff
```
sudo ufw enable
sudo ufw disable
sudo ufw status
sudo ufw status verbose
```

Reset firewall rules to default values
```
sudo ufw reset
```

Allow specific ports through firewall
```
sudo ufw allow ssh
sudo ufw allow 22/tcp
sudo ufw allow 1716:1764/tcp
sudo ufw allow 1716:1764/udp
```

Delete specific ports in firewall
```
ufw delete allow ssh
```

##### 1.7.2 - DHCP

Release & renew DHCP IP
```
sudo dhclient -r; sudo dhclient
```

##### 1.7.3 - OpenVPN

Launch & kill openvpn
```
sudo openvpn --config openvpn.ovpn
sudo killall -SIGINT openvpn
```

#### 1.8 - Interesting things
```
cmatrix
espeak "stuff goes here"
aafire
bb
asciiquarium
```

------

## 2 - Tweaks

#### 2.1 - General tweaks

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

## 4 - Desktop icons

