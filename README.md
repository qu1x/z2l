> This file is part of Zed Tool, see <https://qu1x.org/z2l>.
> 
> Copyright (c) 2016, 2018 Rouven Spreckels <n3vu0r@qu1x.org>
> 
> Zed Tool is free software: you can redistribute it and/or modify
> it under the terms of the GNU Affero General Public License version 3
> as published by the Free Software Foundation on 19 November 2007.
> 
> Zed Tool is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> GNU Affero General Public License for more details.
> 
> You should have received a copy of the GNU Affero General Public License
> along with Zed Tool. If not, see <https://www.gnu.org/licenses>.

# Zed Tool

Workflow kit managing hardware, firmware, and software development.

# Installation

## Either getting a release

 1. Download stable source distribution tarball.

```sh
wget https://qu1x.org/file/z2l-1.0.0.tar.xz
```
 2. Extract and enter.

```sh
tar -xJf z2l-1.0.0.tar.xz
cd z2l-1.0.0
```

## Or getting a snapshot

 0. Install requirements.

```sh
sudo apt install git dh-autoreconf \
g++-arm-linux-gnueabihf libpugixml-dev picocom
sudo apt purge brltty
```

 1. Clone repository.

```sh
git clone https://github.com/qu1x/z2l.git
```

 2. Enter and generate latest source distribution.

```sh
cd z2l
./bootstrap
```

## Install one of them

 3. Configure, build, and install.

```sh
./configure --sysconfdir=/etc
make
sudo make install
```

 4. Keep to uninstall someday.

```sh
sudo make uninstall
```

## Install Xilinx Toolchain

 0. Install requirements.

```sh
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install tofrodos iproute2 gawk xvfb git make net-tools rlwrap \
libncurses5-dev tftpd zlib1g-dev zlib1g-dev:i386 libssl-dev flex bison \
libselinux1 gnupg wget diffstat chrpath socat xterm autoconf libtool-bin tar \
unzip texinfo build-essential libglib2.0-dev screen pax gzip
```

 1. Fix Xilinx PetaLinux 2018.2 installer by copying below `sed` wrapper to
`/usr/local/bin`. Remove or rename it after installation otherwise you will
encounter errors during `petalinux-build`. See [forum post](https://forums.xilinx.com/t5/Embedded-Linux/PetaLinux-2018-1-Install-Fails-on-Debian-Stretch/m-p/887733/highlight/true#M28391).

```sh
#! /bin/sh

# Remove newlines if called by the buggy Xilinx PetaLinux 2018.2 installer.
if [ "$2" = "s/^.*minimal-\(.*\)-toolchain.*/\1/" ] ; then
	/bin/sed "$@" | tr '\n' ' '
else
	/bin/sed "$@"
fi
```

 2. Finally, install it.

```sh
sudo mkdir /opt/Xilinx
sudo chown $USER: /opt/Xilinx
chmod +x petalinux-v2018.2-final-installer.run
mkdir -p /opt/Xilinx/PetaLinux/2018.2
./petalinux-v*-final-installer.run /opt/Xilinx/PetaLinux/2018.2
# Install Vivado 2018.2. Exceptionally, it's straightforward.
# For Zynq products you can get a free license from Xilinx.
mkdir ~/.z2l
echo "path/to/license/file.lic/or/licence/server/url" > ~/.z2l/hw.lic
```

 3. Tell Zed Tool how to source it if you chose different installation paths.

```sh
echo "/opt/Xilinx/PetaLinux/2018.2/settings.sh" > ~/.z2l/fw.src
echo "/opt/Xilinx/Vivado/2018.2/settings64.sh" > ~/.z2l/hw.src
```

# Usage

RTFM.

```sh
man z2l
```

# Version

z2l-1.0.0 <https://qu1x.org/z2l>

# License

GNU Affero General Public License version 3

# Authors

  * Copyright (c) 2016, 2018 Rouven Spreckels <n3vu0r@qu1x.org>
