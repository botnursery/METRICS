////////////////circuit pucker 4 - synchronous shift register///////////////////
module sha256_shifter(
	input  wire reset_n,
	input  wire load,
	input  wire clk,
	input  wire [511:0]parallel_in,
	input  wire [31:0]shift_in,
	output	wire [31:0]tap_15,
	output	wire [31:0]tap_14,
	output	wire [31:0]tap_6,
	output	wire [31:0]tap_1
);
genvar t;
	generate	for(t=0; t<16; t=t+1)	begin : STG
	wire [31:0]shift;
	reg [31:0]stage;
	wire [31:0]tap;

	assign STG[t].tap = STG[t].stage;
	assign tap_15 = STG[15].tap;
	assign tap_14 = STG[14].tap;
	assign tap_6 = STG[6].tap;
	assign tap_1 = STG[1].tap;

		if (t==0)
	assign STG[0].shift = shift_in;
		if (t<15)
	assign STG[t+1].shift = STG[t].tap;

	always @ (posedge clk or negedge reset_n)
		if (!reset_n)
      			STG[t].stage <= 32'h00000000;
		else
		if (load)
			STG[t].stage <= parallel_in[t*32 +: 32];
		else
			STG[t].stage <= STG[t].shift;
						end
	endgenerate
endmodule
