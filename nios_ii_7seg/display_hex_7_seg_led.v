//			hex nibbles to 7-segments LED encoding & render	pattern h.8.8.			//
// https://github.com/search?l=Verilog&o=desc&q=7+segment&s=&type=Repositories//

`timescale 1ns / 1ps
module display_hex_7_seg_led(
		input CLK,
		input RSTn, 
		input [7:0] Byte_data,
		output [2:0] Scan_Sig,
		output [7:0] SMG_Data  
);
		wire [6:0]seg_H;
		wire [6:0]seg_L;
		
smg_scan_tube smg_scan_tube_inst(
		.CLK	(CLK),			
		.RSTn	(RSTn),			
		.Scan_Sig	(Scan_Sig)			
);

led_7seg led_7seg_inst(					
		.Data_in	(Byte_data),			
		.seg_H		(seg_H), 
		.seg_L		(seg_L)
);

display_3_dig display_3_dig_inst(
		.CLK	(CLK),			
		.RSTn	(RSTn),
		.Scan_Sig	(Scan_Sig),
		.seg_H		(seg_H),
		.seg_L		(seg_L),
		.SMG_Data	(SMG_Data)
);
endmodule

/********************************/
//hex nibbles to 7-segments encode//
/********************************/
module led_7seg(
	input [7:0] Data_in,
	output [6:0] seg_H,
	output [6:0] seg_L
);
reg [6:0] SevenSeg_H;
reg [6:0] SevenSeg_L;

always @(*)
begin
	case(Data_in[3:0])
	4'h0: SevenSeg_L = 7'b0000001;		//0
   4'h1: SevenSeg_L = 7'b1001111;		//1
   4'h2: SevenSeg_L = 7'b0010010;		//2
   4'h3: SevenSeg_L = 7'b0000110;		//3
   4'h4: SevenSeg_L = 7'b1001100;		//4
   4'h5: SevenSeg_L = 7'b0100100;		//5
   4'h6: SevenSeg_L = 7'b0100000;		//6
   4'h7: SevenSeg_L = 7'b0001111;		//7
   4'h8: SevenSeg_L = 7'b0000000;		//8
   4'h9: SevenSeg_L = 7'b0001100;		//9
	4'ha: SevenSeg_L = 7'b0001000;		//A
	4'hb: SevenSeg_L = 7'b1100000;		//b
	4'hc: SevenSeg_L = 7'b0110001;		//C
	4'hd: SevenSeg_L = 7'b1000010;		//d
	4'he: SevenSeg_L = 7'b0110000;		//E
	4'hf: SevenSeg_L = 7'b0111000;		//F
	endcase
	case(Data_in[7:4])
	4'h0: SevenSeg_H = 7'b0000001;		//0
   4'h1: SevenSeg_H = 7'b1001111;		//1
   4'h2: SevenSeg_H = 7'b0010010;		//2
   4'h3: SevenSeg_H = 7'b0000110;		//3
   4'h4: SevenSeg_H = 7'b1001100;		//4
   4'h5: SevenSeg_H = 7'b0100100;		//5
   4'h6: SevenSeg_H = 7'b0100000;		//6
   4'h7: SevenSeg_H = 7'b0001111;		//7
   4'h8: SevenSeg_H = 7'b0000000;		//8
   4'h9: SevenSeg_H = 7'b0001100;		//9
	4'ha: SevenSeg_H = 7'b0001000;		//A
	4'hb: SevenSeg_H = 7'b1100000;		//b
	4'hc: SevenSeg_H = 7'b0110001;		//C
	4'hd: SevenSeg_H = 7'b1000010;		//d
	4'he: SevenSeg_H = 7'b0110000;		//E
	4'hf: SevenSeg_H = 7'b0111000;		//F
	endcase
end

	assign {seg_H[0],seg_H[1],seg_H[2],seg_H[3],seg_H[4],seg_H[5],seg_H[6]} = SevenSeg_H;
	assign {seg_L[0],seg_L[1],seg_L[2],seg_L[3],seg_L[4],seg_L[5],seg_L[6]} = SevenSeg_L;

endmodule

/*****************************/
//digital tube scanning module//
/*****************************/
module smg_scan_tube(
   input CLK, 
	input RSTn, 
	output [2:0]Scan_Sig
);

	parameter T1MS = 16'd49999;

	reg [15:0]C1;
	always @ ( posedge CLK or negedge RSTn )
	    if( !RSTn )
		    C1 <= 16'd0;
		else if( C1 == T1MS )					//	1ms per digit @ 50MHz clock
		    C1 <= 16'd0;
		else
		    C1 <= C1 + 1'b1;

	reg [3:0]i;
	reg [2:0]rScan;
	always @ ( posedge CLK or negedge RSTn )
	    if( !RSTn )
		    begin
		        i <= 4'd0;
		        rScan <= 3'b000;
			end
		else 
		    case( i )
				0:
				if( C1 == T1MS ) i <= i + 1'b1;
				else rScan <= 3'b100;				//the first digital strobe
				1:
				if( C1 == T1MS ) i <= i + 1'b1;
				else rScan <= 3'b010;				//second digital strobe
				2:
				if( C1 == T1MS ) i <= 4'd0;
				else rScan <= 3'b001;				//third digital strobe
			endcase	

	assign Scan_Sig = rScan;

endmodule

/******************************/
//display 3 digital sign module//
/******************************/
module display_3_dig(
		input CLK, 
		input RSTn, 
		input [2:0] Scan_Sig,
		input [6:0] seg_H,
		input [6:0] seg_L,
		output[7:0] SMG_Data
);

	parameter DP = 	3'b110;			//	points display position
	parameter RADIX = 7'b0001011;		//	"h" character
	parameter NONCE = 8'b10111111;	//	"-" character

	reg [7:0] interim;
	wire [7:0] interim_L,interim_H,interim_R,interim_N;
	assign interim_L = {DP[2],seg_L};
	assign interim_H = {DP[1],seg_H};
	assign interim_R = {DP[0],RADIX};
	assign interim_N = NONCE;
	
	always @ ( posedge CLK or negedge RSTn )
		if( !RSTn )	
			interim <= 8'b01111111;
		else
			interim <= (Scan_Sig==3'b100)?interim_R:((Scan_Sig==3'b010)?interim_H:((Scan_Sig==3'b001)?interim_L:interim_N));
	
	assign SMG_Data = interim;

endmodule
