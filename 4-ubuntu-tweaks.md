[[Go back]](README.md)

## 4 - Ubuntu tweaks

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

  # On the bottom of the file add
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

# Eclipse shortcut
gedit .local/share/applications/eclipse.desktop
# In the file add
	[Desktop Entry]
	Name=Eclipse
	Type=Application
	Exec=/home/brecht/Programs/eclipse/eclipse-java/eclipse/eclipse
	Terminal=false
	Icon=/home/brecht/Programs/eclipse/eclipse-java/eclipse/icon.xpm
	Comment=Integrated Development Environment
	NoDisplay=false
	Categories=Development;IDE;
	Name[en]=Eclipse
sudo update-desktop-database


Change keyboard layout (belgian)
```
sudo nano /usr/share/X11/xkb/symbols/be
```


Setup firewall
```
sudo ufw enable
```

Folders as templates in Nautilus
[https://bitbucket.org/edgimar/nautilus-new-folder-from-template/overview]()


Increase swapfile size (add 6 gigabytes, 6x1024)
```
sudo swapoff /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1M count=6144 oflag=append conv=notrunc
sudo mkswap /swapfile
sudo swapon /swapfile
```


Make `.sh` files excecutable by nautilus on double click
```
apt install dconf-editor
dfconf-editor 	# org > gnome > nautilus > preferences
				# click on executable-text-activation
				# disable "use default value" and select from dropdown "launch" or "ask"
```


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
