vlib work
vlog loc_colour.v
vlog player_ram.v
vlog box_ram.v
vlog path_ram.v
vlog arena1_map.v
vsim -L altera_mf_ver connect

log {/*}
add wave {/*}

# Input
# clock, resetn, start, continue
# up, down, left, right 
# Output
# x_o, y_o, color_o, wren

# Set clock
force {clock} 1 0ps, 0 {10ps} -r 20ps

# Reset
force {resetn} 0
force {start} 0
force {continue} 0

force {up} 0
force {down} 0
force {left} 0
force {right} 0

run 10ps

force {resetn} 1
run 40ps

# Start
force {start} 1
run 40 ps
force {start} 0
run 200ps

# up
force {up} 1
run 60ps
force {up} 0
run 100ps

# down
force {down} 1
run 60ps
force {down} 0
run 500ps
