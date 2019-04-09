module my_keyboard(CLOCK_50, PS2_CLK, PS2_DAT, reset, up, down, 
							left, right, space, restart, quit, select);
	//input
	input CLOCK_50;
	input reset;
	
	//bidirectional
	inout	PS2_CLK;
	inout PS2_DAT;
	
	//output
	output reg up, down, left, right, space, restart, quit, select;
	
	//wires
	wire		[7:0]	ps2_key_data;
	wire				ps2_key_pressed;
	
	//regs
	reg [7:0] ps2_key_data_1, ps2_key_data_2, ps2_key_data_3;
	
	//dataflow
	always @(posedge CLOCK_50) begin	
		if (!reset) begin
			ps2_key_data_1 <= 8'b0;
			ps2_key_data_2 <= 8'b0;
			ps2_key_data_3 <= 8'b0;
		end
		else if (ps2_key_pressed) begin
			ps2_key_data_1 <= ps2_key_data_2;
			ps2_key_data_2 <= ps2_key_data_3;
			ps2_key_data_3 <= ps2_key_data;
		end
		/*
		else begin
			ps2_key_data_1 <= 8'b0;
			ps2_key_data_2 <= 8'b0;
			ps2_key_data_3 <= 8'b0;
		end
		*/
	end
	
	//up
	always @(posedge CLOCK_50) begin
		if (!reset)
			up <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h75)
			up <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h75)
			up <= 1'b0;
	end
	
	//down
	always @(posedge CLOCK_50) begin
		if (!reset) 
			down <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h72)
			down <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h72)
			down <= 1'b0;
	end
	
	//left
	always @(posedge CLOCK_50) begin
		if (!reset)
			left <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h6B)
			left <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h6B)
			left <= 1'b0;
	end
	
	//right
	always @(posedge CLOCK_50) begin
		if (!reset)
			right <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h74)
			right <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h74)
			right <= 1'b0;
	end
	
	//space
	always @(posedge CLOCK_50) begin
		if (!reset) 
			space <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h29)
			space <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h29)
			space <= 1'b0;
	end
	
	//restart
	always @(posedge CLOCK_50) begin
		if (!reset)
			restart <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h2D)
			restart <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h2D)
			restart <= 1'b0;
	end
	
	//quit
	always @(posedge CLOCK_50) begin
		if (!reset)
			quit <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h76)
			quit <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h76)
			quit <= 1'b0;
	end
	
	//select
	always @(posedge CLOCK_50) begin
		if (!reset) 
			select <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h24)
			select <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h24)
			select <= 1'b0;
	end
		
	PS2_Controller PS2 (
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(reset),

		// Bidirectionals
		.PS2_CLK			(PS2_CLK),
		.PS2_DAT			(PS2_DAT),

		// Outputs
		.received_data		(ps2_key_data),
		.received_data_en	(ps2_key_pressed)
	);

endmodule
