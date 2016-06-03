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

fsio_TAG := 1.0.0
fsio_SRC := $(SW_SRC)fsio/
fsio_TMP := $(SW_SRC)fsio-$(fsio_TAG)/
fsio_TAR := $(SW_SRC)fsio-$(fsio_TAG).tar.xz
fsio_URL := 'https://qu1x.org/file/$(notdir $(fsio_TAR))'

ifneq ($(REQ_FSIO),no)
sw: sw.fsio
sw.clean: sw.clean.fsio
sw.distclean: sw.distclean.fsio
endif

.PHONY: sw.fsio
sw.fsio: $(SW_LIB)libfsio.so | sw.pugixml

.PHONY: sw.clean.fsio
sw.clean.fsio:
	test -e $(fsio_SRC) && cd $(fsio_SRC) && make clean || true
	rm -rf $(SW_INC)fsio
	rmdir -p $(SW_INC) 2>/dev/null || true
	rm -rf $(SW_LIB)libfsio.*
	rmdir -p $(SW_LIB) 2>/dev/null || true

.PHONY: sw.distclean.fsio
sw.distclean.fsio:
	rm -rf $(fsio_SRC)

$(SW_LIB)libfsio.so: $(fsio_SRC).libs/libfsio.so
	+$(MAKE) -C $(fsio_SRC) install

$(fsio_SRC).libs/libfsio.so: $(fsio_SRC)Makefile | $(SW_DST)
	+$(MAKE) -C $(fsio_SRC)

$(fsio_SRC)Makefile: $(fsio_SRC)configure
	cd $(fsio_SRC) && \
CPPFLAGS="-I$(CURDIR)/$(SW_INC)" \
LDFLAGS="-L$(CURDIR)/$(SW_LIB)" \
./configure --host=$(ABI) --prefix=$(CURDIR)/$(SW_USR) \
--sysconfdir=$(CURDIR)/$(SW_ETC) $(CFG_FSIO)

$(fsio_SRC)configure: | $(fsio_SRC)
	touch $@

$(fsio_SRC): $(fsio_TAR)
	tar -C $(SW_SRC) -xJf $(fsio_TAR)
	rm $(fsio_TAR)
	mv $(fsio_TMP) $(fsio_SRC)

$(fsio_TAR): | $(SW_SRC)
	wget -P $(SW_SRC) $(fsio_URL)


