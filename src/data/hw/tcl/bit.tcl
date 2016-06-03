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

# Assign arguments
set HW_SRC [lindex $argv 0]
set HW_DST [lindex $argv 1]
set HW_PRJ [lindex $argv 2]
set HW_TOP [lindex $argv 3]

# Open the project
open_project $HW_DST$HW_PRJ.xpr

# Reset runs
reset_run synth_1
reset_run impl_1

# Launch runs
synth_design
opt_design
place_design
route_design
phys_opt_design

# Generate bitstream
file mkdir $HW_DST$HW_PRJ.runs/impl_1
write_bitstream -force $HW_DST$HW_PRJ.runs/impl_1/$HW_TOP.bit

# Generate hardware
file mkdir $HW_DST$HW_PRJ.sdk
write_hwdef -force -file $HW_DST$HW_PRJ.runs/impl_1/$HW_TOP.hdf
