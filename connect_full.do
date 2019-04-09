vlib work

vlog connect.v
vlog datapath.v
vlog game_control.v
vlog reading.v

vlog ram/player_ram.v
vlog ram/box_ram.v
vlog ram/path_ram.v
vlog ram/dest_ram.v
vlog ram/arena0_map.v
vlog ram/arena1_map.v
vlog ram/map_config.v
vlog ram/title_ram.v
vlog ram/clear_ram.v

vsim -L altera_mf_ver connect

log {/*}
add wave {/*}

# Input
# clock, resetn, start, continue, restart, quit
# select, select_0, select_1
# up, down, left, right 
# Output
# x_o, y_o, color_o, wren

# Set clock
force {clock} 1 0ps, 0 {10ps} -r 20ps

# Reset
force {resetn} 0
force {start} 0
force {continue} 0
force {restart} 0 
force {quit} 0

force {select} 0
force {select_0} 0
force {select_1} 0

force {up} 0
force {down} 0
force {left} 0
force {right} 0

run 10ps

force {resetn} 1
run 40ps

# Select
force {select} 1
run 40ps
force {select} 0
run 40ps

# Select 1
force {select_1} 1
run 60ps
force {select_1} 0
run 60ps

# Quit
force {quit} 1
run 20ps
force {quit} 0
run 100ps

# Select
force {select} 1
run 40ps
force {select} 0
run 40ps

# Select 1
force {select_1} 1
run 60ps
force {select_1} 0
run 60ps

