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

pugixml_TAG := 1.7.0
pugixml_SRC := $(SW_SRC)pugixml/
pugixml_TMP := $(SW_SRC)pugixml-$(pugixml_TAG)/
pugixml_TAR := $(SW_SRC)pugixml-$(pugixml_TAG).tar.xz
pugixml_URL := 'https://qu1x.org/file/$(notdir $(pugixml_TAR))'

ifneq ($(REQ_PUGIXML),no)
sw: sw.pugixml
sw.clean: sw.clean.pugixml
sw.distclean: sw.distclean.pugixml
endif

.PHONY: sw.pugixml
sw.pugixml: $(SW_LIB)libpugixml.so

.PHONY: sw.clean.pugixml
sw.clean.pugixml:
	test -e $(pugixml_SRC) && cd $(pugixml_SRC) && make clean || true
	rm -rf $(SW_INC)pugixml
	rmdir -p $(SW_INC) 2>/dev/null || true
	rm -rf $(SW_LIB)libpugixml.*
	rmdir -p $(SW_LIB) 2>/dev/null || true

.PHONY: sw.distclean.pugixml
sw.distclean.pugixml:
	rm -rf $(pugixml_SRC)

$(SW_LIB)libpugixml.so: $(pugixml_SRC).libs/libpugixml.so
	+$(MAKE) -C $(pugixml_SRC) install

$(pugixml_SRC).libs/libpugixml.so: $(pugixml_SRC)Makefile | $(SW_DST)
	+$(MAKE) -C $(pugixml_SRC)

$(pugixml_SRC)Makefile: $(pugixml_SRC)configure
	cd $(pugixml_SRC) && autoreconf -i && \
./configure --host=$(ABI) --prefix=$(CURDIR)/$(SW_USR) $(CFG_PUGIXML)

$(pugixml_SRC)configure: | $(pugixml_SRC)
	touch $@

$(pugixml_SRC): $(pugixml_TAR)
	tar -C $(SW_SRC) -xJf $(pugixml_TAR)
	rm $(pugixml_TAR)
	mv $(pugixml_TMP) $(pugixml_SRC)

$(pugixml_TAR): | $(SW_SRC)
	wget -P $(SW_SRC) $(pugixml_URL)

