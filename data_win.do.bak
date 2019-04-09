vlib work
vlog loc_colour.v
vlog player_ram.v
vlog box_ram.v
vlog path_ram.v
vlog dest_ram.v
vlog arena1_map.v
vlog reading.v
vsim -L altera_mf_ver datapath

log {/*}
add wave {/*}

# Input
# clock, resetn
# ld_map, reset_valid
# check_char, check_box, update_char, update_box, draw_char, draw_box, clear_char
# up, down, left, right

# Output
# char_empty, char_obs, char_box, box_empty, win
# x_out, y_out, colour_out

# Set clock
force {clock} 1 0ps, 0 {10ps} -r 20ps

# Reset
# State 0: S_START
force {resetn} 0
force {ld_map} 0
force {reset_valid} 0
force {check_char} 0
force {check_box} 0
force {update_char} 0
force {update_box} 0
force {draw_char} 0
force {draw_box} 0
force {clear_char} 0

force {up} 0
force {down} 0
force {left} 0
force {right} 0

run 10ps

force {resetn} 1
# run 10ps

# S_LOAD_MAP
force {ld_map} 1
run 160ps

# S_WAIT_MOVE
force {ld_map} 0
force {reset_valid} 1
run 60ps

# S_HOLD_KEY
# Move up, invalid move
force {reset_valid} 0
force {up} 1
run 40ps

# S_CHECK_CHAR
force {up} 0
force {check_char} 1
run 20ps

# S_CHAR_FEEDBACK: nothing happens
# char_obs should be 1
force {check_char} 0
run 20ps

# back to S_WAIT_MOVE
force {reset_valid} 1
run 60ps

# S_HOLD_KEY
# Move down, valid move
force {reset_valid} 0
force {down} 1
run 40ps

# S_CHECK_CHAR
force {down} 0
force {check_char} 1
run 20ps

# S_CHAR_FEEDBACK
# char_empty should be 1
force {check_char} 0
run 20ps

# S_CLEAR_OLD
force {clear_char} 1
run 320ps

# S_UPDATE
force {clear_char} 0
force {update_char} 1
run 20ps

# S_DARW_NEW
force {update_char} 0
force {draw_char} 1
run 320 ps

# S_WIN
force {draw_char} 0
run 20ps

# S_WAIT_MOVE
force {reset_valid} 1
run 60 ps

# S_HOLD_KEY
# Move left, valid move
force {reset_valid} 0
force {left} 1
run 40ps

# S_CHECK_CHAR
force {left} 0
force {check_char} 1
run 20ps

# S_CHAR_FEEDBACK
# char_empty should be 1
force {check_char} 0
run 20ps

# S_CLEAR_OLD
force {clear_char} 1
run 320ps

# S_UPDATE
force {clear_char} 0
force {update_char} 1
run 20ps

# S_DARW_NEW
force {update_char} 0
force {draw_char} 1
run 320 ps

# S_WIN
force {draw_char} 0
run 20ps

# S_WAIT_MOVE
force {reset_valid} 1
run 60 ps

# S_HOLD_KEY
# Move left, valid move, move box
force {reset_valid} 0
force {left} 1
run 40ps

# S_CHECK_CHAR
force {left} 0
force {check_char} 1
run 20ps

# S_CHAR_FEEDBACK
# char_box should be 1
force {check_char} 0
run 20ps

# S_CHECK_BOX
force {check_box} 1
run 20ps

# S_BOX_FEEDBACK
# box_empty should be 1
force {check_box} 0
run 20ps

# S_UPDATE_BOX
# box_1 should be updated
force {update_box} 1
run 20ps

# S_DRAW_BOX
force {update_box} 0
force {draw_box} 1
run 320ps

# wait
force {draw_box} 0
run 20ps

# S_CLEAR_OLD
force {clear_char} 1
run 320ps