module vga_in
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,								// On Board Keys
		SW,								// On Board Switchs
		
		// Keyboard
		PS2_CLK, 
		PS2_DAT,
		
		// Other things
		LEDR,								// On Board Leds
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX5,
		
		// VGA ports
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   							//	VGA Blue[9:0]
		
		// Audio ports
		AUD_ADCDAT,
		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,
		FPGA_I2C_SDAT,
		// Outputs
		AUD_XCK,
		AUD_DACDAT,
		FPGA_I2C_SCLK,
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;		
	input [9:0] SW;
	
	/*****************************************************************************
	 *                                Keyboard                                   *
	 *****************************************************************************/
	
	//added
	inout PS2_CLK, PS2_DAT;
	
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX5;
	
	my_keyboard keyboard(
			.CLOCK_50(CLOCK_50), 
			.PS2_CLK(PS2_CLK), 
			.PS2_DAT(PS2_DAT), 
			.reset(resetn), 
			.up(up), 
			.down(down), 
			.left(left), 
			.right(right), 
			.space(space), 
			.restart(restart), 
			.quit(quit),
			.select(select)
		);
	
	
	/*****************************************************************************
	 *                                VGA Ports                                  *
	 *****************************************************************************/
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "title.mif";
		
	/*****************************************************************************
	 *                              Audio Ports                                  *
	 *****************************************************************************/
	input				AUD_ADCDAT;

	// Bidirectionals
	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				FPGA_I2C_SDAT;

	// Outputs
	output				AUD_XCK;
	output				AUD_DACDAT;

	output				FPGA_I2C_SCLK;
	
	bgm bgm1(
			.CLOCK_50(CLOCK_50), 
			.resetn(resetn), 
			
			.AUD_ADCDAT(AUD_ADCDAT),

			// Bidirectionals
			.AUD_BCLK(AUD_BCLK),
			.AUD_ADCLRCK(AUD_ADCLRCK),
			.AUD_DACLRCK(AUD_DACLRCK),

			.FPGA_I2C_SDAT(FPGA_I2C_SDAT),

			// Outputs
			.AUD_XCK(AUD_XCK),
			.AUD_DACDAT(AUD_DACDAT),

			.FPGA_I2C_SCLK(FPGA_I2C_SCLK));
			
	/*****************************************************************************
	 *                               Game Ports                                  *
	 *****************************************************************************/
	wire up, down, left, right, space, restart, quit;
	
	wire [5:0] w_current, w_next;
	wire [2:0] w_stage;
	wire go_select;
	wire select_0;
	wire select_1;
	wire select_2;
	wire select_3;
	wire select_4;
	wire select_5;
	wire select_6;
	wire select_7;
	
	wire [7:0] x_game;
	wire [6:0] y_game;
	wire [2:0] colour_game;
	wire wren_game;
	wire [7:0] x_select;
	wire [6:0] y_select;
	wire [2:0] colour_select;
	wire wren_select;
	
	game_connect gc(
			.clock(CLOCK_50),
			.resetn(resetn),
			.start(space),
			.continue(space),
			.restart(restart),
			.quit(quit),
			.select(select),
			.up(up), .down(down),
			.left(left), .right(right),
			.select_0(select_0),
			.select_1(select_1),
			.select_2(select_2),
			.select_3(select_3),
			.select_4(select_4),
			.select_5(select_5),
			.select_6(select_6),
			.select_7(select_7),
			.go_select(go_select),
			.x_o(x_game),
			.y_o(y_game),
			.colour_o(colour_game),
			.wren(wren_game),
			.current(w_current),
			.next(w_next),
			.stage_reg(w_stage)
		);
	
	select_connect sc(
			.clock(CLOCK_50),
			.resetn(resetn),
			.quit(quit),
			.decide(space),
			.left(left),
			.right(right),
			.go_select(go_select),
			.select_0(select_0),
			.select_1(select_1),
			.select_2(select_2),
			.select_3(select_3),
			.select_4(select_4),
			.select_5(select_5),
			.select_6(select_6),
			.select_7(select_7),
			.x(x_select),
			.y(y_select),
			.colour(colour_select),
			.wren(wren_select),
			.current(LEDR[6:4]),
			.next(LEDR[9:7]));
		
	assign x = go_select ? x_select : x_game;
	assign y = go_select ? y_select : y_game;
	assign colour = go_select ? colour_select : colour_game;
	assign writeEn = wren_select | wren_game;
	
	assign LEDR[0] = go_select;
	
	HEX_Display h0(.in(w_current[3:0]), .out(HEX0));
	HEX_Display h1(.in({1'b0, 1'b0, w_current[5:4]}), .out(HEX1));
	HEX_Display h2(.in(w_next[3:0]), .out(HEX2));
	HEX_Display h3(.in({1'b0, 1'b0, w_next[5:4]}), .out(HEX3));
	HEX_Display h5(.in({1'b0, w_stage}), .out(HEX5));
	
endmodule

module HEX_Display(in, out);
	input [3:0] in;
	output reg [6:0] out;
	
	always@(*)
	begin
		case(in[3:0])
			4'b0000: out = 7'b1000000;
			4'b0001: out = 7'b1111001;
			4'b0010: out = 7'b0100100;
			4'b0011: out = 7'b0110000;
			4'b0100: out = 7'b0011001;
			4'b0101: out = 7'b0010010;
			4'b0110: out = 7'b0000010;
			4'b0111: out = 7'b1111000;
			4'b1000: out = 7'b0000000;
			4'b1001: out = 7'b0010000;
			4'b1010: out = 7'b0001000;
			4'b1011: out = 7'b0000011;
			4'b1100: out = 7'b1000110;
			4'b1101: out = 7'b0100001;
			4'b1110: out = 7'b0000110;
			4'b1111: out = 7'b0001110;
		endcase
	end
endmodule
