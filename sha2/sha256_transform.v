////////circuit pucker 5 - transform constant values and words of the message schedule////////
module sha256_transform(
	input  wire [5:0]ctrl,
	input  wire [5:0]i,

	input  wire [511:0]data_in,

	output reg [31:0]Wi,
	output reg [31:0]Ki
);
	wire reset_n = ctrl[0];
	wire load = ctrl[1];
	wire clk = ctrl[2];

	wire [31:0]tap16;
	wire [31:0]tap15;
	wire [31:0]tap7;
	wire [31:0]tap2;
	wire [31:0]tap63;


sha256_shifter w_t(
	.reset_n( reset_n ),
	.load( load ),
	.clk( clk ),
	.parallel_in( data_in ),

	.shift_in( tap63 ),
	.tap_15( tap16 ),
	.tap_14( tap15 ),
	.tap_6( tap7 ),
	.tap_1( tap2 )
	);
	
	wire [31:0]s0_w; s0 s0_(tap15,s0_w);
	wire [31:0]s1_w; s1 s1_(tap2,s1_w);
	assign	tap63 = s1_w + tap7 + s0_w + tap16;

	wire [31:0]k_i;	rom_ks rom_k_i(i,k_i);
	
	always @ (posedge clk or negedge reset_n) 
	begin
		if (!reset_n) 
			begin

				Wi = 32'h00000000;
				Ki = 32'h00000000;
			end
		else
			begin
				Wi = tap16;
				Ki = k_i;
			end

	end
endmodule

module s0 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y[31:29] = x[6:4] ^ x[17:15];
	assign y[28:0] = {x[3:0], x[31:7]} ^ {x[14:0],x[31:18]} ^ x[31:3];
endmodule

module s1 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y[31:22] = x[16:7] ^ x[18:9];
	assign y[21:0] = {x[6:0],x[31:17]} ^ {x[8:0],x[31:19]} ^ x[31:10];
endmodule

module rom_ks (x, y);
	input [5:0] x;
	output [31:0] y;
		localparam Ks = {
		32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
		32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
		32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3,
		32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
		32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc,
		32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
		32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7,
		32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
		32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13,
		32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
		32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3,
		32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
		32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5,
		32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
		32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208,
		32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2
		};

		wire [2047:0]K_; assign K_ = {Ks[31:0],Ks[2047:32]};
		assign y = K_[(63-x)*32 +: 32];
endmodule
