#!/bin/bash

echo -n "your cmdline" > /tmp/cmdline

objcopy \
--add-section .osrel="/usr/lib/os-release" --change-section-vma .osrel=0x20000 \
--add-section .cmdline="/tmp/cmdline" --change-section-vma .cmdline=0x30000 \
--add-section .splash="/dev/null" --change-section-vma .splash=0x40000 \
--add-section .linux="/boot/vmlinuz-linux" --change-section-vma .linux=0x2000000 \
--add-section .initrd="/boot/initramfs-linux.img" --change-section-vma .initrd=0x3000000 \
"/usr/lib/systemd/boot/efi/linuxx64.efi.stub" "/root/linux.efi"
