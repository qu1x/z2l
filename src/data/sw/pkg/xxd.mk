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

xxd_TAG := 1.10.0
xxd_SRC := $(SW_SRC)xxd/
xxd_TMP := $(SW_SRC)xxd-$(xxd_TAG)/
xxd_TAR := $(SW_SRC)xxd-$(xxd_TAG).tar.xz
xxd_URL := 'https://qu1x.org/file/$(notdir $(xxd_TAR))'

ifneq ($(REQ_XXD),no)
sw: sw.xxd
sw.clean: sw.clean.xxd
sw.distclean: sw.distclean.xxd
endif

.PHONY: sw.xxd
sw.xxd: $(SW_BIN)xxd

.PHONY: sw.clean.xxd
sw.clean.xxd:
	test -e $(xxd_SRC) && cd $(xxd_SRC) && make clean || true
	rm -rf $(SW_BIN)xxd
	rmdir -p $(SW_BIN) 2>/dev/null || true

.PHONY: sw.distclean.xxd
sw.distclean.xxd:
	rm -rf $(xxd_SRC)

$(SW_BIN)xxd: $(xxd_SRC)xxd
	mkdir -p $(dir $@)
	cp $< $@

$(xxd_SRC)xxd: $(xxd_SRC)Makefile | $(SW_DST)
	+$(MAKE) -C $(xxd_SRC)

$(xxd_SRC)Makefile: $(xxd_SRC)configure
	cd $(xxd_SRC) && autoreconf -i && \
./configure --host=$(ABI) --prefix=$(CURDIR)/$(SW_USR) \
--disable-shared $(CFG_XXD)

$(xxd_SRC)configure: | $(xxd_SRC)
	touch $@

$(xxd_SRC): $(xxd_TAR)
	tar -C $(SW_SRC) -xJf $(xxd_TAR)
	rm $(xxd_TAR)
	mv $(xxd_TMP) $(xxd_SRC)

$(xxd_TAR): | $(SW_SRC)
	wget -P $(SW_SRC) $(xxd_URL)

