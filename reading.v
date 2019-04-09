module read_title(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	title_ram title1(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule

module read_ins(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	ins_ram ins1(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule

module read_clear(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	clear_ram clear1(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule

module read_select(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	select_ram select1(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule

module read_arena_0(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena0_map map0(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module read_arena_1(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena1_map map1(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module read_arena_2(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena2_map map2(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module read_arena_3(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena3_map map3(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module read_arena_4(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena4_map map4(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module read_arena_5(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena5_map map5(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module read_arena_6(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena6_map map6(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module read_arena_7(address, clock, out);
	input [14:0] address;
	input clock;
	output [2:0] out;
	
	arena7_map map7(
		.address(address), 
		.clock(clock), 
		.data(3'b000),  
		.wren(1'b0), 
		.q(out));
endmodule

module draw_player (address, clock, out);
	input [5:0] address;
	input clock;
	output [2:0] out;
	
	player_ram player1(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule

module draw_box (address, clock, out);
	input [5:0] address;
	input clock;
	output [2:0] out;
	
	box_ram box(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule

module draw_path (address, clock, out);
	input [5:0] address;
	input clock;
	output [2:0] out;
	
	path_ram path(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule

module draw_dest (address, clock, out);
	input [5:0] address;
	input clock;
	output [2:0] out;
	
	dest_ram dest(
		.address(address),
		.clock(clock),
		.data(3'b000),
		.wren(1'b0),
		.q(out));
endmodule