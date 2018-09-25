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

chrony_TAG := 3.4
chrony_SRC := $(SW_SRC)chrony/
chrony_TMP := $(SW_SRC)chrony-$(chrony_TAG)/
chrony_TAR := $(SW_SRC)chrony-$(chrony_TAG).tar.gz
chrony_URL := 'https://qu1x.org/file/$(notdir $(chrony_TAR))'

ifneq ($(REQ_CHRONY),no)
sw: sw.chrony
sw.clean: sw.clean.chrony
sw.distclean: sw.distclean.chrony
endif

.PHONY: sw.chrony
sw.chrony: $(SW_BIN)chronyd $(SW_BIN)chronyc

.PHONY: sw.clean.chrony
sw.clean.chrony:
	test -e $(chrony_SRC) && cd $(chrony_SRC) && make clean || true
	rm -rf $(SW_BIN)chronyd $(SW_BIN)chronyc
	rmdir -p $(SW_BIN) 2>/dev/null || true

.PHONY: sw.distclean.chrony
sw.distclean.chrony:
	rm -rf $(chrony_SRC)

$(SW_BIN)chronyd: $(chrony_SRC)chronyd
	mkdir -p $(dir $@)
	cp $< $@

$(SW_BIN)chronyc: $(chrony_SRC)chronyc
	mkdir -p $(dir $@)
	cp $< $@

$(chrony_SRC)chronyd $(chrony_SRC)chronyc: $(chrony_SRC)Makefile | $(SW_DST)
	+$(MAKE) -C $(chrony_SRC)

$(chrony_SRC)Makefile: $(chrony_SRC)configure
	cd $(chrony_SRC) && CC=arm-linux-gnueabihf-gcc \
./configure --host=$(ABI) --prefix=$(CURDIR)/$(SW_USR) \
--disable-shared $(CFG_CHRONY)

$(chrony_SRC)configure: | $(chrony_SRC)
	touch $@

$(chrony_SRC): $(chrony_TAR)
	tar -C $(SW_SRC) -xzf $(chrony_TAR)
	rm $(chrony_TAR)
	mv $(chrony_TMP) $(chrony_SRC)

$(chrony_TAR): | $(SW_SRC)
	wget -P $(SW_SRC) $(chrony_URL)

