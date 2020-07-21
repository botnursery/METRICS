////////circuit pucker 7 - synchronous duct with the shift register and separately readout, counter, ask////////
module sha256_duct #(parameter Z=12)( // Z desired leading zeroes
	input wire readout, // 1 - inquiring resulting digest for last message block
	input wire reset_n,	// 1 - not acting level

	input wire inclk, // duty cycle 2 external clocking
	input wire [511:0]block_n, // 512bit message block N
	output wire result, // 0 - zeros condition is met
	output wire [7:0]hash, // digest serial output
	output wire ask // 1 - request for the next block N

);
	wire [5:0]ctrl;
	wire [5:0]i;
	wire [31:0]wi;
	wire [31:0]ki;
	wire [255:0]inquiry_digest;
		
sha256_counter tact_i_n (
	.readout( readout ),
	.reset_n( reset_n ), 

	.inclk( inclk ),
	.i( i ),
	.ctrl( ctrl )

	);

sha256_transform ki_wi (
	.ctrl( ctrl ),
	.i( i ),
	.data_in( block_n ),
	.Wi( wi ),
	.Ki( ki )
	);

sha256_round hash_i (
	.ctrl( ctrl ),
	.i( i ),
	.k( ki ), 
	.w( wi ), 
	.inquiry_digest( inquiry_digest )
	);
	
sha256_readout result_n (
	.block_n( block_n ),
	.inquiry_digest( inquiry_digest ), 
	.result( result ),
	.hash( hash )
	);

	assign ask = ctrl[5];
	
endmodule

module sha256_readout  (block_n, inquiry_digest, result, hash);
	input wire [511:0]block_n;
	input wire [255:0]inquiry_digest;
	output wire result;
	output wire [7:0]hash;

	assign result = (inquiry_digest ==	block_n) ? 1'b0:1'b1;
	assign hash = inquiry_digest[7:0];

endmodule
