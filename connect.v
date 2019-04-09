module game_connect
		(
			// Inputs
			clock,
			resetn,
			
			start,
			continue,
			restart,
			quit,
			select,
			
			up, 
			down,
			left, 
			right,
			
			select_0,
			select_1,
			select_2,
			select_3,
			select_4,
			select_5,
			select_6,
			select_7,
			
			// Outputs
			go_select,
			
			x_o,
			y_o,
			colour_o,
			wren,
			
			current,
			next,
			stage_reg
		);
	
	// Inputs
	// Utility
	input clock, resetn;
	// Top level control
	input start, continue, restart, quit, select;
	// Data
	input up, down, left, right;
	// Stage selector input
	input select_0, select_1, select_2, select_3, select_4, select_5, select_6, select_7;
	// Outputs
	// To stage selector
	output go_select;
	// To VGA adapter
	output [7:0] x_o;
	output [6:0] y_o;
	output [2:0] colour_o;
	output reg wren;
	output [5:0] current, next;
	output [2:0] stage_reg;
	
	// Wires
	wire key_pressed;
	wire ld_map_0, ld_map_1, ld_map_2, ld_map_3, ld_map_4, ld_map_5, ld_map_6, ld_map_7;
	wire reset_valid;
	wire update_char, update_box;
	wire check_char, check_box;
	wire draw_char, draw_box;
	wire clear_char;
	wire char_empty, char_obs, char_box;
	wire box_empty;
	wire win;
	wire draw_clear, draw_title, draw_ins, draw_select;
	
	// XOR?
	assign key_pressed = up | down | left | right;
	// assign wren = ld_map | clear_sprite | draw_new;
	// create a delay?
	always@(posedge clock) begin
		if(ld_map_0 | ld_map_1 | ld_map_2 | ld_map_3 | 
			ld_map_4 | ld_map_5 | ld_map_6 | ld_map_7 | 
			clear_char | draw_char | draw_box | draw_clear | draw_title | draw_select | draw_ins)
			wren <= 1'b1;
		else
			wren <= 1'b0;
	end
	
	
	game_control c0(
			// Inputs
			.clock(clock),
			.resetn(resetn),
			
			.start(start),
			.continue(continue),
			.restart(restart),
			.quit(quit),
			.select(select),
			
			.key_pressed(key_pressed),
			
			.char_empty(char_empty),
			.char_obs(char_obs),
			.char_box(char_box),
			.box_empty(box_empty),
			.win(win),
			
			.select_0(select_0),
			.select_1(select_1),
			.select_2(select_2),
			.select_3(select_3),
			.select_4(select_4),
			.select_5(select_5),
			.select_6(select_6),
			.select_7(select_7),
			
			// Outputs
			.ld_map_0(ld_map_0),
			.ld_map_1(ld_map_1),
			.ld_map_2(ld_map_2),
			.ld_map_3(ld_map_3),
			.ld_map_4(ld_map_4),
			.ld_map_5(ld_map_5),
			.ld_map_6(ld_map_6),
			.ld_map_7(ld_map_7),
			
			.reset_valid(reset_valid),
			
			.check_char(check_char),
			.check_box(check_box),
			.update_char(update_char),
			.update_box(update_box),
			.draw_char(draw_char),
			.draw_box(draw_box),
			.clear_char(clear_char),
			
			.draw_title(draw_title),
			.draw_ins(draw_ins),
			.draw_clear(draw_clear),
			.draw_select(draw_select),
			
			.go_select(go_select),
			
			.current_state(current),
			.next_state(next));
			
	data d0(
			.clock(clock),
			.resetn(resetn),
			
			.ld_map_0(ld_map_0),
			.ld_map_1(ld_map_1),
			.ld_map_2(ld_map_2),
			.ld_map_3(ld_map_3),
			.ld_map_4(ld_map_4),
			.ld_map_5(ld_map_5),
			.ld_map_6(ld_map_6),
			.ld_map_7(ld_map_7),
			
			.reset_valid(reset_valid),
			
			.check_char(check_char),
			.check_box(check_box),
			.update_char(update_char),
			.update_box(update_box),
			.draw_char(draw_char),
			.draw_box(draw_box),
			.clear_char(clear_char),
			
			.draw_title(draw_title),
			.draw_ins(draw_ins),
			.draw_clear(draw_clear),
			.draw_select(draw_select),
			
			.up(up), 
			.down(down),
			.left(left), 
			.right(right),
			
			.char_empty(char_empty),
			.char_obs(char_obs),
			.char_box(char_box),
			.box_empty(box_empty),
			.win(win),
			
			.x_out(x_o),
			.y_out(y_o),
			.colour_out(colour_o),
			.stage_reg(stage_reg));
	
endmodule