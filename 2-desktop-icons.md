## 2 - Desktop icons

#### 2.1 - Launch Simplicity studio and chance theme (using script)
```
sudo gedit /usr/local/share/applications/custom-SimplicityStudio_v4.desktop
    Name=Custom Simplicity Studio v4
    Type=Application
    Exec=/home/brecht/Programs/SimplicityStudio_v4/run_studio.sh
    Terminal=true
    Description=Change theme
```

```
sudo chmod a+x /usr/local/share/applications/custom-SimplicityStudio_v4.desktop
```

```
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

#### 2.2 - Headphone fix
```
sudo gedit /usr/local/share/applications/headphonefix.desktop
    Name=Headphone fix
    Type=Application
    Exec=amixer -c 0 set 'Headphone Mic Boost',0 1
    Terminal=true
```

```
sudo chmod a+x /usr/local/share/applications/headphonefix.desktop
```

<br/>

#### 2.3 - Check USB to Serial converters
```
sudo gedit /usr/local/share/applications/showserialadapters.desktop
    Name=Show USB to Serial (UART) converters
    Type=Application
    Exec=/home/brecht/Programs/0-scripts/showSerialAdapters.sh
    Terminal=true
```

```
sudo chmod a+x /usr/local/share/applications/showserialadapters.desktop
```

```
gedit /home/brecht/Programs/0-scripts/showSerialAdapters.sh
    #!/bin/bash
    dmesg | grep tty
    read
```

```
sudo chmod a+x /home/brecht/Programs/0-scripts/showSerialAdapters.sh
```
