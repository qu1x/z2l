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

si53xx_TAG := 1.0.0
si53xx_SRC := $(SW_SRC)si53xx/
si53xx_TMP := $(SW_SRC)si53xx-$(si53xx_TAG)/
si53xx_TAR := $(SW_SRC)si53xx-$(si53xx_TAG).tar.xz
si53xx_URL := 'https://qu1x.org/file/$(notdir $(si53xx_TAR))'

ifeq ($(REQ_SI53XX),yes)
sw: sw.si53xx
sw.clean: sw.clean.si53xx
sw.distclean: sw.distclean.si53xx
endif

.PHONY: sw.si53xx
sw.si53xx: $(SW_BIN)si53xx

.PHONY: sw.clean.si53xx
sw.clean.si53xx:
	test -e $(si53xx_SRC) && cd $(si53xx_SRC) && make clean || true
	rm -rf $(SW_BIN)si53xx
	rmdir -p $(SW_BIN) 2>/dev/null || true

.PHONY: sw.distclean.si53xx
sw.distclean.si53xx:
	rm -rf $(si53xx_SRC)

$(SW_BIN)si53xx: $(si53xx_SRC)si53xx
	mkdir -p $(dir $@)
	cp $< $@

$(si53xx_SRC)si53xx: $(si53xx_SRC)Makefile | $(SW_DST)
	+$(MAKE) -C $(si53xx_SRC)

$(si53xx_SRC)Makefile: $(si53xx_SRC)configure
	cd $(si53xx_SRC) && autoreconf -i && \
./configure --host=$(ABI) --prefix=$(CURDIR)/$(SW_USR) \
--disable-shared $(CFG_SI53XX)

$(si53xx_SRC)configure: | $(si53xx_SRC)
	touch $@

$(si53xx_SRC): $(si53xx_TAR)
	tar -C $(SW_SRC) -xJf $(si53xx_TAR)
	rm $(si53xx_TAR)
	mv $(si53xx_TMP) $(si53xx_SRC)

$(si53xx_TAR): | $(SW_SRC)
	wget -P $(SW_SRC) $(si53xx_URL)

