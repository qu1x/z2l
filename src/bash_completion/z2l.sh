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

_z2l_pkg()
{
	sed '/\.mk$/!d;s/\(.\+\)\.mk$/sw.\1 sw.clean.\1 sw.distclean.\1/' \
		<(2>/dev/null ls $z2l/sw/pkg $PWD/src/sw)
}

_z2l()
{
	local z2l=#datadir#/z2l

	local cur=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=( $(compgen -W "\
		all clean distclean\
		hw fw sw\
		$(_z2l_pkg)\
		hw.clean fw.clean sw.clean\
		hw.distclean fw.distclean sw.distclean\
		hw.edit fw.edit\
		fw.edit.sys fw.edit.rfs fw.edit.lnx fw.edit.ubl fw.edit.plt fw.edit.dts
		fw.load fw.save fw.diff\
		tty ssh\
		sftp\
		push pull\
		dry-push dry-pull\
		reboot poweroff zelsius\
	" -- $cur) )
}

complete -F _z2l z2l
