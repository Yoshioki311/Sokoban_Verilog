
module bgm (
	// Inputs
	CLOCK_50,
	resetn,

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

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input				resetn;

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

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;


// My wire
wire		[9:0] left_out, right_out;
wire		[31:0] left_sound, right_sound;
wire		[15:0] address;

// Internal Registers

reg		[15:0] address_counter;
reg		[3:0] delay_counter;
reg		[31:0] left_reg, right_reg;

/*
reg [18:0] delay_cnt;
wire [18:0] delay;

reg snd;
*/

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

 /*
always @(posedge CLOCK_50)
	if(delay_cnt == delay) begin
		delay_cnt <= 0;
		snd <= !snd;
	end else delay_cnt <= delay_cnt + 1;
*/

always@(posedge CLOCK_50) begin
	if(audio_out_allowed) begin
		if(delay_counter == 4'd8) begin
			if(address_counter > 16'd54205)
				address_counter <= 16'd0;
			else
				address_counter <= address_counter + 1;
			delay_counter <= 4'd0;
		end
		else begin
			delay_counter <= delay_counter + 1;
			left_reg <= left_sound;
			right_reg <= right_sound;
		end
	end
end
assign address = address_counter;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// assign delay = {SW[3:0], 15'd3000};

// wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;
assign left_sound = {left_out, 22'd0};
assign right_sound = {right_out, 22'd0};

assign read_audio_in			= 0;// audio_in_available & audio_out_allowed;

assign left_channel_audio_out	= /*left_channel_audio_in + */left_reg;
assign right_channel_audio_out	= /*right_channel_audio_in + */right_reg;
assign write_audio_out			= /*audio_in_available & */audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

left  l0(.address(address), .clock(CLOCK_50), .data(), .wren(1'b0), .q(left_out));
right r0(.address(address), .clock(CLOCK_50), .data(), .wren(1'b0), .q(right_out));
 
Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~resetn),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT)

);

avconf /*#(.USE_MIC_INPUT(1))*/ avc (
	.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
	.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~resetn)
);

endmodule

