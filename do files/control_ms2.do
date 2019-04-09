vlib work
vlog loc_colour.v
vsim control

log {/*}
add wave {/*}

# Input
# clock, resetn
# start, continue, restart, quit, key_pressed
# char_empty, char_obs, char_box, box_empty

# Output
# ld_map, reset_valid
# check_char, check_box, update_char, update_box, draw_char, draw_box, clear_char

# States
# S_START                = 4'd0,
# S_LOAD_MAP             = 4'd1,
# S_WAIT_MOVE            = 4'd2,
# S_HOLD_KEY             = 4'd3,
# S_CHECK_CHAR           = 4'd4,
# S_CHAR_FEEDBACK        = 4'd5,
				  
# /****** New states added ******/
# S_CHECK_BOX            = 4'd6,
# S_BOX_FEEDBACK         = 4'd7,
# S_UPDATE_BOX           = 4'd8,
# S_DRAW_NEW_BOX         = 4'd9,
# /******************************/
				  
# S_CLEAR_OLD_CHAR       = 4'd10,
# S_UPDATE_CHAR          = 4'd11,
# S_DRAW_NEW_CHAR        = 4'd12,
# S_WIN                  = 4'd13,
# S_END                  = 4'd14;

# Set clock
force {clock} 1 0ps, 0 {10ps} -r 20ps

# Reset
force {resetn} 0

force {start} 0
force {continue} 0
force {restart} 0
force {quit} 0
force {key_pressed} 0

force {char_empty} 0
force {char_obs} 0
force {char_box} 0
force {box_empty} 0
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

# S_HOLD_KEY
force {key_pressed} 1
run 20ps

# S_CHECK_CHAR
force {key_pressed} 0
run 20ps

# S_CHAR_FEEDBACK
# Suppose go up
# char_empty = 0
force {char_obs} 1
run 40ps

# go back to S_WAIT_MOVE
force {char_obs} 0
run 20ps

# S_HOLD_KEY
force {key_pressed} 1
run 20ps

# S_CHECK_CHAR
force {key_pressed} 0
run 20ps

# S_CHAR_FEEDBACK
# Suppose go down
# S_CLEAR_OLD_CHAR
# S_UPDATE_CHAR
# S_DRAW_NEW_CHAR
# S_WIN
force {char_empty} 1
run 440ps

force {char_empty} 0
run 40ps

# S_HOLD_KEY
force {key_pressed} 1
run 20ps

# S_CHECK_CHAR
force {key_pressed} 0
run 20ps

# S_CHAR_FEEDBACK
# Suppose go left
# S_CLEAR_OLD_CHAR
# S_UPDATE_CHAR
# S_DRAW_NEW_CHAR
# S_WIN
force {char_empty} 1
run 600ps

force {char_empty} 0
run 40ps

# S_HOLD_KEY
force {key_pressed} 1
run 20ps

# S_CHECK_CHAR
force {key_pressed} 0
run 20ps

# S_CHAR_FEEDBACK
# Suppose go left
force {char_box} 1
run 40ps

# S_CHECK_BOX
# go into S_BOX_FEEDBACK
# Then S_UPDATE_BOX
# Then drawing
force {box_empty} 1
run 1000ps