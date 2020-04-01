# Awesome Arch (UEFI)

<p align="center"><img src="https://i.ibb.co/YQqPvzr/Archlinux-Logo.png"></p>

## Contents

1. [Into the plan](#into_the_plan)
2. [Web Sites](#web_sites)
3. [Installing Arch Linux](#installing_arch_linux)
4. [Adding a local repository](#adding_a_local_repository)

<a name="into_the_plan"></a>
## Into the plan

- [X] Write instructions for manual installation of Arch Linux
    - [X] LUKS on LVM
- [ ] Write an automatic installation script for Arch Linux

<a name="web_sites"></a>
## Web Sites:

* https://www.archlinux.org/  - Official website of Arch Linux
* https://wiki.archlinux.org/ - Official Arch Linux wiki

<a name="installing_arch_linux"></a>
## Installing Arch Linux

There are 2 options for installing Arch Linux:
* [Manual](https://github.com/KerroViT99/Awesome-Arch/blob/master/manuals/INSTALL_ARCH.md)
* Automatic (using a script) (script in development)

<a name="adding_a_local_repository"></a>
## Adding a local repository

In **/etc/pacman.conf** add:
```
[kerrovit-repo]
SigLevel = Optional TrustAll
Server = file:///path/to/kerrovit-repo/$arch
```
by replacing **/path/to/** with the path to the **kerrovit-repo** repository
