module select_connect
		(	// Inputs
			clock,
			resetn,
			
			quit,
			decide,
			left,
			right,
			
			go_select,
			
			// Outputs
			select_0,
			select_1,
			select_2,
			select_3,
			select_4,
			select_5,
			select_6,
			select_7,
			
			current,
			next,
			
			x,
			y,
			colour,
			wren);
	// Inputs
	// Utility signals
	input clock, resetn;
	// User inputs
	input quit, decide;
	input left, right;
	// Game control input
	input go_select;
	// Outputs
	// To game control
	output select_0, select_1, select_2, select_3, select_4, select_5, select_6, select_7;
	// To VGA adapter
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output reg wren;
	
	output [2:0] current, next;
	
	// Wires
	wire clear_stage;
	wire clear_cursor;
	wire update;
	wire draw_cursor;
	wire [2:0] stage_reg;
	
	// Write enable
	always@(posedge clock) begin
		if(clear_cursor | draw_cursor)
			wren <= 1'b1;
		else
			wren <= 1'b0;
	end
	
	select_control sc(
			.clock(clock),
			.resetn(resetn),
			
			.go_select(go_select),
			
			.stage_reg(stage_reg),
			
			.quit(quit),
			.decide(decide),
			.left(left),
			.right(right),
			
			.clear_stage(clear_stage),
			.clear_cursor(clear_cursor),
			.update(update),
			.draw_cursor(draw_cursor),
			
			.select_0(select_0),
			.select_1(select_1),
			.select_2(select_2),
			.select_3(select_3),
			.select_4(select_4),
			.select_5(select_5),
			.select_6(select_6),
			.select_7(select_7),
			
			.current_state(current),
			.next_state(next));
	
	select_data sd(
			.clock(clock),
			.resetn(resetn),
			
			.left(left),
			.right(right),
			
			.clear_stage(clear_stage),
			.clear_cursor(clear_cursor),
			.update(update),
			.draw_cursor(draw_cursor),
			
			.x(x),
			.y(y),
			.colour(colour),
			
			.stage_reg(stage_reg));
endmodule
	

module select_control
		(
			// Inputs
			// Utility
			clock, resetn,
			// User inputs
			quit, decide, left, right,
			// From game controller
			go_select,
			// Feedback
			stage_reg,
			//Outputs
			// To datapath
			clear_stage, clear_cursor, update, draw_cursor,
			// To game control
			select_0, select_1, select_2, select_3, select_4, select_5, select_6, select_7,
			current_state, next_state
		);
	// Inputs
	// Utility signal
	input clock, resetn;
	// Communicate from game control
	input go_select;
	// User inputs
	input quit, decide;
	input left, right;
	// Feedback
	input [2:0] stage_reg;
	// Outputs
	// Output to datapath
	output reg clear_stage, clear_cursor, update, draw_cursor;
	// Communicate to game control
	output reg select_0, select_1, select_2, select_3, select_4, select_5, select_6, select_7;
	
	// Internal registers
	output reg [2:0] current_state, next_state;
	reg [7:0] draw_counter;
	reg [2:0] state_reg;
	
	localparam S_IDLE          = 3'd0,
				  S_SELECT        = 3'd1,
				  S_CHANGE_HOLD   = 3'd2,
				  S_CLEAR         = 3'd3,
				  S_UPDATE        = 3'd4,
				  S_DRAW          = 3'd5,
				  S_DECIDE_HOLD   = 3'd6,
				  S_DECIDE        = 3'd7;
				  
	// State table
	always@(*) begin
		case(current_state) 
			S_IDLE: next_state = (go_select) ? S_SELECT : S_IDLE;
			S_SELECT: next_state =  (left || right) ? S_CHANGE_HOLD : S_SELECT;
			S_CHANGE_HOLD: next_state = (left || right) ? S_CHANGE_HOLD : S_CLEAR;
			S_CLEAR: next_state = (draw_counter == 8'd224) ? S_UPDATE : S_CLEAR;
			S_UPDATE: next_state = S_DRAW;
			S_DRAW: next_state = (draw_counter == 8'd244) ? S_SELECT : S_DRAW;
			S_DECIDE_HOLD: next_state = decide ? S_DECIDE_HOLD : S_DECIDE;
			S_DECIDE: next_state = S_IDLE;
		default: next_state = S_IDLE;
		endcase
	end
	
	// Output logic
	always@(*) begin
		clear_stage = 1'b0;
		clear_cursor = 1'b0;
		update = 1'b0;
		draw_cursor = 1'b0;
		select_0 = 1'b0;
		select_1 = 1'b0;
		select_2 = 1'b0;
		select_3 = 1'b0;
		select_4 = 1'b0;
		select_5 = 1'b0;
		select_6 = 1'b0;
		select_7 = 1'b0;
		
		case(current_state)
			S_IDLE: clear_stage = 1'b1;
			S_CLEAR: clear_cursor = 1'b1;
			S_UPDATE: update = 1'b1;
			S_DRAW: draw_cursor = 1'b1;
			S_DECIDE: 
				begin
					if(stage_reg == 3'd0) select_0 = 1'b1;
					else if(stage_reg == 3'd1) select_1 = 1'b1;
					else if(stage_reg == 3'd2) select_2 = 1'b1;
					else if(stage_reg == 3'd3) select_3 = 1'b1;
					else if(stage_reg == 3'd4) select_4 = 1'b1;
					else if(stage_reg == 3'd5) select_5 = 1'b1;
					else if(stage_reg == 3'd6) select_6 = 1'b1;
					else if(stage_reg == 3'd7) select_7 = 1'b1;
				end
		endcase
	end
	
	// Draw counter
	always@(posedge clock) begin
		if(!resetn)
			draw_counter <= 0;
		else if(clear_cursor || draw_cursor)
			draw_counter <= draw_counter + 1;
		else
			draw_counter <= 0;
	end
	
	// current_state register
	always@(posedge clock) begin
		if(!resetn || quit)
			current_state <= S_IDLE;
		else if(decide)
			current_state <= S_DECIDE_HOLD;
		else
			current_state <= next_state;
	end
	
endmodule
	
module select_data
		(
			// Inputs
			// Utility
			clock, resetn,
			// User inputs
			left, right,
			// control signals
			clear_stage, clear_cursor, update, draw_cursor,
			// Outputs
			x, y, colour,
			stage_reg
		);
	// Inputs
	// Utility inputs
	input clock, resetn;
	// Direct input from user
	input left, right;
	// Input from controller
	input clear_stage, clear_cursor, update, draw_cursor;
	// Outputs
	output reg [7:0] x;
	output reg [6:0] y;
	output reg [2:0] colour;
	// Feedback
	output reg [2:0] stage_reg;
	
	// Wires
	wire x_counter_clear, y_counter_clear;
	// Wire for storing y starting location
	wire [7:0] x_start;
	wire [6:0] y_start;
	assign x_start = 8'd6 + stage_reg * 19;
	assign y_start = 7'd54;
	// Colour wires
	wire [2:0] _0_black, _1_black, _2_black, _3_black, _4_black, _5_black, _6_black, _7_black;
	wire [2:0] _0_white, _1_white, _2_white, _3_white, _4_white, _5_white, _6_white, _7_white;
	
	// Internal registers
	reg direction;
	reg [7:0] address;
	reg [7:0] x_counter;
	reg [6:0] y_counter;
	
	
	// Direction register
	always@(posedge clock) begin
		if(!resetn) direction <= 0;
		else if(left) direction <= 0;
		else if(right) direction <= 1;
	end
	
	// Stage register
	always@(posedge clock) begin
		if(!resetn || clear_stage)
			stage_reg <= 3'b0;
		else if(update) begin
			if(direction == 1'b0)
				stage_reg <= stage_reg - 1;
			else if(direction == 1'b1)
				stage_reg <= stage_reg + 1;
		end
	end
	
	// Address register
	always@(posedge clock) begin
		if(!resetn)
			address <= 8'd0;
		else if(clear_cursor || draw_cursor)
			address <= address + 1;
		else
			address <= 8'd0;
	end
	
	// x counter register
	always@(posedge clock) begin
		if(!resetn) x_counter <= 8'd0;
		else if(clear_cursor || draw_cursor) begin
			if(x_counter_clear) x_counter <= 8'd0;
			else x_counter <= x_counter + 1;
		end
		else x_counter <= 8'd0;
	end
	assign x_counter_clear = (x_counter == 8'd14);
	
	// y counter register
	always@(posedge clock) begin
		if(!resetn) y_counter <= 7'd0;
		else if(clear_cursor || draw_cursor) begin
			if(x_counter_clear) y_counter <= y_counter + 1;
			else if(x_counter_clear && y_counter_clear) y_counter <= 7'd0;
		end
		else y_counter <= 7'd0;
	end
	assign y_counter_clear = (y_counter == 7'd14);
	
	// xy output register
	always@(posedge clock) begin
		if(!resetn) begin
			x <= 8'd0;
			y <= 7'd0;
		end
		else if(clear_cursor || draw_cursor) begin
			x <= x_start + x_counter;
			y <= y_start + y_counter;
		end
	end
	
	// Color selector
	always@(*) begin
		if(!resetn)
			colour = 3'b0;
		else if(clear_cursor) begin
			if(stage_reg == 3'd0) colour = _0_white;
			else if(stage_reg == 3'd1) colour = _1_white;
			else if(stage_reg == 3'd2) colour = _2_white;
			else if(stage_reg == 3'd3) colour = _3_white;
			else if(stage_reg == 3'd4) colour = _4_white;
			else if(stage_reg == 3'd5) colour = _5_white;
			else if(stage_reg == 3'd6) colour = _6_white;
			else if(stage_reg == 3'd7) colour = _7_white;
		end
		else if(draw_cursor) begin
			if(stage_reg == 3'd0) colour = _0_black;
			else if(stage_reg == 3'd1) colour = _1_black;
			else if(stage_reg == 3'd2) colour = _2_black;
			else if(stage_reg == 3'd3) colour = _3_black;
			else if(stage_reg == 3'd4) colour = _4_black;
			else if(stage_reg == 3'd5) colour = _5_black;
			else if(stage_reg == 3'd6) colour = _6_black;
			else if(stage_reg == 3'd7) colour = _7_black;
		end
		else colour = 3'b0;
	end
		
	// assign address = x_counter + y_counter * 15;
	// RAM instantiation	
	zero_on  on0(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_0_black));
	one_on   on1(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_1_black));
	two_on   on2(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_2_black));
	three_on on3(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_3_black));
	four_on  on4(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_4_black));
	five_on  on5(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_5_black));
	six_on   on6(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_6_black));
	seven_on on7(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_7_black));
	zero_off  off0(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_0_white));
	one_off   off1(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_1_white));
	two_off   off2(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_2_white));
	three_off off3(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_3_white));
	four_off  off4(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_4_white));
	five_off  off5(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_5_white));
	six_off   off6(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_6_white));
	seven_off off7(.address(address), .clock(clock), .data(3'b000), .wren(1'b0), .q(_7_white));
endmodule
	
	