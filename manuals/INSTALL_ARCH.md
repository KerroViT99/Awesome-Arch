# Installation guide for Arch Linux (in development)

### Preparing for installation

Set the keyboard layout:
```
loadkeys en
```

Verify the boot mode:
```
ls /sys/firmware/efi/efivars
```
If the output of this command is not empty, the system is loaded in UEFI mode.
Otherwise the system is loaded in BIOS mode.

### Setting up an Internet connection

* WiFi:
```
wifi-menu
```

* Cable connection

Check your Internet connection:
```
ping archlinux.org
```

### Setting the date and time

Update the system clock:
```
timedatectl set-ntp true
timedatectl set-timezone <your_timezone>
hwclock --systohc
```

Check that the time setting is correct:
```
timedatectl
```

### Partition the disks

* LVM on LUKS:

| Partition | Type             | Size                 | Description    |
|:----------|:-----------------|:---------------------|:---------------|
| sda1      | EFI System       | 500 MB               | Boot partition |
| sda2      | Linux filesystem | Remaining free space | LVM partition  |

To create partitions, you can use any tool that is convenient for you, such as **cfdisk**:
```
cfdisk /dev/sda
```

Format the LUKS partition:
```
cryptsetup luksFormat /dev/sda2
```

Open the LUKS partition:
```
cryptsetup open /dev/sda2 cryptlvm
```

Create LVM physical volume:
```
pvcreate /dev/mapper/cryptlvm
```

Create LVM volume group:
```
vgcreate vg00 /dev/mapper/cryptlvm
```

Create LVM logical volumes:

| Logical Volume | Size            | Description    |
|:---------------|:----------------|:---------------|
| swap           | Amount of RAM   | Swap partition |
| root           | 25 GB           | Root partition |
| home           | Remaining space | Home partition |

```
lvcreate -n swap -L <Amount_of_RAM> vg00
lvcreate -n root -L 25G vg00
lvcreate -n home -l 100%FREE vg00
```

Format the partitions:
```
mkfs.fat -F32 /dev/sda1
mkswap /dev/mapper/vg00-swap
mkfs.ext4 /dev/mapper/vg00-root
mkfs.ext4 /dev/mapper/vg00-home
```

Mount the file systems:
```
swapon /dev/mapper/vg00-swap
mount /dev/mapper/vg00-root /mnt
mkdir /mnt/home
mount /dev/mapper/vg00-home /mnt/home
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

Check that the mount points are correct:
```
lsblk
```

Install essential packages:
```
pacstrap /mnt base base-devel linux linux-firmware lvm2 sudo nano
```

If you need a WiFi connection (**wifi-menu**), run the following command:
```
pacstrap /mnt dhcpcd wpa_supplicant netctl dialog
```

Generate an **fstab** file:
```
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot to your system

Log in to the created environment:
```
arch-chroot /mnt
```

## Configuration your system

### Time zone

Set the time zone:
```
ln -sf /usr/share/zoneinfo/<your_timezone> /etc/localtime
```

Generate an **/etc/adjtime** file:
```
hwclock --systohc
```

### Localization

Uncomment en_US.UTF-8 UTF-8 and other needed locales in /etc/locale.gen, and generate them with:
```
locale-gen
```
```
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```
```
echo "KEYMAP=ru\nFONT=cyr-sun16" > /etc/vconsole.conf
```

### Network configuration

```
echo <hostname> > /etc/hostname
```
```
echo "127.0.0.1  localhost\n::1 localhost\n127.0.1.1   <hostname>.localdomain  <hostname>" >> /etc/hosts
```

### Initramfs

Configure hooks in /etc/mkinitcpio.conf as follows:

HOOKS=(base **udev** autodetect **keyboard keymap** consolefont modconf block **encrypt lvm2** filesystems fsck)

And recreate the initramfs image:
```
mkinitcpio -P
```

### Root password

Set the root password:
```
passwd root
```
### Installing systemd-boot

```
bootctl install
```

### Reboot

```
exit
umount -R /mnt
reboot
```
