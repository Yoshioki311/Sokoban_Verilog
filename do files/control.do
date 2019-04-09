vlib work
vlog loc_colour.v
vsim control

log {/*}
add wave {/*}

# Input
# clock, resetn
# start, continue, key_pressed
# can_move

# Output
# ld_map, update, check_move, load_xy_old, clear_sprite, load_xy_new, draw_new

# States
# S_START        = 4'd0,
# S_LOAD_MAP     = 4'd1,
# S_WAIT_MOVE    = 4'd2,
# S_CHECK_MOVE   = 4'd3,
# S_CONFIRM      = 4'd4,
# S_CLEAR_OLD    = 4'd5,
# S_UPDATE       = 4'd6,
# S_DRAW_NEW     = 4'd7,
# S_WIN          = 4'd8,
# S_END          = 4'd9;

# Set clock
force {clock} 1 0ps, 0 {10ps} -r 20ps

# Reset
force {resetn} 0
force {start} 0
force {continue} 0
force {key_pressed} 0
force {can_move} 0
run 10ps

# S_START
force {resetn} 1
force {start} 1
run 20ps

# S_LOAD_MAP 
# Count to 7
# Then S_WAIT_MOVE
force {start} 0
run 200ps

# S_CHECK_MOVE
force {key_pressed} 1
run 20ps

# S_CONFIRM
# can_move = 0
# go back to S_WAIT_MOVE
force {key_pressed} 0
run 60ps

# set can_move = 1
force {can_move} 1

# S_CHECK_MOVE
force {key_pressed} 1
run 20ps

# S_CONFIRM
force {key_pressed} 0
run 1000ps
