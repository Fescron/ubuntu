[[Go back]](README.md)

## Table of contents

- [6 - Old unused commands](6-old-unused-commands.md)
    - [6.1 - Disable USB autosuspend](6-old-unused-commands.md#61---disable-usb-autosuspend)
    - [6.2 - Bluetooth mouse](6-old-unused-commands.md#62---bluetooth-mouse)
    - [6.3 - Fix noise speakers](6-old-unused-commands.md#63---fix-noise-speakers)
    - [6.4 - Headphone jack suddenly stopped working](6-old-unused-commands.md#64---headphone-jack-suddenly-stopped-working)
    - [6.5 - Bluetooth doesn't work after resume from sleep/standby](6-old-unused-commands.md#65---bluetooth-doesnt-work-after-resume-from-sleepstandby)
    - [6.6 - Three finger tap not working with synaptics touchpad driver](6-old-unused-commands.md#66---three-finger-tap-not-working-with-synaptics-touchpad-driver)
    - [6.7 - Power save stuff](6-old-unused-commands.md#67---power-save-stuff)

------

## 6 - Old unused commands

#### 6.1 - Disable USB autosuspend

**Unused as of 26-01-2019:** Should not be necessary anymore [link](https://www.crowdsupply.com/pylo/muart/updates/final-update)

Fix for https://uart-adapter.com/. Can't interface to GPI/O pin when no terminal window is open

- Console error: `gpioset: error setting the GPIO line values: No route to host`
- Kernel log error: `ftdi_sio 1-2:1.0: bitmode request failed for value 0x2000: -113`
    - USB packets can return this error if the packet is rejected because the device is in USB suspend.
    - **Solution:** Disable USB suspend! (see below)
    - This might also fix WIFI not working anymore after wakeup from sleep, when a sleep re-cycle usually fixes it. [link](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1291969)
    - **Better solution:** Only blacklist a specific device (this method was not used) [link](https://askubuntu.com/questions/185274/how-can-i-disable-usb-autosuspend-for-a-specific-device)

```
sudo nano /etc/default/grub
    
    old line: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
    new line: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash usbcore.autosuspend=-1"
```

Update (& reboot)
```
sudo update-grub
```

Check if fix worked (should now yield "-1" instead of "2")
```
cat /sys/module/usbcore/parameters/autosuspend
```

<br/>

#### 6.2 - Bluetooth mouse
```
sudo hciconfig hci0 sspmode 1
sudo hciconfig hci0 down
sudo hciconfig hci0 up
```

<br/>

#### 6.3 - Fix noise speakers
```
sudo nano /etc/modprobe.d/alsa-base.conf

    options snd-hda-intel power_save=0
```

<br/>

#### 6.4 - Headphone jack suddenly stopped working
```
alsactl restore
```

<br/>

#### 6.5 - Bluetooth doesn't work after resume from sleep/standby
- https://ubuntuforums.org/showthread.php?t=1387211

<br/>

#### 6.6 - Three finger tap not working with synaptics touchpad driver
- https://askubuntu.com/questions/739490/three-finger-tap-not-working-with-synaptics-touchpad-driver
- https://github.com/iberianpig/fusuma

<br/>

#### 6.7 - Power save stuff
- https://www.howtogeek.com/55185/how-to-maximize-the-battery-life-on-your-linux-laptop/
- https://askubuntu.com/questions/285434/is-there-a-power-saving-application-similar-to-jupiter
- http://linrunner.de/en/tlp/docs/tlp-configuration.html
