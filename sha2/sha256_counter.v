////////circuit pucker 5 - round counter and control////////
module sha256_counter (readout, reset_n, inclk, i, ctrl);
	input  wire readout;
	input  wire reset_n;

	input  wire inclk;
	output reg [5:0]i;
	output wire [5:0]ctrl;


	reg load;
	reg n;
	reg [1:0]read_en;
	wire readout_en;
	wire ask;
	wire clk;

	assign	clk = inclk;	//temp dummy wire for PLL

	assign ctrl = {ask,readout_en,n,clk,load,reset_n};
	assign ask = (i==6'b000000) ? 1'b1:1'b0;
	assign readout_en = (read_en==2'b01) ? 1'b1:1'b0;
	
	always @ (negedge clk) 
	begin	
		if	(ask==1'b1)
			load = 1'b1;	
		else	if	 (ask==1'b0)
			load = 1'b0;
	end

	always @ (negedge clk or negedge readout)	
	begin
		if (!readout)
			read_en = 1'b0;
		else if  (load)
			read_en = read_en+1'b1;
	end	
	
	always @ (negedge clk or negedge reset_n)
	begin
		if (!reset_n)
			n = 1'b0;
		else if (i==6'b000000) 
			n = 1'b1;		
	end
	
	always @ (posedge clk or negedge reset_n) 
	begin
		if (!reset_n) 	
			i = 6'b000000;
		else
			i=i+1'b1;		
	end
endmodule
