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

rsync_TAG := 3.1.2
rsync_SRC := $(SW_SRC)rsync/
rsync_TMP := $(SW_SRC)rsync-$(rsync_TAG)/
rsync_TAR := $(SW_SRC)rsync-$(rsync_TAG).tar.gz
rsync_URL := 'https://qu1x.org/file/$(notdir $(rsync_TAR))'

ifneq ($(REQ_RSYNC),no)
sw: sw.rsync
sw.clean: sw.clean.rsync
sw.distclean: sw.distclean.rsync
endif

.PHONY: sw.rsync
sw.rsync: $(SW_BIN)rsync

.PHONY: sw.clean.rsync
sw.clean.rsync:
	test -e $(rsync_SRC) && cd $(rsync_SRC) && make clean || true
	rm -rf $(SW_BIN)rsync
	rmdir -p $(SW_BIN) 2>/dev/null || true

.PHONY: sw.distclean.rsync
sw.distclean.rsync:
	rm -rf $(rsync_SRC)

$(SW_BIN)rsync: $(rsync_SRC)rsync
	mkdir -p $(dir $@)
	cp $< $@

$(rsync_SRC)rsync: $(rsync_SRC)Makefile | $(SW_DST)
	+$(MAKE) -C $(rsync_SRC)

$(rsync_SRC)Makefile: $(rsync_SRC)configure
	cd $(rsync_SRC) && \
./configure --host=$(ABI) --prefix=$(CURDIR)/$(SW_USR) $(CFG_RSYNC)

$(rsync_SRC)configure: | $(rsync_SRC)
	touch $@

$(rsync_SRC): $(rsync_TAR)
	tar -C $(SW_SRC) -xzf $(rsync_TAR)
	rm $(rsync_TAR)
	mv $(rsync_TMP) $(rsync_SRC)

$(rsync_TAR): | $(SW_SRC)
	wget -P $(SW_SRC) $(rsync_URL)

