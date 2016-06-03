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

ifneq ($(REQ_ZELSIUS),no)
sw: sw.zelsius
sw.clean: sw.clean.zelsius
sw.distclean: sw.distclean.zelsius
endif

.PHONY: sw.zelsius
sw.zelsius: $(SW_BIN)zelsius

.PHONY: sw.clean.zelsius
sw.clean.zelsius:
	rm -rf $(SW_BIN)zelsius
	rmdir -p $(SW_BIN) 2>/dev/null || true

.PHONY: sw.distclean.zelsius
sw.distclean.zelsius:

$(SW_BIN)zelsius: $(SW_Z2L)pkg/zelsius | $(SW_DST)
	mkdir -p $(dir $@)
	cp $< $@

