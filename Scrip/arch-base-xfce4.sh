
# Setfont if it look too small
setfont ter-132n


# Start network time synchronization
timedatectl set-ntp true
timedatectl set-timezone Asia/Bangkok
loadkeys /usr/share/kdb/keymaps/i386/qwerty/us.map.gz

## manual section for partition setup
# cfdisk /dev/disk_id # create partition
# 1G        /dev/nvme1n1p1      /mnt/boot/efi
# 4G        /dev/nvme1n1p2      [SWAP]
# 50G       /dev/nvme1n1p3      /mnt
# remain    /dev/nvme1n1p4      /mnt/home

## format partition
# format /boot parttion
# if there has other boot system in this partition do not format it
mkfs.fat -F 32 /dev/nvme1n1p1

# format swap partition
mkswap /dev/nvme1n1p2
swapon /dev/nvme1n1p2

# format linux system partition in /mnt and /mnt/home
mkfs.ext4 /dev/nvme1n1p3
mkfs.ext4 /dev/nvme1n1p4

## mount disk to system path
mount /dev/nvme1n1p3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme1n1p1 /mnt/boot/efi

mkdir /mnt/home
mount /dev/nvme1n1p4 /mnt/home

## install system software the less is the battter for making first time boot
pacstrap /mnt base base-devel linux linux-lts linux-firmeare git vim nano wget

## generate file system table for next time boot and make auto mount partition
genfstab -U /mnt >> /mnt/etc/fstab

# chage to /root  mount
arch-chroot /mnt

# setup local time to the system
ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
hwclock --systohc

# select locale font to generate # use / to search the one you want and uncomment 
vim /etc/locale.gen  # uncomment en_US.UTF-8 UTF-8
locale-gen 
echo "LANG=en_US.UTF-8" > /etc/locale.conf

#setup host name
echo "arch_k9" > /etc/hostname

echo "127.0.0.1      localhost" > /etc/hosts
echo "::1            localhost" > /etc/hosts
echo "127.0.1.1      arch_k9.localdomain     localhost" > /etc/hosts

#install dhcpcd and enable to working in backgroud mode
pacman -S dhcpcd networkmanager
systemctl enable dhcpd.service
systemctl enable NetworkManager.service

# change root password
passwd  # iput new root password two time

# create working user
useradd -m thanit
passwd thanit

# add group to working user
usermod -aG wheel,users,audio,video [username]

EDITOR=vim visudo
# uncomment this line
%wheel ALL=(ALL) ALL
Defaults timestamp_timeout=30

## install and config boot system
pacman -S grub efibootmgr dosfstools mtools -y

## if need to make dual boot with windows boot system 
# install os-prober 
pacman -S os-prober

# config option 
vim /etc/default/grub
GRUB_DISABLE_OS_PROBER=false   # uncomment this line 

# setup boot system
grub-install --target=x86_64-efi --bootloader-id=EFI-ARCH-01 --efi-directory=/boot/efi --recheck

grub-mkconfig -o /boot/grub/grub.cfg

# if !NOT Found Windows Boot Manager on /dev/sda2@/EFI/Microsoft/Boot/bootmgfw
# then next time boot, umount /boot/efi and mount again with windows boot partition
# and retry grub-mkconfig

# reboot system 
exit
umount -lR /mnt
reboot

## if success you will see a new boot menu from your system select the first one
# login as root  

# updte package list
pacman -Syyu

# install font 
pacman -S terminus-font
setfont ter-d28b.psf.gz

# install sudo
pacman -S sudo

## start install XFCE4 with all default option
pacman -S xorg xfce4 alacritty
packma -S lightdm lightdm-gtk-greeter

systemctl enable lightdm

## start XFCE4  taadaaa.....
systemctl start lightdm

## XFCE4 UI start
# login as user 
# open console  if ui look smaller then monitor

xrandr -s 1920x1080

## install yay
mkdir repo
cd repo
git clone https://aur.archlinux.org/yay.git

cd yay
makepkg -si

yay -Syyu

## that's it ###############################################















