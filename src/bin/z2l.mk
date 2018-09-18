#! /usr/bin/make -f

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

####
###
##
# Tweaks
##
###
####

Z2L := #datadir#/z2l/

include z2l.mk
z2l.mk:
	$(error Please enter your Zed Tool project top directory)

ifndef Z2L
Z2L := $(error Please specify Zed Tool data directory)
endif

ifndef ABI
ABI := arm-linux-gnueabi
endif

ifndef HW_PRJ
HW_PRJ := $(notdir $(CURDIR))
endif
ifndef HW_TOP
HW_TOP := $(subst -,_,$(HW_PRJ))
endif

ifndef EDITOR
EDITOR := vi
endif

ifndef TTY_PORT
TTY_PORT := /dev/ttyUSB0
endif
ifndef TTY_BAUD
TTY_BAUD := 115200
endif

ifndef SSH_USER
SSH_USER := root
endif
ifndef SSH_HOST
SSH_HOST := zed0
endif
ifndef SSH_CMDS
SSH_CMDS := reboot poweroff zelsius
endif

# MASK of PATH components to be ignored by file listing functions
IGN_MASK := ~%

####
###
##
# File listing functions
#
# PATH and FILE are file paths with and without trailing slash, respectively.
# PATH and FILE represent a directory and a non-directory file, respectively.
##
###
####

# $(call type,FILE)
#
# FILE: Return FILE if non-dir, PATH=FILE/ if dir, or NONE if not existing.
type = $(patsubst %/.,%/,$(firstword $(wildcard $1/. $1)))

# $(call dump,NONE|PATH|FILE)
#
# NONE: Return flat content of $(CURDIR) without trailing slash for dirs.
# PATH: Return flat content of PATH without trailing slash for dirs.
# FILE: Return NONE.
dump = $(filter-out $1$(IGN_MASK),$(wildcard $(filter %/* *,$1*)))

# $(call list,NONE|PATH|FILE)
#
# NONE: Return sorted flat content of $(CURDIR) with trailing slash for dirs.
# PATH: Return sorted flat content of PATH with trailing slash for dirs.
# FILE: Return NONE.
list = $(sort $(foreach item,$(dump),$(call type,$(item))))

# $(call tree,NONE|PATH|FILE)
#
# NONE: Return sorted deep content of $(CURDIR) with trailing slash for dirs.
#       There is a leading whitespace, removable with $(strip STRING).
# PATH: Return sorted deep content of PATH with trailing slash for dirs.
# FILE: Return FILE regardless of its existence.
tree = $1 $(foreach node,$(list),$(call $(0),$(node)))

####
###
##
# Project structure
##
###
####

SSH := $(SSH_USER)@$(SSH_HOST)

SSH_PATH := $$PATH:/usr/sbin:/sbin

SSH_SYNC := -rLchPe ssh --partial-dir=.rsync --delete

CFG := cfg/

CFG_SRC := $(CFG)
CFG_DST := $(SSH):/mnt/$(CFG)

SRC := src/
DST := dst/

HW := hw/
FW := fw/
SW := sw/

HW_Z2L := $(Z2L)$(HW)
HW_SRC := $(SRC)$(HW)
HW_DST := $(DST)$(HW)

FW_Z2L := $(Z2L)$(FW)
FW_SRC := $(SRC)$(FW)
FW_DST := $(DST)$(FW)

SW_Z2L := $(Z2L)$(SW)
SW_SRC := $(SRC)$(SW)
SW_DST := $(CFG_SRC)root.pfs/

HW_JOU := $(HW_DST)$(HW_PRJ).jou
HW_LOG := $(HW_DST)$(HW_PRJ).log

HW_BIT_SRC := $(call tree,$(HW_SRC))
HW_BIT_DST := $(HW_DST)$(HW_PRJ).runs/impl_1/$(HW_TOP).bit

HW_HDF_SRC := $(wildcard $(HW_DST)$(HW_PRJ).srcs/sources_1/bd/*/*.bd)
HW_HDF_DST := $(HW_DST)$(HW_PRJ).sdk/$(HW_TOP).hdf

FW_HDF_SRC := $(HW_HDF_DST)
FW_HDF_DST := $(FW_DST)subsystems/linux/hw-description/system.hdf

FW_PFS_SRC := $(FW_Z2L)pfs/Makefile $(FW_Z2L)pfs/pfs.sh
FW_PFS_DST := $(FW_DST)components/apps/pfs/

FW_SYS_SRC := $(FW_SRC)system
FW_SYS_DST := $(FW_DST)subsystems/linux/config

FW_RFS_SRC := $(FW_SRC)rootfs
FW_RFS_DST := $(FW_DST)subsystems/linux/configs/rootfs/config

FW_LNX_SRC := $(FW_SRC)kernel
FW_LNX_DST := $(FW_DST)subsystems/linux/configs/kernel/config

FW_UBL_SRC := $(FW_SRC)u-boot
FW_UBL_DST := $(FW_DST)subsystems/linux/configs/u-boot/config

FW_PLT_SRC := $(FW_SRC)u-boot.h
FW_PLT_DST := $(FW_DST)subsystems/linux/configs/u-boot/platform-top.h

FW_DTS_SRC := $(FW_SRC)system.dts
FW_DTS_DST := $(FW_DST)subsystems/linux/configs/device-tree/system-top.dts

FW_CFG_SRC := \
$(FW_DTS_SRC) $(FW_PLT_SRC) $(FW_UBL_SRC) \
$(FW_LNX_SRC) $(FW_RFS_SRC) $(FW_SYS_SRC)

FW_CFG_DST := \
$(FW_DTS_DST) $(FW_PLT_DST) $(FW_UBL_DST) \
$(FW_LNX_DST) $(FW_RFS_DST) $(FW_SYS_DST)

FW_BIN_DST := $(CFG_SRC)boot.bin

FW_ITB_SRC := $(FW_HDF_DST) $(FW_CFG_DST)
FW_ITB_DST := $(CFG_SRC)root.itb

HW_CMD := vivado -mode batch -source
HW_ARG := -appjournal -journal $(HW_JOU) -applog -log $(HW_LOG) \
-tclargs $(HW_SRC) $(HW_DST) $(HW_PRJ) $(HW_TOP)

HW_GUI_TCL := $(HW_Z2L)tcl/gui.tcl
HW_DST_TCL := $(HW_Z2L)tcl/dst.tcl
HW_BIT_TCL := $(HW_Z2L)tcl/bit.tcl

SW_PKG := $(SW_Z2L)pkg/
SW_ETC := $(SW_DST)etc/
SW_USR := $(SW_DST)usr/
SW_BIN := $(SW_USR)bin/
SW_INC := $(SW_USR)include/
SW_LIB := $(SW_USR)lib/

log = @printf '\n'$1'\n\n'

####
###
##
# Standard goals
##
###
####

.SECONDARY:

.DEFAULT_GOAL := all
.PHONY: all
all: hw fw sw

.PHONY: install
install: $(HOME)/.z2l/fw.src $(HOME)/.z2l/hw.src $(HOME)/.z2l/hw.lic

$(HOME)/.z2l/hw.lic: | $(HOME)/.z2l
	printf "port@host" > $@

$(HOME)/.z2l/hw.src: | $(HOME)/.z2l
	printf "/opt/Xilinx/Vivado/*/settings64.sh" > $@

$(HOME)/.z2l/fw.src: | $(HOME)/.z2l
	printf "/opt/Xilinx/petalinux-v*-final/settings.sh" > $@

$(HOME)/.z2l:
	mkdir -p $@

.PHONY: clean
clean: sw.clean fw.clean hw.clean

.PHONY: distclean
clean: sw.distclean fw.distclean hw.distclean

####
###
##
# Hardware rules
##
###
####

.PHONY: hw.edit
hw.edit: | $(HW_DST)
	$(HW_CMD) $(HW_GUI_TCL) $(HW_ARG)

.PHONY: hw
hw: $(HW_BIT_DST) $(HW_HDF_DST)

# Tweak: Export already written HDF to SDK.
$(HW_HDF_DST): $(HW_HDF_SRC) | $(HW_BIT_DST)
	cp $(HW_BIT_DST:.bit=.hdf) $@

# Tweak: Also write HDF but do not export to SDK.
$(HW_BIT_DST): $(HW_BIT_SRC) $(HW_HDF_SRC) | $(HW_DST)
	$(HW_CMD) $(HW_BIT_TCL) $(HW_ARG)

$(HW_DST):
	$(HW_CMD) $(HW_DST_TCL) $(HW_ARG)

# A following hw will trigger a rebuild.
.PHONY: hw.clean
hw.clean:
	rm -f $(HW_BIT_DST) $(HW_HDF_DST) $(HW_LOG) $(HW_JOU)

# Cleans the higher-level project. A following hw will not trigger a rebuild.
.PHONY: hw.distclean
hw.distclean:
	rm -rf $(HW_DST)

####
###
##
# Firmware rules
##
###
####

.PHONY: fw
fw: $(FW_ITB_DST) $(FW_BIN_DST)

# Creates boot binary locally, option -o just copies over.
$(FW_BIN_DST): $(HW_BIT_DST) $(FW_ITB_DST) | $(CFG_SRC)
	petalinux-package --boot --fpga $(HW_BIT_DST) --u-boot \
	-p $(FW_DST) --force -o $@

$(FW_ITB_DST): $(FW_DST)images/linux/root.itb
	cp $< $@ # Image must be named root.itb twice!

$(FW_DST)images/linux/root.itb: $(FW_ITB_SRC) | $(CFG_SRC)
	petalinux-build -v -p $(FW_DST)

# Since this will invoke petalinux-config like fw.edit.sys does, use it to
# actually change image name from image.ub to root.itb at both config entries.
# In case of a following fw.load, just exit.
$(FW_HDF_DST): $(FW_HDF_SRC) | $(FW_DST)
	petalinux-config --get-hw-description=$(dir $(FW_HDF_SRC)) -p $(FW_DST)

$(FW_CFG_DST): | $(FW_DST)

$(FW_DST): | $(FW_HDF_SRC)
	cd $(DST) && petalinux-create -t project --template zynq -n $(FW)
	petalinux-create -t apps -n pfs --enable -p $(FW_DST)
	rm $(FW_PFS_DST)README $(FW_PFS_DST)pfs.c
	cp $(FW_PFS_SRC) $(FW_PFS_DST)
	test -e $(FW_SYS_SRC) && cp $(FW_SYS_SRC) $(FW_SYS_DST) || true
	test -e $(FW_RFS_SRC) && cp $(FW_RFS_SRC) $(FW_RFS_DST) || true
	test -e $(FW_LNX_SRC) && cp $(FW_LNX_SRC) $(FW_LNX_DST) || true
	test -e $(FW_UBL_SRC) && cp $(FW_UBL_SRC) $(FW_UBL_DST) || true
	test -e $(FW_PLT_SRC) && cp $(FW_PLT_SRC) $(FW_PLT_DST) || true
	test -e $(FW_DTS_SRC) && cp $(FW_DTS_SRC) $(FW_DTS_DST) || true
	petalinux-config --get-hw-description=$(dir $(FW_HDF_SRC)) -p $(FW_DST)

.PHONY: fw.edit
fw.edit: | $(FW_CFG_DST)
	petalinux-config -c all -p $(FW_DST)
	$(EDITOR) $(FW_PLT_DST)
	$(EDITOR) $(FW_DTS_DST)

.PHONY: fw.edit.sys
fw.edit.sys: | $(FW_SYS_DST)
	petalinux-config -p $(FW_DST)

.PHONY: fw.edit.rfs
fw.edit.rfs: | $(FW_RFS_DST)
	petalinux-config -c rootfs -p $(FW_DST)

.PHONY: fw.edit.lnx
fw.edit.lnx: | $(FW_LNX_DST)
	petalinux-config -c kernel -p $(FW_DST)

.PHONY: fw.edit.ubl
fw.edit.ubl: | $(FW_UBL_DST)
	petalinux-config -c u-boot -p $(FW_DST)

.PHONY: fw.edit.plt
fw.edit.plt: | $(FW_PLT_DST)
	$(EDITOR) $(FW_PLT_DST)

.PHONY: fw.edit.dts
fw.edit.dts: | $(FW_DTS_DST)
	$(EDITOR) $(FW_DTS_DST)

.PHONY: fw.diff
fw.diff:
	test -e $(FW_SYS_SRC) && diff $(FW_SYS_DST) $(FW_SYS_SRC) || true
	test -e $(FW_RFS_SRC) && diff $(FW_RFS_DST) $(FW_RFS_SRC) || true
	test -e $(FW_LNX_SRC) && diff $(FW_LNX_DST) $(FW_LNX_SRC) || true
	test -e $(FW_UBL_SRC) && diff $(FW_UBL_DST) $(FW_UBL_SRC) || true
	test -e $(FW_PLT_SRC) && diff $(FW_PLT_DST) $(FW_PLT_SRC) || true
	test -e $(FW_DTS_SRC) && diff $(FW_DTS_DST) $(FW_DTS_SRC) || true

.PHONY: fw.load
fw.load: | $(FW_DST)
	test -e $(FW_SYS_SRC) && cp $(FW_SYS_SRC) $(FW_SYS_DST) || true
	test -e $(FW_RFS_SRC) && cp $(FW_RFS_SRC) $(FW_RFS_DST) || true
	test -e $(FW_LNX_SRC) && cp $(FW_LNX_SRC) $(FW_LNX_DST) || true
	test -e $(FW_UBL_SRC) && cp $(FW_UBL_SRC) $(FW_UBL_DST) || true
	test -e $(FW_PLT_SRC) && cp $(FW_PLT_SRC) $(FW_PLT_DST) || true
	test -e $(FW_DTS_SRC) && cp $(FW_DTS_SRC) $(FW_DTS_DST) || true

.PHONY: fw.save
fw.save: | $(FW_SRC)
	cp $(FW_SYS_DST) $(FW_SYS_SRC)
	cp $(FW_RFS_DST) $(FW_RFS_SRC)
	cp $(FW_LNX_DST) $(FW_LNX_SRC)
	cp $(FW_UBL_DST) $(FW_UBL_SRC)
	cp $(FW_PLT_DST) $(FW_PLT_SRC)
	cp $(FW_DTS_DST) $(FW_DTS_SRC)

$(FW_SRC):
	mkdir -p $@

# A following fw will trigger a rebuild.
.PHONY: fw.clean
fw.clean:
	rm -f $(FW_ITB_DST) $(FW_BIN_DST)

# Cleans the higher-level project. A following fw will not trigger a rebuild.
.PHONY: fw.distclean
fw.distclean:
	rm -rf $(FW_DST)

####
###
##
# Sofware rules
##
###
####

.PHONY: sw
sw:

.PHONY: sw.clean
sw.clean:

.PHONY: sw.distclean
sw.distclean:

$(SW_DST):
	mkdir -p $@

$(SW_SRC):
	mkdir -p $@

-include $(SW_PKG)*.mk $(SW_SRC)*.mk

####
###
##
# Terminal rules
##
###
####

.PHONY: tty
tty:
	plug picocom -b $(TTY_BAUD) -- $(TTY_PORT)

.PHONY: ssh
ssh:
	ssh $(SSH)

####
###
##
# File transfer rules
##
###
####

.PHONY: sftp
sftp: | $(CFG_SRC)
	cd $(CFG_SRC) && sftp $(CFG_DST)

####
###
##
# Synchronization rules
##
###
####

.PHONY: push
push: | $(CFG_SRC)
	rsync $(SSH_SYNC) $(CFG_SRC) $(CFG_DST)

.PHONY: pull
pull:
	rsync $(SSH_SYNC) $(CFG_DST) $(CFG_SRC)

.PHONY: dry-push
dry-push: | $(CFG_SRC)
	rsync $(SSH_SYNC) -n $(CFG_SRC) $(CFG_DST)

.PHONY: dry-pull
dry-pull:
	rsync $(SSH_SYNC) -n $(CFG_DST) $(CFG_SRC)

####
###
##
# Remote command rules
##
###
####

.PHONY: $(SSH_CMDS)
$(SSH_CMDS):
	ssh $(SSH) 'env PATH=$(SSH_PATH) $@'

####
###
##
# Configuration rules
##
###
####

$(CFG_SRC):
	mkdir -p $@

