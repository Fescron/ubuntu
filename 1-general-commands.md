[[Go back]](README.md)

## Table of contents

- [Table of contents](#table-of-contents)
- [1 - General commands](#1---general-commands)
    - [1.1 - GNU Screen (serial console)](#11---gnu-screen-serial-console)
    - [1.1 - GPIO stuff (µart-adapter)](#11---gpio-stuff-%c2%b5art-adapter)
    - [1.2 - USB stuff](#12---usb-stuff)
    - [1.3 - File handling](#13---file-handling)
    - [1.4 - Packages](#14---packages)
    - [1.5 - youtube-dl](#15---youtube-dl)
    - [1.6 - Conversions](#16---conversions)
    - [1.7 - Network](#17---network)
      - [1.7.1 - Firewall](#171---firewall)
      - [1.7.2 - DHCP](#172---dhcp)
      - [1.7.3 - OpenVPN](#173---openvpn)
    - [1.8 - Other interesting commands](#18---other-interesting-commands)

------

## 1 - General commands

#### 1.1 - GNU Screen (serial console)

Activate `GNU screen` on device `/dev/ttyACM0` with baudrate `115200` and use [GNU sed](https://www.gnu.org/software/sed/) to replace the `Form Feed` (`\f`) escape sequence with the correct [ANSI Escape code](http://c-faq.com/osdep/termcap.html) to get the same form feed behaviour as in [Putty](https://www.putty.org/).

Use `CTRL + A` `K` to kill the current window.
```
screen /dev/ttyUSB0 115200
screen sed 's/\f/\o33[2J\o33[0;0H/g' /dev/ttyACM0 115200
```

Add the following in the `~/.screenrc` file in your home folder to also send a LF character when pressing the enter key.
```
# When entering, send CR and LF character instead of only CR
bindkey "\015" stuff "\015\012"
```

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

<br/>

#### 1.2 - USB stuff

Find UART to USB converter
```
dmesg | grep tt
```

List USB devices
```
lsusb
```

<br/>

#### 1.3 - File handling

Move RAF files to (new) directory
```
mkdir RAF; mv *.RAF RAF
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

<br/>

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

<br/>

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

<br/>

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

Reduce image size
```
mogrify -path smaller -format jpg -resize 40% *.jpg
mogrify -path smaller -format pdf -resize 40% *.pdf
```

<br/>

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

<br/>

#### 1.8 - Other interesting commands
```
cmatrix
espeak "stuff goes here"
aafire
bb
asciiquarium
```
