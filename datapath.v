module data
		(
			clock, resetn,
			ld_map_0, ld_map_1, ld_map_2, ld_map_3, ld_map_4, ld_map_5, ld_map_6, ld_map_7,
			reset_valid,
			check_char, check_box, update_char, update_box, draw_char, draw_box, clear_char,
			draw_title, draw_ins, draw_clear, draw_select,
			up, down, left, right,
			char_empty, char_obs, char_box, box_empty, win,
			x_out, y_out, colour_out, stage_reg
		);
	
	// Utility
	input clock, resetn;
	// Control
	input ld_map_0, ld_map_1, ld_map_2, ld_map_3, ld_map_4, ld_map_5, ld_map_6, ld_map_7;
	input reset_valid;
	input check_char, check_box, update_char, update_box, draw_char, draw_box, clear_char;
	input draw_title, draw_ins, draw_clear, draw_select;
	// Directions
	input up, down, left, right;
	// Feedback
	output reg char_empty, char_obs, char_box, box_empty;
	// Output
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	output reg [2:0] colour_out;
	
	// Registers
	reg [5:0] counter;
	reg [7:0] x_counter;
	reg [6:0] y_counter;
	reg [4:0] x_chara;
	reg [3:0] y_chara;
	reg [4:0] x_box_1;
	reg [3:0] y_box_1;
	reg [4:0] x_box_2;
	reg [3:0] y_box_2;
	reg [4:0] x_box_3;
	reg [3:0] y_box_3;
	
	reg [4:0] x_des_1;
	reg [3:0] y_des_1;
	reg [4:0] x_des_2;
	reg [3:0] y_des_2;
	reg [4:0] x_des_3;
	reg [3:0] y_des_3;
	output reg win;
	reg box_1_in;
	reg box_2_in;
	reg box_3_in;
	
	reg [1:0] direction;
	output reg [2:0] stage_reg;
	
	// Wires
	// Colour wires
	wire [2:0] map_colour_0;
	wire [2:0] map_colour_1;
	wire [2:0] map_colour_2;
	wire [2:0] map_colour_3;
	wire [2:0] map_colour_4;
	wire [2:0] map_colour_5;
	wire [2:0] map_colour_6;
	wire [2:0] map_colour_7;
	wire [2:0] clear_colour;
	wire [2:0] title_colour;
	wire [2:0] ins_colour;
	wire [2:0] select_colour;
	wire [2:0] player_colour;
	wire [2:0] box_colour;
	wire [2:0] path_colour;
	wire [2:0] dest_colour;
	// Counter reset signal
	wire x_counter_clear;
	wire y_counter_clear;
	// Address providers
	wire [14:0] address_arena;
	wire [2:0] address_obs;
	// Obstacle array
	wire [0:299] w_obstacle;
	
	/********************************************************/
	/*                 Regulatory registers                 */
	/********************************************************/
	
	// Drawing counter
	always@(posedge clock) begin
		if(!resetn)
			counter <= 0;
		else if(clear_char || draw_char || draw_box)
			counter <= counter + 1;
		else
			counter <= 0;
	end
	
	/********************************************************/
	/*                  Game info registers                 */
	/********************************************************/
	
	// Stage register
	always@(posedge clock) begin
		if(!resetn) stage_reg <= 3'd0;
		else if(ld_map_0) stage_reg <= 3'd0;
		else if(ld_map_1) stage_reg <= 3'd1;
		else if(ld_map_2) stage_reg <= 3'd2;
		else if(ld_map_3) stage_reg <= 3'd3;
		else if(ld_map_4) stage_reg <= 3'd4;
		else if(ld_map_5) stage_reg <= 3'd5;
		else if(ld_map_6) stage_reg <= 3'd6;
		else if(ld_map_7) stage_reg <= 3'd7;
	end
	assign address_obs = stage_reg;
	// Read obstacle array
	map_config mc(.address(address_obs), .clock(clock), .data(300'd0), .wren(1'b0), .q(w_obstacle));
	
	// Direction register
	always@(posedge clock) begin
		if(!resetn) direction <= 2'd0;
		else if(up) direction <= 2'd0;
		else if(down) direction <= 2'd1;
		else if(left) direction <= 2'd2;
		else if(right) direction <= 2'd3;
	end
	
	// Determine valid move (S_CHECK_MOVE)
	always@(posedge clock) begin
		if(!resetn || reset_valid) begin
			char_empty <= 1'b0;
			char_obs <= 1'b0;
			char_box <= 1'b0;
			box_empty <= 1'b0;
		end
		// Check what is next to the character
		else if(check_char) begin
			// Check for obstacle
			if((direction == 2'd0 && w_obstacle[(y_chara - 1) * 20 + x_chara] ==  1) ||
				(direction == 2'd1 && w_obstacle[(y_chara + 1) * 20 + x_chara] ==  1) ||
				(direction == 2'd2 && w_obstacle[y_chara * 20 + x_chara - 1] ==  1) ||
				(direction == 2'd3 && w_obstacle[y_chara * 20 + x_chara + 1] ==  1))
				
					char_obs <= 1'b1;
			else if((direction == 2'd0 && x_chara == x_box_1 && y_chara - 1 == y_box_1) ||
					  (direction == 2'd0 && x_chara == x_box_2 && y_chara - 1 == y_box_2) ||
					  (direction == 2'd0 && x_chara == x_box_3 && y_chara - 1 == y_box_3) ||
					  (direction == 2'd1 && x_chara == x_box_1 && y_chara + 1 == y_box_1) ||
					  (direction == 2'd1 && x_chara == x_box_2 && y_chara + 1 == y_box_2) ||
					  (direction == 2'd1 && x_chara == x_box_3 && y_chara + 1 == y_box_3) ||
					  (direction == 2'd2 && y_chara == y_box_1 && x_chara - 1 == x_box_1) ||
					  (direction == 2'd2 && y_chara == y_box_2 && x_chara - 1 == x_box_2) ||
					  (direction == 2'd2 && y_chara == y_box_3 && x_chara - 1 == x_box_3) ||
					  (direction == 2'd3 && y_chara == y_box_1 && x_chara + 1 == x_box_1) ||
					  (direction == 2'd3 && y_chara == y_box_2 && x_chara + 1 == x_box_2) ||
					  (direction == 2'd3 && y_chara == y_box_3 && x_chara + 1 == x_box_3))

					char_box <= 1'b1;
			else
					char_empty <= 1'b1;
		end
		else if(check_box) begin
			if(direction == 2'd0) begin
				if(// Check for obstacle
					w_obstacle[(y_chara - 2) * 20 + x_chara] ==  0 && 
					// Check for existence of another box
					(x_chara != x_box_1 || y_chara - 2 != y_box_1) &&
					(x_chara != x_box_2 || y_chara - 2 != y_box_2) &&
					(x_chara != x_box_3 || y_chara - 2 != y_box_3))

					box_empty  <= 1'b1;
			end
			else if(direction == 2'd1) begin
				if(w_obstacle[(y_chara + 2) * 20 + x_chara] ==  0 &&
					(x_chara != x_box_1 || y_chara + 2 != y_box_1) &&
					(x_chara != x_box_2 || y_chara + 2 != y_box_2) &&
					(x_chara != x_box_3 || y_chara + 2 != y_box_3))
					
					box_empty <= 1'b1;
			end
			else if(direction == 2'd2) begin
				if(w_obstacle[y_chara * 20 + x_chara - 2] ==  0 &&
					(x_chara - 2 != x_box_1 || y_chara != y_box_1) &&
					(x_chara - 2 != x_box_2 || y_chara != y_box_2) &&
					(x_chara - 2 != x_box_3 || y_chara != y_box_3))
					
					box_empty <= 1'b1;
			end
			else if(direction == 2'd3) begin
				if(w_obstacle[y_chara * 20 + x_chara + 2] ==  0 &&
					(x_chara + 2 != x_box_1 || y_chara != y_box_1) &&
					(x_chara + 2 != x_box_2 || y_chara != y_box_2) &&
					(x_chara + 2 != x_box_3 || y_chara != y_box_3))
					
					box_empty <= 1'b1;
			end
		end
	end
	
	// Load destination location
	always@(posedge clock) begin
		if(!resetn) begin
			x_des_1 <= 5'd0;
			y_des_1 <= 4'd0;
			x_des_2 <= 5'd0;
			y_des_2 <= 4'd0;
			x_des_3 <= 5'd0;
			y_des_3 <= 4'd0;
		end
		else if(ld_map_0) begin
			x_des_1 <= 5'd7;
			y_des_1 <= 4'd9;
			x_des_2 <= 5'd9;
			y_des_2 <= 4'd9;
			x_des_3 <= 5'd11;
			y_des_3 <= 4'd9;
		end
		else if(ld_map_1) begin
			x_des_1 <= 5'd7;
			y_des_1 <= 4'd9;
			x_des_2 <= 5'd7;
			y_des_2 <= 4'd10;
			x_des_3 <= 5'd9;
			y_des_3 <= 4'd10;
		end
		else if(ld_map_2) begin
			x_des_1 <= 5'd6;
			y_des_1 <= 4'd5;
			x_des_2 <= 5'd8;
			y_des_2 <= 4'd6;
			x_des_3 <= 5'd11;
			y_des_3 <= 4'd6;
		end
		else if(ld_map_3) begin
			x_des_1 <= 5'd9;
			y_des_1 <= 4'd5;
			x_des_2 <= 5'd8;
			y_des_2 <= 4'd8;
			x_des_3 <= 5'd10;
			y_des_3 <= 4'd9;
		end
		else if(ld_map_4) begin
			x_des_1 <= 5'd9;
			y_des_1 <= 4'd4;
			x_des_2 <= 5'd7;
			y_des_2 <= 4'd7;
			x_des_3 <= 5'd11;
			y_des_3 <= 4'd6;
		end
		else if(ld_map_5) begin
			x_des_1 <= 5'd10;
			y_des_1 <= 4'd5;
			x_des_2 <= 5'd9;
			y_des_2 <= 4'd6;
			x_des_3 <= 5'd12;
			y_des_3 <= 4'd8;
		end
		else if(ld_map_6) begin
			x_des_1 <= 5'd9;
			y_des_1 <= 4'd7;
			x_des_2 <= 5'd10;
			y_des_2 <= 4'd8;
			x_des_3 <= 5'd11;
			y_des_3 <= 4'd7;
		end
		else if(ld_map_7) begin
			x_des_1 <= 5'd12;
			y_des_1 <= 4'd8;
			x_des_2 <= 5'd12;
			y_des_2 <= 4'd9;
			x_des_3 <= 5'd11;
			y_des_3 <= 4'd9;
		end
	end
	
	// Determine if winning
	always@(*) begin
		if(!resetn)
			win = 1'b0;
		else if(box_1_in && box_2_in && box_3_in)
			win = 1'b1;
		else
			win = 1'b0;
	end
	
	always@(*) begin
		box_1_in = 1'b0;
		box_2_in = 1'b0;
		box_3_in = 1'b0;
		if((x_box_1 == x_des_1 && y_box_1 == y_des_1) ||
			(x_box_1 == x_des_2 && y_box_1 == y_des_2) ||
			(x_box_1 == x_des_3 && y_box_1 == y_des_3))
			box_1_in = 1'b1;
		if((x_box_2 == x_des_1 && y_box_2 == y_des_1) ||
			(x_box_2 == x_des_2 && y_box_2 == y_des_2) ||
			(x_box_2 == x_des_3 && y_box_2 == y_des_3))
			box_2_in = 1'b1;
		if((x_box_3 == x_des_1 && y_box_3 == y_des_1) ||
			(x_box_3 == x_des_2 && y_box_3 == y_des_2) ||
			(x_box_3 == x_des_3 && y_box_3 == y_des_3))
			box_3_in = 1'b1;
	end
	
	// Character register
	always@(posedge clock) begin
		if(!resetn) begin
			x_chara <= 5'd0;
			y_chara <= 4'd0;
		end
		else if(ld_map_0) begin
			x_chara <= 5'd11;
			y_chara <= 4'd4;
		end
		else if(ld_map_1) begin
			x_chara <= 5'd9;
			y_chara <= 4'd4;
		end
		else if(ld_map_2) begin
			x_chara <= 5'd8;
			y_chara <= 4'd4;
		end
		else if(ld_map_3) begin
			x_chara <= 5'd13;
			y_chara <= 4'd8;
		end
		else if(ld_map_4) begin
			x_chara <= 5'd7;
			y_chara <= 4'd8;
		end
		else if(ld_map_5) begin
			x_chara <= 5'd12;
			y_chara <= 4'd5;
		end
		else if(ld_map_6) begin
			x_chara <= 5'd9;
			y_chara <= 4'd9;
		end
		else if(ld_map_7) begin
			x_chara <= 5'd8;
			y_chara <= 4'd4;
		end
		else if(update_char) begin
			if(direction == 2'd0) y_chara <= y_chara - 1; // up
			else if(direction == 2'd1) y_chara <= y_chara + 1; // down
			else if(direction == 2'd2) x_chara <= x_chara - 1; // left
			else if(direction == 2'd3) x_chara <= x_chara + 1; // right
		end
	end
	
	// Box register
	always@(posedge clock) begin
		if(!resetn) begin
			x_box_1 <= 5'd0;
			y_box_1 <= 4'd0;
			x_box_2 <= 5'd0;
			y_box_2 <= 4'd0;
			x_box_3 <= 5'd0;
			y_box_3 <= 4'd0;
		end
		else if(ld_map_0) begin
			x_box_1 <= 5'd11;
			y_box_1 <= 4'd6;
			x_box_2 <= 5'd9;
			y_box_2 <= 4'd7;
			x_box_3 <= 5'd9;
			y_box_3 <= 4'd8;
		end
		else if(ld_map_1) begin
			x_box_1 <= 5'd7;
			y_box_1 <= 4'd6;
			x_box_2 <= 5'd9;
			y_box_2 <= 4'd9;
			x_box_3 <= 5'd11;
			y_box_3 <= 4'd8;
		end
		else if(ld_map_2) begin
			x_box_1 <= 5'd7;
			y_box_1 <= 4'd5;
			x_box_2 <= 5'd12;
			y_box_2 <= 4'd5;
			x_box_3 <= 5'd8;
			y_box_3 <= 4'd8;
		end
		else if(ld_map_3) begin
			x_box_1 <= 5'd8;
			y_box_1 <= 4'd5;
			x_box_2 <= 5'd11;
			y_box_2 <= 4'd8;
			x_box_3 <= 5'd12;
			y_box_3 <= 4'd6;
		end
		else if(ld_map_4) begin
			x_box_1 <= 5'd9;
			y_box_1 <= 4'd6;
			x_box_2 <= 5'd8;
			y_box_2 <= 4'd8;
			x_box_3 <= 5'd10;
			y_box_3 <= 4'd6;
		end
		else if(ld_map_5) begin
			x_box_1 <= 5'd10;
			y_box_1 <= 4'd6;
			x_box_2 <= 5'd10;
			y_box_2 <= 4'd8;
			x_box_3 <= 5'd8;
			y_box_3 <= 4'd8;
		end
		else if(ld_map_6) begin
			x_box_1 <= 5'd8;
			y_box_1 <= 4'd6;
			x_box_2 <= 5'd8;
			y_box_2 <= 4'd7;
			x_box_3 <= 5'd10;
			y_box_3 <= 4'd7;
		end
		else if(ld_map_7) begin
			x_box_1 <= 5'd8;
			y_box_1 <= 4'd6;
			x_box_2 <= 5'd10;
			y_box_2 <= 4'd6;
			x_box_3 <= 5'd10;
			y_box_3 <= 4'd7;
		end
		else if(update_box) begin
			if(direction == 2'd0) begin // Up
				if(y_chara - 1 == y_box_1 && x_chara == x_box_1) y_box_1 <= y_box_1 - 1;
				else if(y_chara - 1 == y_box_2 && x_chara == x_box_2) y_box_2 <= y_box_2 - 1;
				else if(y_chara - 1 == y_box_3 && x_chara == x_box_3) y_box_3 <= y_box_3 - 1;
			end
			else if(direction == 2'd1) begin // Down
				if(y_chara + 1 == y_box_1 && x_chara == x_box_1) y_box_1 <= y_box_1 + 1;
				else if(y_chara + 1 == y_box_2 && x_chara == x_box_2) y_box_2 <= y_box_2 + 1;
				else if(y_chara + 1 == y_box_3 && x_chara == x_box_3) y_box_3 <= y_box_3 + 1;
			end
			else if(direction == 2'd2) begin // Left
				if(x_chara - 1 == x_box_1 && y_chara == y_box_1) x_box_1 <= x_box_1 - 1;
				else if(x_chara - 1 == x_box_2 && y_chara == y_box_2) x_box_2 <= x_box_2 - 1;
				else if(x_chara - 1 == x_box_3 && y_chara == y_box_3) x_box_3 <= x_box_3 - 1;
			end
			else if(direction == 2'd3) begin // Right
				if(x_chara + 1 == x_box_1 && y_chara == y_box_1) x_box_1 <= x_box_1 + 1;
				else if(x_chara + 1 == x_box_2 && y_chara == y_box_2) x_box_2 <= x_box_2 + 1;
				else if(x_chara + 1 == x_box_3 && y_chara == y_box_3) x_box_3 <= x_box_3 + 1;
			end
		end
	end
	
	
	/*******************************************************/
	/*                   Output registers                  */
	/*******************************************************/
	
	// xy output register
	always@(posedge clock) begin
		if(!resetn) begin
			x_out <= 8'd0;
			y_out <= 7'd0;
		end
		else if(ld_map_0 || ld_map_1 || ld_map_2 || ld_map_3 ||
				  ld_map_4 || ld_map_5 || ld_map_6 || ld_map_7 ||
				  draw_clear || draw_title || draw_ins || draw_select) begin
			x_out <= x_counter;
			y_out <= y_counter;
		end
		else if(clear_char || draw_char) begin
			x_out <= x_chara * 8 + counter[2:0];
			y_out <= y_chara * 8 + counter[5:3];
		end
		else if(draw_box) begin
			if(direction == 2'd0) begin // Up
				x_out <= x_chara * 8 + counter[2:0];
				y_out <= (y_chara - 2) * 8 + counter[5:3];
			end
			else if(direction == 2'd1) begin // Down
				x_out <= x_chara * 8 + counter[2:0];
				y_out <= (y_chara + 2) * 8 + counter[5:3];
			end
			else if(direction == 2'd2) begin // Left
				x_out <= (x_chara - 2) * 8 + counter[2:0];
				y_out <= y_chara * 8 + counter[5:3];
			end
			else if(direction == 2'd3) begin // Right
				x_out <= (x_chara + 2) * 8 + counter[2:0];
				y_out <= y_chara * 8 + counter[5:3];
			end
		end
	end
	
	// x counter register (traverse whole screen)
	always@(posedge clock) begin
		if(!resetn)
			x_counter <= 8'd0;
		else if(ld_map_0 || ld_map_1 || ld_map_2 || ld_map_3 ||
				  ld_map_4 || ld_map_5 || ld_map_6 || ld_map_7 ||
				  draw_clear || draw_title || draw_ins || draw_select) begin
			if(x_counter_clear) x_counter <= 8'd0;
			else x_counter <= x_counter + 1;
		end
		else x_counter <= 8'd0;
	end
	assign x_counter_clear = (x_counter == 8'd159);
	
	// y counter register (traverse whole screen)
	always@(posedge clock) begin
		if(!resetn)
			y_counter <= 7'd0;
		else if(ld_map_0 || ld_map_1 || ld_map_2 || ld_map_3 ||
				  ld_map_4 || ld_map_5 || ld_map_6 || ld_map_7 ||
				  draw_clear || draw_title || draw_ins || draw_select) begin
			if(x_counter_clear && y_counter_clear) y_counter <= 7'd0;
			else if(x_counter_clear) y_counter <= y_counter + 1;
		end
		else y_counter <= 7'd0;
	end
	assign y_counter_clear = (y_counter == 7'd119);
	
	// Colour register
	always@(*/*posedge clock*/) begin
		if(!resetn)
			colour_out = 3'd0;
		else if(ld_map_0)
			colour_out = map_colour_0;
		else if(ld_map_1)
			colour_out = map_colour_1;
		else if(ld_map_2)
			colour_out = map_colour_2;
		else if(ld_map_3)
			colour_out = map_colour_3;
		else if(ld_map_4)
			colour_out = map_colour_4;
		else if(ld_map_5)
			colour_out = map_colour_5;
		else if(ld_map_6)
			colour_out = map_colour_6;
		else if(ld_map_7)
			colour_out = map_colour_7;
		else if(draw_clear)
			colour_out = clear_colour;
		else if(draw_title)
			colour_out = title_colour;
		else if(draw_ins)
			colour_out = ins_colour;
		else if(draw_select)
			colour_out = select_colour;
		else if(clear_char) begin
			if ((x_chara == x_des_1 && y_chara == y_des_1) ||
				 (x_chara == x_des_2 && y_chara == y_des_2) ||
				 (x_chara == x_des_3 && y_chara == y_des_3))
				colour_out = dest_colour;
			else
				colour_out = path_colour;
		end
		else if(draw_char)
			colour_out = player_colour;
		else if(draw_box)
			colour_out = box_colour;
		else
			colour_out = 3'd0;
	end
	
		
	assign address_arena = x_counter + y_counter * 160;
	read_arena_0 r0(.address(address_arena), .clock(clock), .out(map_colour_0));
	read_arena_1 r1(.address(address_arena), .clock(clock), .out(map_colour_1));
	read_arena_2 r2(.address(address_arena), .clock(clock), .out(map_colour_2));
	read_arena_3 r3(.address(address_arena), .clock(clock), .out(map_colour_3));
	read_arena_4 r4(.address(address_arena), .clock(clock), .out(map_colour_4));
	read_arena_5 r5(.address(address_arena), .clock(clock), .out(map_colour_5));
	read_arena_6 r6(.address(address_arena), .clock(clock), .out(map_colour_6));
	read_arena_7 r7(.address(address_arena), .clock(clock), .out(map_colour_7));
	read_clear c1(.address(address_arena), .clock(clock), .out(clear_colour));
	read_title t1(.address(address_arena), .clock(clock), .out(title_colour));
	read_ins i1(.address(address_arena), .clock(clock), .out(ins_colour));
	read_select s1(.address(address_arena), .clock(clock), .out(select_colour));
	draw_player p1(.address(counter), .clock(clock), .out(player_colour));
	draw_box b1(.address(counter), .clock(clock), .out(box_colour));
	draw_path path(.address(counter), .clock(clock), .out(path_colour));
	draw_dest dest(.address(counter), .clock(clock), .out(dest_colour));
endmodule