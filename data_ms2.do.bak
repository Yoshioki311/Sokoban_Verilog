vlib work
vlog loc_colour.v
vlog player_ram.v
vlog box_ram.v
vlog path_ram.v
vlog arena1_map.v
vsim -L altera_mf_ver datapath

log {/*}
add wave {/*}

# Input
# clock, resetn
# ld_map, reset_valid, update, check_move, clear_sprite, draw_new
# up, down, left, right

# Output
# can_move, x_out, y_out, colour_out

# Set clock
force {clock} 1 0ps, 0 {10ps} -r 20ps

# Reset
# State 0: S_START
force {resetn} 0
force {ld_map} 0
force {reset_valid} 0
force {update} 0
force {check_move} 0
force {clear_sprite} 0
force {draw_new} 0

force {up} 0
force {down} 0
force {left} 0
force {right} 0

run 10ps

force {resetn} 1
# run 10ps

# State 1: S_LOAD_MAP
force {ld_map} 1
run 160ps

# State 2: S_WAIT_MOVE
force {ld_map} 0
force {reset_valid} 1
run 60ps

# Move up, invalid move
force {up} 1
run 40ps

# S_CHECK_MOVE
force {up} 0
force {check_move} 1
run 20ps

# S_CONFIRM: nothing happens
# can_move should be 0
force {check_move} 0
run 20ps

# back to S_WAIT_MOVE
force {reset_valid} 1
run 60ps

# Move down, valid move
force {reset_valid} 0
force {down} 1
run 40ps

# S_CHECK_MOVE
force {down} 0
force {check_move} 1
run 20ps

# S_CONFIRM
# can_move should be 1
force {check_move} 0
run 20ps

# S_CLEAR_OLD
force {clear_sprite} 1
run 320ps

# S_UPDATE
force {clear_sprite} 0
force {update} 1
run 20ps

# S_DARW_NEW
force {update} 0
force {draw_new} 1
run 320 ps

# S_WIN
force {draw_new} 0
run 20ps

# S_WAIT_MOVE
force {reset_valid} 1
run 100 ps

