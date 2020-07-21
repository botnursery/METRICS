////////circuit pucker 5 - round logic and message digest readout control////////
module sha256_round (
	input  wire [5:0]ctrl,
	input  wire [5:0]i,
	input  wire [ 31:0]k, 
	input  wire [ 31:0]w, 
	output wire[255:0]inquiry_digest
);
	wire [255:0]in;
	wire [255:0]out;

	sha256_digest drive_i_n (
	.ctrl( ctrl ),
	.i( i ),
	.digest_in( out ),
	.digest_out( in ),
	.digest_n( inquiry_digest )
	);
	
	wire [31:0]a; assign a = in[ 31:  0];
	wire [31:0]b; assign b = in[ 63: 32];
	wire [31:0]c; assign c = in[ 95: 64];
	wire [31:0]d; assign d = in[127: 96];
	wire [31:0]e; assign e = in[159:128];
	wire [31:0]f; assign f = in[191:160];
	wire [31:0]g; assign g = in[223:192];
	wire [31:0]h; assign h = in[255:224];
	
	wire [31:0]e0_w; e0 e0_(a,e0_w);
	wire [31:0]e1_w; e1 e1_(e,e1_w);
	wire [31:0]ch_w; ch ch_(e,f,g,ch_w);
	wire [31:0]mj_w; maj maj_(a,b,c,mj_w);
	
	wire [31:0]t1; assign t1 = h+w+k+ch_w+e1_w;
	wire [31:0]t2; assign t2 = mj_w+e0_w;
	wire [31:0]a_; assign a_ = t1+t2;
	wire [31:0]d_; assign d_ = d+t1;
	
	assign out = { g,f,e,d_,c,b,a,a_ };
endmodule

module e0 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y = {x[1:0],x[31:2]} ^ {x[12:0],x[31:13]} ^ {x[21:0],x[31:22]};
endmodule

module e1 (x, y);
	input [31:0] x;
	output [31:0] y;
	assign y = {x[5:0],x[31:6]} ^ {x[10:0],x[31:11]} ^ {x[24:0],x[31:25]};
endmodule

module ch (x, y, z, o);
	input [31:0] x, y, z;
	output [31:0] o;
	assign o = z ^ (x & (y ^ z));
endmodule

module maj (x, y, z, o);
	input [31:0] x, y, z;
	output [31:0] o;
	assign o = (x & y) | (z & (x | y));
endmodule

module sha256_digest (ctrl, i, digest_in, digest_out, digest_n);
	input wire [5:0] ctrl;
	input wire [5:0] i;
	input wire [255:0] digest_in;
	output wire [255:0] digest_out;
	output wire [255:0] digest_n;

localparam Hs = 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667;

	wire [255:0]hash_0 = Hs;
	wire [255:0]hash_n;
	wire [255:0]hash_63;
	wire reset_n = ctrl[0];

	wire clk = ctrl[2];
	wire n_initial = ctrl[3];
	wire readout_en = ctrl[4];

	reg [255:0]hash;
	reg [255:0]digest;
	reg [5:0]ilag;
	
	assign	hash_63 = (n_initial==1'b0) ? hash_0:hash_n;
	assign	digest_out = digest;
	assign	digest_n = (ilag==6'b000001 & readout_en==1'b1) ? hash:256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
	
		always @ (posedge clk or negedge reset_n)
		begin
			if (!reset_n)
				begin
				ilag <= 0;
				hash <= 0;
				digest <= 0;
				end
			else
				begin
				ilag <= i;
				hash <= (ilag==1'b0) ? hash_63:hash;
				digest <= (ilag==1'b0) ? hash_63:digest_in;
				end
		end

	interim_hash n_(
	.h_0( hash ),
	.h_63( digest_in ),
	.h_n( hash_n )
	);

endmodule

module interim_hash (h_0, h_63, h_n);
	input wire [255:0] h_0;
	input wire [255:0] h_63;
	output wire [255:0] h_n;

	wire [31:0]a; assign a = h_0[ 31:  0];
	wire [31:0]b; assign b = h_0[ 63: 32];
	wire [31:0]c; assign c = h_0[ 95: 64];
	wire [31:0]d; assign d = h_0[127: 96];
	wire [31:0]e; assign e = h_0[159:128];
	wire [31:0]f; assign f = h_0[191:160];
	wire [31:0]g; assign g = h_0[223:192];
	wire [31:0]h; assign h = h_0[255:224];

	wire [31:0]a1; assign a1 = h_63[ 31:  0];
	wire [31:0]b1; assign b1 = h_63[ 63: 32];
	wire [31:0]c1; assign c1 = h_63[ 95: 64];
	wire [31:0]d1; assign d1 = h_63[127: 96];
	wire [31:0]e1; assign e1 = h_63[159:128];
	wire [31:0]f1; assign f1 = h_63[191:160];
	wire [31:0]g1; assign g1 = h_63[223:192];
	wire [31:0]h1; assign h1 = h_63[255:224];

	wire [31:0]a2; assign a2 = a+a1;
	wire [31:0]b2; assign b2 = b+b1;
	wire [31:0]c2; assign c2 = c+c1;
	wire [31:0]d2; assign d2 = d+d1;
	wire [31:0]e2; assign e2 = e+e1;
	wire [31:0]f2; assign f2 = f+f1;
	wire [31:0]g2; assign g2 = g+g1;
	wire [31:0]h2; assign h2 = h+h1;
	assign h_n = {h2,g2,f2,e2,d2,c2,b2,a2};
	
endmodule
