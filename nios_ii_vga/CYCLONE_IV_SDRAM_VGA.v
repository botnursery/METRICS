//=======================================================
//  	QMTECH NIOS II w SDRAM Program
//=======================================================
`timescale 1ns / 1ps
module CYCLONE_IV_SDRAM_VGA(
      ///////// Input CLOCK /////////
      input             CLOCK_50,
      ///////// DRAM /////////
      output    [12:0]	DRAM_ADDR,
      output    [1:0] 	DRAM_BA,
      output            DRAM_CAS_N,
      output          	DRAM_CKE,
      output            DRAM_CLK,
      output        		DRAM_CS_N,
      inout     [15:0]	DRAM_DQ,
      output            DRAM_LDQM,
      output            DRAM_RAS_N,
      output            DRAM_UDQM,
      output            DRAM_WE_N,
      ///////// Start KEY /////////
      input       		KEY,
      ///////// LEDR /////////
      output      		LEDR,
      ///////// RESET /////////
      input            	RESET_N,
      ///////// VGA Out /////////
		output 				vga_hs,
		output 				vga_vs,
		output [4:0] 		vga_r,
		output [5:0] 		vga_g,
		output [4:0] 		vga_b		
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire  [15:0]	gpio_export;
wire				sys_clk;
wire	[1:0]		sdram_dqm;

assign {DRAM_UDQM,DRAM_LDQM} = sdram_dqm;
assign LEDR = gpio_export[15]&KEY;

PLL_SDRAM u_pll (
		.areset(1'b0),
		.inclk0(CLOCK_50),					// clk.50
		.c0(sys_clk),							// 	.100
		.c1(DRAM_CLK),							//		.100shift
		.c2(vga_clk),							//		.vga
		.locked()
);

nios2_ram u_nios (
       .clk_clk       (sys_clk),			//		clk.clk
       .gpio_export   (gpio_export),	//  gpio.export
       .reset_reset_n (RESET_N),			// reset.reset_n
       .sdram_addr    (DRAM_ADDR),		// sdram.addr
       .sdram_ba      (DRAM_BA),			//      .ba
       .sdram_cas_n   (DRAM_CAS_N),		//      .cas_n
       .sdram_cke     (DRAM_CKE),		//      .cke
       .sdram_cs_n    (DRAM_CS_N),		//      .cs_n
       .sdram_dq      (DRAM_DQ),			//      .dq
       .sdram_dqm     (sdram_dqm),		//      .dqm
       .sdram_ras_n   (DRAM_RAS_N),		//      .ras_n
       .sdram_we_n    (DRAM_WE_N)		//      .we_n
);

vga_out u_vga (
		.gpio_export(gpio_export),
		.clk(vga_clk), 
		.hdata(hdata),
		.vdata(vdata),
		.hsync(vga_hs),
		.vsync(vga_vs),
		.de(de),
		.vga_r(vga_r), 
		.vga_g(vga_g), 
		.vga_b(vga_b)
);

endmodule
