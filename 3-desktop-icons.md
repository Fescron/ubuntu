[[Go back]](README.md)

## Table of contents

[3 - Desktop icons](3-desktop-icons.md)
- [3.1 - Launch Simplicity studio and chance theme (using script)](3-desktop-icons.md#31---launch-simplicity-studio-and-chance-theme-using-script)
- [3.2 - Headphone fix](3-desktop-icons.md#32---headphone-fix)
- [3.3 - Check USB to Serial converters](3-desktop-icons.md#33---check-usb-to-serial-converters)
- [3.4 - Eclipse shortcut](3-desktop-icons.md#34---eclipse-shortcut)

------

## 3 - Desktop icons

After all of the changes use:
```
sudo update-desktop-database
```

<br/>

#### 3.1 - Launch Simplicity studio and chance theme (using script)
```
sudo gedit /usr/local/share/applications/custom-SimplicityStudio_v4.desktop

    [Desktop Entry]
    Name=Custom Simplicity Studio v4
    Type=Application
    Exec=/home/brecht/Programs/SimplicityStudio_v4/run_studio.sh
    Terminal=true
    Description=Change theme
```

```
sudo chmod a+x /usr/local/share/applications/custom-SimplicityStudio_v4.desktop
```

```bash
gedit /home/brecht/Programs/SimplicityStudio_v4/sudo_run_studio.sh

    #!/bin/bash
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    cd /home/brecht/Programs/SimplicityStudio_v4/
    ./run_studio.sh
    gsettings set org.gnome.desktop.interface gtk-theme "vimix-dark-laptop-ruby"
```

```
sudo chmod a+x /home/brecht/Programs/SimplicityStudio_v4/run_studio.sh
```

<br/>

#### 3.2 - Headphone fix
```
sudo gedit /usr/local/share/applications/headphonefix.desktop

    [Desktop Entry]
    Name=Headphone fix
    Type=Application
    Exec=amixer -c 0 set 'Headphone Mic Boost',0 1
    Terminal=true
```

```
sudo chmod a+x /usr/local/share/applications/headphonefix.desktop
```

<br/>

#### 3.3 - Check USB to Serial converters
```
sudo gedit /usr/local/share/applications/showserialadapters.desktop

    [Desktop Entry]
    Name=Show USB to Serial (UART) converters
    Type=Application
    Exec=/home/brecht/Programs/0-scripts/showSerialAdapters.sh
    Terminal=true
```

```
sudo chmod a+x /usr/local/share/applications/showserialadapters.desktop
```

```bash
gedit /home/brecht/Programs/0-scripts/showSerialAdapters.sh

    #!/bin/bash
    dmesg | grep tty
    read
```

```
sudo chmod a+x /home/brecht/Programs/0-scripts/showSerialAdapters.sh
```

<br/>

#### 3.4 - Eclipse shortcut
```
gedit .local/share/applications/eclipse.desktop

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
```
