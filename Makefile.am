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

bin_SCRIPTS = $(srcdir)/src/bin/z2l
z2l_bin = $(srcdir)/src/bin/z2l.mk
$(srcdir)/src/bin/z2l: $(z2l_bin)
	$(SED) 's,#datadir#,$(datadir),g' $< > $@
	chmod +x $@

dist_bin_SCRIPTS = $(srcdir)/src/bin/vivado \
$(srcdir)/src/bin/petalinux-boot \
$(srcdir)/src/bin/petalinux-build \
$(srcdir)/src/bin/petalinux-config \
$(srcdir)/src/bin/petalinux-create \
$(srcdir)/src/bin/petalinux-package \
$(srcdir)/src/bin/petalinux-util

tcldir = $(datadir)/z2l/hw/tcl
dist_tcl_DATA = $(srcdir)/src/data/hw/tcl/*

pfsdir = $(datadir)/z2l/fw/pfs
dist_pfs_DATA = $(srcdir)/src/data/fw/pfs/*

pkgdir = $(datadir)/z2l/sw/pkg
dist_pkg_DATA = $(srcdir)/src/data/sw/pkg/*

bash_completiondir = $(sysconfdir)/bash_completion.d
bash_completion_DATA = $(srcdir)/src/bash_completion/z2l
z2l_bash_completion = $(srcdir)/src/bash_completion/z2l.sh
$(srcdir)/src/bash_completion/z2l: $(z2l_bash_completion)
	$(SED) 's,#datadir#,$(datadir),g' $< > $@

dist_man_MANS = $(srcdir)/src/man/z2l.1

EXTRA_DIST = $(z2l_bin) $(z2l_bash_completion)

CLEANFILES = $(bin_SCRIPTS) $(bash_completion_DATA)
