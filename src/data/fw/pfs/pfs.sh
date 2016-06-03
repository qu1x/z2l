#! /bin/sh

### BEGIN INIT INFO
# Provides:          pfs
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: Persistent File System
### END INIT INFO

# This file is part of Zed Tool, see <https://qu1x.org/z2l>.
# 
# Copyright (c) 2016 Rouven Spreckels <n3vu0r@qu1x.org>
# 
# Zed Tool is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3
# as published by the Free Software Foundation on 19 November 2007.
# 
# Zed Tool is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with Zed Tool. If not, see <https://www.gnu.org/licenses>.

echo 'Opening CFG'
cfg=/mnt/cfg
mkdir $cfg
mount -o exec /dev/mmcblk0p1 $cfg

echo 'Linking PFS'
pfs=$cfg/root.pfs
cp -asf $pfs/. /

ssh=/home/root/.ssh
if [ -e $pfs$ssh ]; then
	echo 'Copying SSH'
	cp -R $pfs$ssh $(dirname $ssh)
	chmod -R u=rwX,g=,o= $(dirname $ssh)
fi
