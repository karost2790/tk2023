

First memo
```
NV137 (GP107)|GeForce GTX (1050, 1050 Ti)|
Linux karost-arch 6.1.47-1-lts #1 SMP PREEMPT_DYNAMIC Wed, 23 Aug 2023 19:08:07 +0000 x86_64 GNU/Linux
nvidia-modprobe[
```


1. config pacman.conf. with sudo user
```
]$ vim /etc/pacman.conf

# add [community],[multilib]
[community]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

]$ sudo pacman -Syyu
```

2. install nvidia and other
```
]$ sudo pacman -S nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia lightdm

]$ cat /usr/lib/modprobe.conf
backlist nouveau
```

3. configure X11
```
vim /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
---
# add section
Section "OutputClass"
    Identifier "intel"
    MatchDriver "i915"
    Driver "modesetting"
EndSection

Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "PrimaryGPU" "yes"
    ModulePath "/usr/lib/nvidia/xorg"
    ModulePath "/usr/lib/xorg/modules"
EndSection
---


# setting display
/etc/lightdm/display_setup.sh
---
#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
---
# this file executable
chmod +x /etc/lightdm/display_setup.sh

# config lightdm
vim /etc/lightdm/lightdm.conf
---
[Seat:*]
display-setup-script=/etc/lightdm/display_setup.sh
---

# nvidia screen tearing
sudo vim /etc/modprobe.d/nvidia-drm-nomodeset.conf
---
options nvidia-drm modeset=1
---

# make initial
sudo mkinitcpio -P

# test nvidia driver
nvidia-smi
nvidia-settings

# graphic test
sudo pacman -S virtualgl
glxspheres64


```
