[[Go back]](README.md)

<br/>

## Table of contents

- [Table of contents](#table-of-contents)
- [1 - General commands](#1---general-commands)
  - [1.1 - GNU Screen (serial console)](#11---gnu-screen-serial-console)
  - [1.1 - GPIO stuff (µart-adapter)](#11---gpio-stuff-%c2%b5art-adapter)
  - [1.2 - USB stuff](#12---usb-stuff)
  - [1.3 - File handling](#13---file-handling)
  - [1.4 - rsync](#14---rsync)
  - [1.5 - Packages](#15---packages)
  - [1.6 - youtube-dl](#16---youtube-dl)
  - [1.7 - Conversions](#17---conversions)
  - [1.8 - Network](#18---network)
    - [1.8.1 - Firewall](#181---firewall)
    - [1.8.2 - DHCP](#182---dhcp)
    - [1.8.3 - OpenVPN](#183---openvpn)
  - [1.9 - Other interesting commands](#19---other-interesting-commands)

<br/>

------

<br/>

## 1 - General commands

### 1.1 - GNU Screen (serial console)

Activate `GNU screen` on device `/dev/ttyUSB0` with baudrate `115200`.

Use `CTRL + A` `K` to kill the current window.

```bash
screen /dev/ttyUSB0 115200
```
<br/>

Activate `GNU screen` on device `/dev/ttyACM0` with baudrate `115200` and use [GNU sed](https://www.gnu.org/software/sed/) to replace the `Form Feed` (`\f`) escape sequence with the correct [ANSI Escape code](http://c-faq.com/osdep/termcap.html) to get the same form feed behaviour as in [Putty](https://www.putty.org/).

Use `CTRL + A` `K` to kill the current window.

```bash
screen sed 's/\f/\o33[2J\o33[0;0H/g' /dev/ttyACM0 115200
```

<br/>

Add the following in the `~/.screenrc` file in your home folder to also send a LF character when pressing the enter key.

```bash
# When entering, send CR and LF character instead of only CR
bindkey "\015" stuff "\015\012"
```

<br/>

### 1.1 - GPIO stuff (µart-adapter)

```bash
sudo gpiodetect
sudo gpioinfo

sudo gpioset gpiochip1 0=1  # Set GPO high
sudo gpioset gpiochip1 0=0  # Set GPO low
sudo gpioget gpiochip1 3    # Read GPI
```

<br/>

Set GPO low for one second

```bash
sudo gpioset --mode=time --sec=1 gpiochip1 0=0; sudo gpioset gpiochip1 0=1
```

<br/>

### 1.2 - USB stuff

Find UART to USB converter

```bash
dmesg | grep tt
```

<br/>

List USB devices

```bash
lsusb
```

<br/>

### 1.3 - File handling

Move RAF files to (new) directory

```bash
mkdir RAF; mv *.RAF RAF
```

<br/>

Find directory (case insensitive ("i"name), directories, wildcards with *)

```bash
sudo find / -iname '*qnap*' -type d
```

<br/>

Fix locked folders (7: Full - Read, Write & Execute)

```bash
sudo chmod 777 -R /path/to/folder
```

<br/>

Make directory

```bash
mkdir /path/to/folder
```

<br/>

Copy files

```bash
cp -a --verbose path/to/source/folder/. /path/to/destination/folder
```

<br/>

### 1.4 - rsync

Sync files from `SOURCE` to `DEST` (*mounted* hard drive) path and connect to the rsync daemon running on a server with `IPADDR` and `USER`

```bash
rsync --dry-run --exclude '@*' --exclude '.@*' -azvh --progress --stats --delete rsync://USER@IPADDR:/SOURCE /mnt/DEST
```

- `-n`, `--dry-run` test the settings, **remove to copy the files for real**
- `--exclude '@*' --exclude '.@*'` exclude files/folders starting with `@` and `.@*`
- `-a` archive mode,  equivalent to the following options
  - `-r`, `--recursive` recurse into directories
  - `-l`, `--links` copy symlinks as symlinks
  - `-p`, `--perms` preserve permissions
  - `-t`, `--times` preserve modification times
  - `-g`, `--group` preserve group
  - `-o`, `--owner` preserve owner (super-user only)
  - `-D` equivalent to `--devices --specials`
    - `--devices` preserve device files (super-user only)
    - `--specials` preserve special files
  - The following things are NOT included (`--no-OPTION`)
    - `-H`, `--hard-links` preserve hard links
    - `-A`, `--acls` preserve ACLs (implies `-p`)
    - `-X`, `--xattrs` preserve extended attributes
  - **Watch out!** rsync can't use `-a` when the target is an exFAT drive because it doesn't handle permissions on this file system. Use `-rlD` instead.
- `-z` compress file data during transfer
- `-v` verbose output
- `-P` equivalent to `--partial --progress`
  - `--partial` preserve partial files
  - `--progress` display progress
- `-h`, `--human-readable` output numbers in a more human-readable format (large numbers get converted to ones with a K, M, or G suffix)
- `--stats` print a verbose set of statistics on the file transfer after it's finished
- `--delete` delete any files on the destination system that don't exist on the source system

<br/>

- `--info=progress2` for example, the output `105.45M 13% 602.83kB/s 0:02:50 (xfr#495, ir-chk=1020/3825)` means the following ([source](https://unix.stackexchange.com/questions/215271/understanding-the-output-of-info-progress2-from-rsync))
  - So far 105.45 megabytes (or 13%) of the approximately 811.15 megabytes (100%) of the files have been reconstructed.
  - The files are being reconstructed at a rate of 602.83 kilobytes per second.
  - The current elapsed time is 2 minutes and 50 seconds.
  - `xfr#495` means that currently the 495th file is being transferred.
  - `ir-chk=1020/3825` indicates that, out of a total of (so far) 3825 files recursively scanned (detected), so far 1020 of them are still to be checked/verified.
    - `ir-chk` (incremental recursion check) is displayed until all files are recursively scanned. The number on both sides is incremented.
    - `to-chk` is displayed when all the files are found. The second number now stays constant and the first will decrease until it's zero.

<br/>

### 1.5 - Packages

Package handling

```bash
aptitude
```

<br/>

APT commands (better version op apt-get and apt-cache combined)

```bash
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

### 1.6 - youtube-dl

Install youtube-dl

```bash
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```

<br/>

Update youtube-dl

```bash
youtube-dl -U
```

<br/>

Download best `mp4` format available or any other best if no `mp4` available

```bash
youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' <Video-URL>
```

Download youtube videos as a best quality audio `mp3`

```bash
youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 <Video-URL>
```

<br/>

### 1.7 - Conversions

Combine `mp4` & `p4a`

```bash
ffmpeg -i mpd.mp4 -i mpd.m4a -map 0:0 -map 1:0 -vcodec copy -acodec copy newvideo.mp4
```

<br/>

Convert `mp4` tp `mp3`

```bash
ffmpeg -i 'input.mp4' -q:a 0 -map a 'output.mp3'
```

<br/>

Convert color `pdf` to black & white

```bash
convert -density 300 -threshold 50% input.pdf output.pdf
convert -verbose -density 300 -threshold 80% input.pdf output.pdf
```

<br/>

Reduce image size and place the results in the folder `smaller`

```bash
mogrify -path smaller -format jpg -resize 80% *.jpg
```

<br/>

Reduce `pdf` size using `ghostscript` ([source](https://tex.stackexchange.com/questions/18987/how-to-make-the-pdfs-produced-by-pdflatex-smaller))

```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=output.pdf input.pdf
```

<br/>

### 1.8 - Network

#### 1.8.1 - Firewall

Basic firewall stuff

```bash
sudo ufw enable
sudo ufw disable
sudo ufw status
sudo ufw status verbose
```

<br/>

Reset firewall rules to default values

```bash
sudo ufw reset
```

<br/>

Allow specific ports through firewall

```bash
sudo ufw allow ssh
sudo ufw allow 22/tcp
sudo ufw allow 1716:1764/tcp
sudo ufw allow 1716:1764/udp
```

<br/>

Delete specific ports in firewall

```bash
ufw delete allow ssh
```

#### 1.8.2 - DHCP

Release & renew DHCP IP

```bash
sudo dhclient -r; sudo dhclient
```

#### 1.8.3 - OpenVPN

Launch & kill openvpn

```bash
sudo openvpn --config openvpn.ovpn
sudo killall -SIGINT openvpn
```

<br/>

### 1.9 - Other interesting commands

```bash
cmatrix
espeak "stuff goes here"
aafire
bb
asciiquarium
```
