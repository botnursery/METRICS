`timescale 1ns / 1ps
// 
// VGA 800 x 600 x 60Hz
// clock 40MHz
//
module vga_out
(
	input wire  [15:0] gpio_export,
	input wire clk,
	output wire hsync,
	output wire vsync,
	output wire [11:0] hdata,
	output wire [11:0] vdata,
	output wire de,
	output [4:0] vga_r,
	output [5:0] vga_g,
	output [4:0] vga_b
);
assign vga_r = gpio_export[4:0];
assign vga_g = gpio_export[5:0];
assign vga_b = gpio_export[4:0];

// Instantiate resolution
	vga #(12, 800, 840, 968, 1056, 600, 601, 605, 628, 1, 1) u_800x600 (
		.clk(clk), 
		.hdata(hdata),
		.vdata(vdata),
		.hsync(hsync),
		.vsync(vsync),
		.de(de)
	);
	
endmodule

// WIDTH: bits in register hdata & vdata
// HSIZE: horizontal size of visible field 
// HFP: horizontal front of pulse
// HSP: horizontal stop of pulse
// HMAX: horizontal max size of value
// VSIZE: vertical size of visible field 
// VFP: vertical front of pulse
// VSP: vertical stop of pulse
// VMAX: vertical max size of value
// HSPP: horizontal synchro pulse polarity (0 - negative, 1 - positive)
// VSPP: vertical synchro pulse polarity (0 - negative, 1 - positive)
// DE: signal BLANK (data enable)
//
module vga #(parameter WIDTH = 0, HSIZE = 0, HFP = 0, HSP = 0, HMAX = 0, VSIZE = 0, VFP = 0, VSP = 0, VMAX = 0, HSPP = 0, VSPP = 0)
(
	input clk,
	output reg hsync,
	output reg vsync,
	output reg [WIDTH - 1:0] hdata,
	output reg [WIDTH - 1:0] vdata,
	output wire de
);
// init
initial begin
	hdata <= 0;
	vdata <= 0;
end
// hdata
always @ (posedge clk)
begin
	if (hdata == (HMAX - 1))
		hdata <= 0;
	else
		hdata <= hdata + 1;
end
// vdata
always @ (posedge clk)
begin
	if (hdata == (HMAX - 1)) 
	begin
		if (vdata == (VMAX - 1))
			vdata <= 0;
		else
			vdata <= vdata + 1;
	end
end
// hsync & vsync & blank
always @*
begin
	if (HSPP == 0)	hsync <= ((hdata >= HFP) && (hdata < HSP)) ? 1'b0 : 1'b1;
	else				hsync <= ((hdata >= HFP) && (hdata < HSP)) ? 1'b1 : 1'b0;
	if (VSPP == 0)	vsync <= ((vdata >= VFP) && (vdata < VSP)) ? 1'b0 : 1'b1;
	else				vsync <= ((vdata >= VFP) && (vdata < VSP)) ? 1'b1 : 1'b0;
end
assign de = (hdata < HSIZE) && (vdata < VSIZE);

endmodule
