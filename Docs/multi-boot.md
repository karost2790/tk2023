1. Check windows partition

```c
diskmgm
```

#### sda 0 Recovery
sda 1 primary
sda 2  window system partition
sda 6  Acrchlinux  root :/
sda 7  /home
sda 8 swamp

Shrink Volume on driver C to add new sprint new partition  

2. Download archlinux and build boot usb
3. Bot archlinux from windows 

```c
# search windows 'boot'
select change advance-up option 
select Restart now
select icon Use a device
select archlinux boot device

# system will archlinux boot usb
select 1 option x86.64(uefi) cd
```

4. Install Archlinux
```bash
# if text size is too small then setfont
~# setfont ter-132n

# check network  device 
~# ip -c a

# test internet access
ping archlinux.org -c 5

# if need to use WIFI ############################ 

~# wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
~# iwctl
device list
station wlan0 scan
station wlan0 get-networks
	xxx
station wlan0 connect "xxx"
[input passphase:]xxxxxxxxxx
[exit ^D]
###################################################

# verify efi boot
ls /sys/firmware/efi/efivars/


# load keyboard
~# ls /usr/share/kbd/keymaps/i386/qwerty/us.map.gz
~# loadkeys /usr/share/kdb/keymaps/i386/qwerty/us.map.gz

# set time date
~# timedatectl status
~# timedatectl list-timezones
~# timedatectl set-ntp true
~# timedatectl set-timezone Asia/Bangkok


```

5. Manage partition
```
# create linux file system and swap partition for / and # /home after windows partition
~# lsblk

# check hardisk
~# hdparm -i /dev/sda

# create partition
~# cfdisk /dev/nvme0n1

# idea partition may be like this

/dev/nvme0n1p6 /      20 Gb -> /mnt
/dev/nvme0n1p7 /home  90 Gb -> /mnt/home
/dev/nvme0n1p8 /swap  10 Gb

# format  linux system partition
~# mkfs.ext4 /dev/nvme0n1p6
~# mkfs.ext4 /dev/nvme0n1p7

# format swap partition
~# mkswap /dev/nvme0n1p8
~# swapon /dev/nvme0n1p8

# mount dev to mnt
~# mount /dev/nvme0n1p6 /mnt
~# mkdir /mnt/home
~# mount /dev/nvme0n1p7 /mnt/home

# backup mirror list
~# cp /etc/pcman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Synchronize package database
~# pacman -Sy
~# pacman -S pacman-contrib -y

# rank 10 fastest mirror servers, and update
~# rankmirrors -n 10 /etc/pacman.d/mirrorlist.bak > mirrorlist
~# cat /etc/mirror.d/mirrorlist
```

6. install base linux , lux-firmware into , other stuff into  /mnt
```
~# pacstrap -i /mnt base base-devel linux linux-lts linux-headers linux-firmware intel-ucode [or amd-ucode] nano vim git neofetch networkmanager dhcpcd pulseaudio bluez terminus-font  wpa_supplicant dialog

# in take space about 1GB and take time 10-15 min.
.......
~# ls /mnt

# create fstab to make auto mount when start 
# server next time
~# genfstab -U /mnt >> /mnt/etc/fstab 
~# cat /mnt/etc/fstab

# change to /root environment
~# arch-chroot /mnt /bin/bash

# you will see prompt cursor change to root 
[root@server]  /]#
/]# lsblk

# setup root password make sure you never forget it.
/]# passwd
[enter and re-enter password]

# create working user account
/]# useradd -m [username]
/]# passwd [username]
# add group to working user
/]# usermod -aG wheel,storage,power [username]


/]# EDITOR=vim visudo
uncomment this line
%wheel ALL=(ALL) ALL
Defaults timestamp_timeout=0




[share timezone]
/]# ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
/]# hwclock --systohc
/]# vim /etc/locale.gen
[uncommane en_US.UTF-8 UTF-8]
# then generate locale 
/]# locale-gen
# make locale config file
/]# echo LANG=en_US.UTF-8 > /etc/locale.conf
# make environment LANG
/]# export LANG=en_US.UTF-8


#setup host name
/]# echo [SeverName] > /etc/hostname
/]# vim /etc/hosts
127.0.0.1      localhost
::1            localhost
127.0.1.1      [Sername].localdomain     localhost
#127.0.1.1      [Sername].localdomain     [hostname]

go to 7





# setup network


```

7. deal with boot manager



```
# check windoows boot partition localtion ( see size about 100 M)
lsblk
# /dev/nvme0n1p2 

# check current /boot direcotory
]# ls -l /boot


# mount windows boot partition into linux /boot
]# mkdir /boot/efi
]# mount /dev/nvme0n1p2  /boot/efi

]# lsblk

# install grub
]# pacman -S grub efibootmgr dosfstools mtools -y

# edit uncomment grub default  file
]# vim /etc/default/grub
GRUB_DISABLE_OS_PROBER=false

# install os-prober
/]# pacman -S os-prober

grub-install --target=x86_64-efi --bootloader-id=grub-uefi-01 --efi-directory=/boot/efi --recheck


grub-mkconfig -o /boot/grub/grub.cfg

Found Windows Boot Manager on /dev/sda2@/EFI/Microsoft/Boot/bootmgfw
/]# ls /boot/efi/EFI/grub_uefi/grubx64.efi

/]# systemctl enable dhcpcd.service
/]# systemctl enable NetworkManager.service
/]# exit

umount -lR /mnt

reboot






```


