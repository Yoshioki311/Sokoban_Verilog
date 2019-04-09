vlib work
vlog game_control.v
vsim game_control

log {/*}
add wave {/*}

# Input
# clock, resetn
# start, continue, restart, quit, select, select_0, select_1, key_pressed
# char_empty, char_obs, char_box, box_empty, win

# Output
# ld_map_0, ld_map_1, reset_valid
# check_char, check_box, update_char, update_box, draw_char, draw_box, clear_char
# draw_title, draw_clear

# States
# S_TITLE                = 5'd0,
# S_STAGE_SELECT         = 5'd1,
				  
# Loading maps
# S_LOAD_MAP_0           = 5'd3,
# S_LOAD_MAP_1           = 5'd4,
				  
# Game States
# S_WAIT_MOVE            = 5'd5,
# S_HOLD_KEY             = 5'd6,
# S_CHECK_CHAR           = 5'd7,
# S_CHAR_FEEDBACK        = 5'd8,
# S_CHECK_BOX            = 5'd9,
# S_BOX_FEEDBACK         = 5'd10,
# S_UPDATE_BOX           = 5'd11,
# S_DRAW_NEW_BOX         = 5'd12,
# S_CLEAR_OLD_CHAR       = 5'd13,
# S_UPDATE_CHAR          = 5'd14,
# S_DRAW_NEW_CHAR        = 5'd15,
# S_WIN                  = 5'd16,
				  
# Continue
# S_DRAW_CLEAR           = 5'd17,
# S_CLEAR					 = 5'd18,
# S_DRAW_TITLE           = 5'd19;

# Set clock
force {clock} 1 0ps, 0 {10ps} -r 20ps

# Reset
force {resetn} 0

force {start} 0
force {continue} 0
force {restart} 0
force {quit} 0
force {key_pressed} 0

force {select} 0
force {select_0} 0
force {select_1} 0

force {char_empty} 0
force {char_obs} 0
force {char_box} 0
force {box_empty} 0
force {win} 0
run 10ps

# S_TITLE
force {resetn} 1
force {start} 1
run 20ps

# S_LOAD_MAP_0 
# Count to 7
# Then S_WAIT_MOVE
force {start} 0
run 200ps

# Reset stage
force {restart} 1
run 20ps

# S_LOAD_MAP_0 -> S_WAIT_MOVES
force {restart} 0
run 200ps

# Quit
force {quit} 1
run 20ps

# S_DRAW_TITLE -> S_TITLE
force {quit} 0
run 200ps

# S_SELECT
force {select} 1
run 20ps
force {select} 0
run 40ps

# S_LOAD_MAP_1
force {select_1} 1
run 20ps
force {select_1} 0
run 200ps

# S_WAIT_MOVE -> S_HOLD_KEY
force {key_pressed} 1
run 20ps
force {key_pressed} 0
force {char_empty} 1
run 100ps
force {char_empty} 0
force {win} 1
run 640ps