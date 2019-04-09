module game_control
		(
			// Inputs
			// Utility
			clock, resetn,
			// User input
			start, continue, restart, quit, select, key_pressed, 
			// Feedback
			char_empty, char_obs, char_box, box_empty, win,
			// From stage selector
			select_0, select_1, select_2, select_3, select_4, select_5, select_6, select_7,
			// Outputs
			// To datapath
			ld_map_0, ld_map_1, ld_map_2, ld_map_3, ld_map_4, ld_map_5, ld_map_6, ld_map_7,
			reset_valid, 
			check_char, check_box, update_char, update_box, draw_char, draw_box, clear_char,
			draw_title, draw_ins, draw_clear, draw_select, 
			// To stage selector
			go_select,
			// For debugging
			current_state, next_state
		);
	
	// Inputs
	// Utility
	input clock, resetn;
	// Top level control (directly from the board)
	input start, continue, restart, quit, key_pressed, select;
	// Feedback
	input char_empty, char_obs, char_box, box_empty, win;
	// FSM Communication
	input select_0, select_1, select_2, select_3, select_4, select_5, select_6, select_7;
	// Outputs
	// FSM Communication
	output reg go_select;
	// Control
	output reg ld_map_0, ld_map_1, ld_map_2, ld_map_3, ld_map_4, ld_map_5, ld_map_6, ld_map_7;
	output reg reset_valid;
	output reg check_char, check_box, update_char, update_box, draw_char, draw_box, clear_char;
	output reg draw_title, draw_ins, draw_clear, draw_select;
	
	// Counter
	reg [14:0] restart_counter;
	reg [5:0] sprite_counter;
	reg [2:0] stage_reg;
	
	// States
	output reg [5:0] current_state, next_state;
	
	localparam S_TITLE                = 6'h00,
				  S_START_HOLD           = 6'h01,
				  S_DRAW_INS             = 6'h02,
				  S_INSTRUCTION          = 6'h03,
				  S_INS_HOLD             = 6'h04,
				  S_SELECT_HOLD          = 6'h05,
				  S_DRAW_SELECT          = 6'h06,
				  S_STAGE_SELECT         = 6'h07,
				  S_SELECT_0_HOLD        = 6'h08,
				  S_SELECT_1_HOLD        = 6'h09,
				  S_SELECT_2_HOLD        = 6'h0A,
				  S_SELECT_3_HOLD        = 6'h0B,
				  S_SELECT_4_HOLD        = 6'h0C,
				  S_SELECT_5_HOLD        = 6'h0D,
				  S_SELECT_6_HOLD        = 6'h0E,
				  S_SELECT_7_HOLD        = 6'h0F,
				  
				  // Loading maps
				  S_LOAD_MAP_0           = 6'h10,
				  S_LOAD_MAP_1           = 6'h11,
				  S_LOAD_MAP_2           = 6'h12,
				  S_LOAD_MAP_3           = 6'h13,
				  S_LOAD_MAP_4           = 6'h14,
				  S_LOAD_MAP_5           = 6'h15,
				  S_LOAD_MAP_6           = 6'h16,
				  S_LOAD_MAP_7           = 6'h17,
				  
				  // Game States
				  S_WAIT_MOVE            = 6'h18,
				  S_HOLD_KEY             = 6'h19,
				  S_CHECK_CHAR           = 6'h1A,
				  S_CHAR_FEEDBACK        = 6'h1B,
				  S_CHECK_BOX            = 6'h1C,
				  S_BOX_FEEDBACK         = 6'h1D,
				  S_UPDATE_BOX           = 6'h1E,
				  S_DRAW_NEW_BOX         = 6'h1F,
				  S_CLEAR_OLD_CHAR       = 6'h20,
				  S_UPDATE_CHAR          = 6'h21,
				  S_DRAW_NEW_CHAR        = 6'h22,
				  S_WIN                  = 6'h23,
				  
				  // Continue
				  S_DRAW_CLEAR           = 6'h24,
				  S_CLEAR					 = 6'h25,
				  S_CONTINUE_HOLD        = 6'h26,
				  S_DRAW_TITLE           = 6'h27,
				  
				  // Other hold states
				  S_RESTART_HOLD         = 6'h28,
				  S_QUIT_HOLD            = 6'h29;
	
	// State table
	always@(*) begin
		case(current_state)
			S_TITLE: begin
								if(select) next_state = S_SELECT_HOLD;
								else if(start) next_state = S_START_HOLD;
								else next_state = S_TITLE;
							end
			S_START_HOLD: next_state = start ? S_START_HOLD : S_DRAW_INS;// S_LOAD_MAP_0;
			S_DRAW_INS: next_state = (restart_counter == 15'd19199) ? S_INSTRUCTION : S_DRAW_INS;
			S_INSTRUCTION: next_state = start ? S_INS_HOLD : S_INSTRUCTION;
			S_INS_HOLD: next_state = start ? S_INS_HOLD : S_LOAD_MAP_0;
			S_SELECT_HOLD: next_state = select ? S_SELECT_HOLD : S_DRAW_SELECT;
			S_DRAW_SELECT: next_state = (restart_counter == 15'd19199) ? S_STAGE_SELECT : S_DRAW_SELECT;
			S_STAGE_SELECT: begin
								if(select_0) next_state = S_SELECT_0_HOLD;
								else if(select_1) next_state = S_SELECT_1_HOLD;
								else if(select_2) next_state = S_SELECT_2_HOLD;
								else if(select_3) next_state = S_SELECT_3_HOLD;
								else if(select_4) next_state = S_SELECT_4_HOLD;
								else if(select_5) next_state = S_SELECT_5_HOLD;
								else if(select_6) next_state = S_SELECT_6_HOLD;
								else if(select_7) next_state = S_SELECT_7_HOLD;
								else next_state = S_STAGE_SELECT;
							end
			S_SELECT_0_HOLD: next_state = select_0 ? S_SELECT_0_HOLD : S_LOAD_MAP_0;
			S_SELECT_1_HOLD: next_state = select_1 ? S_SELECT_1_HOLD : S_LOAD_MAP_1;
			S_SELECT_2_HOLD: next_state = select_2 ? S_SELECT_2_HOLD : S_LOAD_MAP_2;
			S_SELECT_3_HOLD: next_state = select_3 ? S_SELECT_3_HOLD : S_LOAD_MAP_3;
			S_SELECT_4_HOLD: next_state = select_4 ? S_SELECT_4_HOLD : S_LOAD_MAP_4;
			S_SELECT_5_HOLD: next_state = select_5 ? S_SELECT_5_HOLD : S_LOAD_MAP_5;
			S_SELECT_6_HOLD: next_state = select_6 ? S_SELECT_6_HOLD : S_LOAD_MAP_6;
			S_SELECT_7_HOLD: next_state = select_7 ? S_SELECT_7_HOLD : S_LOAD_MAP_7;
			S_LOAD_MAP_0: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_0;
			S_LOAD_MAP_1: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_1;
			S_LOAD_MAP_2: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_2;
			S_LOAD_MAP_3: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_3;
			S_LOAD_MAP_4: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_4;
			S_LOAD_MAP_5: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_5;
			S_LOAD_MAP_6: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_6;
			S_LOAD_MAP_7: next_state = (restart_counter == 15'd19199) ? S_WAIT_MOVE : S_LOAD_MAP_7;
			S_WAIT_MOVE: begin
								if(restart) next_state = S_RESTART_HOLD;
								else if(key_pressed) next_state = S_HOLD_KEY;
								else next_state = S_WAIT_MOVE;
							end
			S_HOLD_KEY: next_state = key_pressed ? S_HOLD_KEY : S_CHECK_CHAR;
			S_CHECK_CHAR: next_state = S_CHAR_FEEDBACK;
			S_CHAR_FEEDBACK: begin
								if(char_empty) next_state = S_CLEAR_OLD_CHAR;
								else if(char_obs) next_state = S_WAIT_MOVE;
								else if(char_box) next_state = S_CHECK_BOX;
							end
			S_CHECK_BOX: next_state = S_BOX_FEEDBACK;
			S_BOX_FEEDBACK: next_state = box_empty ? S_UPDATE_BOX : S_WAIT_MOVE;
			S_UPDATE_BOX: next_state = S_DRAW_NEW_BOX;
			S_DRAW_NEW_BOX: next_state = (sprite_counter == 6'd63) ? S_CLEAR_OLD_CHAR : S_DRAW_NEW_BOX;
			S_CLEAR_OLD_CHAR: next_state = (sprite_counter == 6'd63) ? S_UPDATE_CHAR : S_CLEAR_OLD_CHAR;
			S_UPDATE_CHAR: next_state = S_DRAW_NEW_CHAR;
			S_DRAW_NEW_CHAR: next_state = (sprite_counter == 6'd63) ? S_WIN : S_DRAW_NEW_CHAR;
			S_WIN: next_state = (!win) ? S_WAIT_MOVE : S_DRAW_CLEAR;
			S_DRAW_CLEAR: next_state = (restart_counter == 15'd19199) ? S_CLEAR : S_DRAW_CLEAR;
			S_CLEAR: next_state = continue ? S_CONTINUE_HOLD : S_CLEAR;
			S_CONTINUE_HOLD: begin
								if(!continue && (stage_reg == 3'd0)) next_state = S_LOAD_MAP_1;
								else if(!continue && (stage_reg == 3'd1)) next_state = S_LOAD_MAP_2;
								else if(!continue && (stage_reg == 3'd2)) next_state = S_LOAD_MAP_3;
								else if(!continue && (stage_reg == 3'd3)) next_state = S_LOAD_MAP_4;
								else if(!continue && (stage_reg == 3'd4)) next_state = S_LOAD_MAP_5;
								else if(!continue && (stage_reg == 3'd5)) next_state = S_LOAD_MAP_6;
								else if(!continue && (stage_reg == 3'd6)) next_state = S_LOAD_MAP_7;
								else if(!continue && (stage_reg == 3'd7)) next_state = S_DRAW_TITLE;
								else next_state = S_CONTINUE_HOLD;
							end
			S_DRAW_TITLE: next_state = (restart_counter == 15'd19199) ? S_TITLE : S_DRAW_TITLE;
			S_RESTART_HOLD: begin
								if(!restart && (stage_reg == 3'd0)) next_state = S_LOAD_MAP_0;
								else if(!restart && (stage_reg == 3'd1)) next_state = S_LOAD_MAP_1;
								else if(!restart && (stage_reg == 3'd2)) next_state = S_LOAD_MAP_2;
								else if(!restart && (stage_reg == 3'd3)) next_state = S_LOAD_MAP_3;
								else if(!restart && (stage_reg == 3'd4)) next_state = S_LOAD_MAP_4;
								else if(!restart && (stage_reg == 3'd5)) next_state = S_LOAD_MAP_5;
								else if(!restart && (stage_reg == 3'd6)) next_state = S_LOAD_MAP_6;
								else if(!restart && (stage_reg == 3'd7)) next_state = S_LOAD_MAP_7;
								else next_state = S_RESTART_HOLD;
							end
			S_QUIT_HOLD: next_state = quit ? S_QUIT_HOLD : S_DRAW_TITLE;
			default: next_state = S_TITLE;
		endcase
	end
	
	
	// Output logic
	always@(*) begin
		// Load signals
		ld_map_0 = 1'b0;
		ld_map_1 = 1'b0;
		ld_map_2 = 1'b0;
		ld_map_3 = 1'b0;
		ld_map_4 = 1'b0;
		ld_map_5 = 1'b0;
		ld_map_6 = 1'b0;
		ld_map_7 = 1'b0;
		// Game signals
		reset_valid = 1'b0;
		check_char = 1'b0;
		check_box = 1'b0;
		update_box = 1'b0;
		draw_box = 1'b0;
		clear_char = 1'b0;
		update_char = 1'b0;
		draw_char = 1'b0;
		// Title screen signals
		draw_clear = 1'b0;
		draw_title = 1'b0;
		draw_ins = 1'b0;
		draw_select = 1'b0;
		// FSM communication
		go_select = 1'b0;
		
		case(current_state)
			// S_TITLE: 
			S_DRAW_SELECT: draw_select = 1'b1;
			S_DRAW_INS: draw_ins = 1'b1;
			S_STAGE_SELECT: go_select = 1'b1;
			// S_INSTRUCTIONS: 
			S_LOAD_MAP_0: ld_map_0 = 1'b1;
			S_LOAD_MAP_1: ld_map_1 = 1'b1;
			S_LOAD_MAP_2: ld_map_2 = 1'b1;
			S_LOAD_MAP_3: ld_map_3 = 1'b1;
			S_LOAD_MAP_4: ld_map_4 = 1'b1;
			S_LOAD_MAP_5: ld_map_5 = 1'b1;
			S_LOAD_MAP_6: ld_map_6 = 1'b1;
			S_LOAD_MAP_7: ld_map_7 = 1'b1;
			S_WAIT_MOVE: reset_valid = 1'b1; 
			S_CHECK_CHAR: check_char = 1'b1;
			// S_HOLD_KEY:
			// S_CHAR_FEEDBACK:
			S_CHECK_BOX: check_box = 1'b1;
			// S_BOX_FEEDBACK: 
			S_UPDATE_BOX: update_box = 1'b1;
			S_DRAW_NEW_BOX: draw_box = 1'b1;
			S_CLEAR_OLD_CHAR: clear_char = 1'b1;
			S_UPDATE_CHAR: update_char = 1'b1;
			S_DRAW_NEW_CHAR: draw_char = 1'b1;
			// S_WIN:
			S_DRAW_CLEAR: draw_clear = 1'b1;
			// S_CLEAR:
			S_DRAW_TITLE: draw_title = 1'b1;
		endcase
	end
	
	// Restart Counter
	always@(posedge clock) begin
		if(!resetn)
			restart_counter <= 0;
		else if(current_state != S_LOAD_MAP_0 && 
				  current_state != S_LOAD_MAP_1 &&
				  current_state != S_LOAD_MAP_2 &&
				  current_state != S_LOAD_MAP_3 &&
				  current_state != S_LOAD_MAP_4 &&
				  current_state != S_LOAD_MAP_5 &&
				  current_state != S_LOAD_MAP_6 &&
				  current_state != S_LOAD_MAP_7 &&
				  current_state != S_DRAW_CLEAR &&
				  current_state != S_DRAW_TITLE &&
				  current_state != S_DRAW_INS &&
				  current_state != S_DRAW_SELECT)
			restart_counter <= 0;
		else
			restart_counter <= restart_counter + 1;
	end
	
	// Sprite Counter 
	always@(posedge clock) begin
		if(!resetn)
			sprite_counter <= 0;
		else if(current_state != S_CLEAR_OLD_CHAR && 
				  current_state != S_DRAW_NEW_CHAR &&
				  current_state != S_DRAW_NEW_BOX)
			sprite_counter <= 0;
		else
			sprite_counter <= sprite_counter + 1;
	end
	
	// Stage register
	always@(posedge clock) begin
		if(!resetn)
			stage_reg <= 3'b000;
		else if(ld_map_0)
			stage_reg <= 3'b000;
		else if(ld_map_1)
			stage_reg <= 3'b001;
		else if(ld_map_2)
			stage_reg <= 3'b010;
		else if(ld_map_3)
			stage_reg <= 3'b011;
		else if(ld_map_4)
			stage_reg <= 3'b100;
		else if(ld_map_5)
			stage_reg <= 3'b101;
		else if(ld_map_6)
			stage_reg <= 3'b110;
		else if(ld_map_7)
			stage_reg <= 3'b111;
	end
	
	// current_state register
	always@(posedge clock) begin
		if(!resetn)
			current_state <= S_TITLE;
		else if(quit)
			current_state <= S_QUIT_HOLD;
		else
			current_state <= next_state;
	end
endmodule
