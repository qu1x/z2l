> This file is part of Zed Tool, see <https://qu1x.org/z2l>.
> 
> Copyright (c) 2016 Rouven Spreckels <n3vu0r@qu1x.org>
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

Zed Tool
========

Workflow kit managing hardware, firmware, and software development.

Installation
============

Either getting a release
------------------------

1. Download stable source distribution tarball.

		wget https://qu1x.org/file/z2l-1.0.0.tar.xz

2. Extract and enter.

		tar -xJf z2l-1.0.0.tar.xz
		cd z2l-1.0.0

Or getting a snapshot
---------------------

1. Clone repository.

		git clone https://github.com/qu1x/z2l.git

2. Enter and generate latest source distribution.

		cd z2l
		autoreconf -i

Installing one of them
----------------------

3. Configure, build, and install.

		./configure --sysconfdir=/etc
		make
		sudo make install

4. Keep to uninstall someday.

		sudo make uninstall

Usage
=====

RTFM:

		man z2l

Version
=======

z2l-1.0.0 <https://qu1x.org/z2l>

License
=======

GNU Affero General Public License version 3

Authors
=======

* Copyright (c) 2016 Rouven Spreckels <n3vu0r@qu1x.org>

