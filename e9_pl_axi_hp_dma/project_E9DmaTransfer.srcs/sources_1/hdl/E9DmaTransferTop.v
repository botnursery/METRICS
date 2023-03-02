/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog 20.51
-- Input file was: DmaTransfer.vhd github.com/Finnetrib/DmaTransfer
-- Command line was: D:\SynaptiCAD\bin\win32\vhdl2verilog.exe DmaTransfer.vhd -ncc
-- Date Created: Wed Mar 01 22:06:06 2023

*******************************************************************************/

`define false 1'b 0
`define FALSE 1'b 0
`define true 1'b 1
`define TRUE 1'b 1

`timescale 1 ns / 1 ns // timescale for following modules


// ---------------------------------------------------------------------------------
//  Company:
//  Engineer:
// 
//  Create Date: 16.12.2020 11:18:38
//  Design Name:
//  Module Name: DmaTransfer - Behavioral
//  Project Name:
//  Target Devices:
//  Tool Versions:
//  Description:
// 
//  Dependencies:
// 
//  Revision:
//  Revision 0.01 - File Created
//  Additional Comments:
// 
// --------------------------------------------------------------------------------
//  Uncomment the following library declaration if using
//  arithmetic functions with Signed or Unsigned values
// use IEEE.NUMERIC_STD.ALL;
//  Uncomment the following library declaration if instantiating
//  any Xilinx leaf cells in this code.
// library UNISIM;
// use UNISIM.VComponents.all;

module E9DmaTransferTop (
   DDR_addr,
   DDR_ba,
   DDR_cas_n,
   DDR_ck_n,
   DDR_ck_p,
   DDR_cke,
   DDR_cs_n,
   DDR_dm,
   DDR_dq,
   DDR_dqs_n,
   DDR_dqs_p,
   DDR_odt,
   DDR_ras_n,
   DDR_reset_n,
   DDR_we_n,
   FIXED_IO_ddr_vrn,
   FIXED_IO_ddr_vrp,
   FIXED_IO_mio,
   FIXED_IO_ps_clk,
   FIXED_IO_ps_porb,
   FIXED_IO_ps_srstb);
 

inout   [14:0] DDR_addr; 
inout   [2:0] DDR_ba; 
inout   DDR_cas_n; 
inout   DDR_ck_n; 
inout   DDR_ck_p; 
inout   DDR_cke; 
inout   DDR_cs_n; 
inout   [3:0] DDR_dm; 
inout   [31:0] DDR_dq; 
inout   [3:0] DDR_dqs_n; 
inout   [3:0] DDR_dqs_p; 
inout   DDR_odt; 
inout   DDR_ras_n; 
inout   DDR_reset_n; 
inout   DDR_we_n; 
inout   FIXED_IO_ddr_vrn; 
inout   FIXED_IO_ddr_vrp; 
inout   [53:0] FIXED_IO_mio; 
inout   FIXED_IO_ps_clk; 
inout   FIXED_IO_ps_porb; 
inout   FIXED_IO_ps_srstb; 

wire    [14:0] VHDL2V_DDR_addr; 
wire    [2:0] VHDL2V_DDR_ba; 
wire    VHDL2V_DDR_cas_n; 
wire    VHDL2V_DDR_ck_n; 
wire    VHDL2V_DDR_ck_p; 
wire    VHDL2V_DDR_cke; 
wire    VHDL2V_DDR_cs_n; 
wire    [3:0] VHDL2V_DDR_dm; 
wire    [31:0] VHDL2V_DDR_dq; 
wire    [3:0] VHDL2V_DDR_dqs_n; 
wire    [3:0] VHDL2V_DDR_dqs_p; 
wire    VHDL2V_DDR_odt; 
wire    VHDL2V_DDR_ras_n; 
wire    VHDL2V_DDR_reset_n; 
wire    VHDL2V_DDR_we_n; 
wire    VHDL2V_FIXED_IO_ddr_vrn; 
wire    VHDL2V_FIXED_IO_ddr_vrp; 
wire    [53:0] VHDL2V_FIXED_IO_mio; 
wire    VHDL2V_FIXED_IO_ps_clk; 
wire    VHDL2V_FIXED_IO_ps_porb; 
wire    VHDL2V_FIXED_IO_ps_srstb; 
wire    [14:0] DDR_addr; 
wire    [2:0] DDR_ba; 
wire    DDR_cas_n; 
wire    DDR_ck_n; 
wire    DDR_ck_p; 
wire    DDR_cke; 
wire    DDR_cs_n; 
wire    [3:0] DDR_dm; 
wire    [31:0] DDR_dq; 
wire    [3:0] DDR_dqs_n; 
wire    [3:0] DDR_dqs_p; 
wire    DDR_odt; 
wire    DDR_ras_n; 
wire    DDR_reset_n; 
wire    DDR_we_n; 
wire    FIXED_IO_ddr_vrn; 
wire    FIXED_IO_ddr_vrp; 
wire    [53:0] FIXED_IO_mio; 
wire    FIXED_IO_ps_clk; 
wire    FIXED_IO_ps_porb; 
wire    FIXED_IO_ps_srstb; 
wire    [31:0] RxData; 
wire    [3:0] RxKeep; 
wire    RxLast; 
wire    RxValid; 
wire    RxReady; 
wire    [31:0] TxData; 
wire    [3:0] TxKeep; 
wire    TxLast; 
wire    TxValid; 
wire    TxReady; 
wire    clk; 
wire    rst; 
wire    [36:0] FifoDataW; 
wire    FifoWrite; 
wire    FifoRead; 
wire    [36:0] FifoDataR; 
wire    FifoEmpty; 
wire    FifoFull; 
wire    VHDL2V_open; 

E9DmaTransferPS PS (.DDR_addr(DDR_addr),
          .DDR_ba(DDR_ba),
          .DDR_cas_n(DDR_cas_n),
          .DDR_ck_n(DDR_ck_n),
          .DDR_ck_p(DDR_ck_p),
          .DDR_cke(DDR_cke),
          .DDR_cs_n(DDR_cs_n),
          .DDR_dm(DDR_dm),
          .DDR_dq(DDR_dq),
          .DDR_dqs_n(DDR_dqs_n),
          .DDR_dqs_p(DDR_dqs_p),
          .DDR_odt(DDR_odt),
          .DDR_ras_n(DDR_ras_n),
          .DDR_reset_n(DDR_reset_n),
          .DDR_we_n(DDR_we_n),
          .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
          .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
          .FIXED_IO_mio(FIXED_IO_mio),
          .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
          .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
          .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
          
//  Dma Channel
          .iDmaRx_tdata(RxData),
          .iDmaRx_tkeep(RxKeep),
          .iDmaRx_tlast(RxLast),
          .iDmaRx_tready(RxReady),
          .iDmaRx_tvalid(RxValid),
          .oDmaTx_tdata(TxData),
          .oDmaTx_tkeep(TxKeep),
          .oDmaTx_tlast(TxLast),
          .oDmaTx_tready(TxReady),
          .oDmaTx_tvalid(TxValid),
          
//  System
          .oZynqClk(clk),
          .oZynqRst(rst));
assign FifoDataW[31:0] = ~TxData; 
assign FifoDataW[35:32] = TxKeep; 
assign FifoDataW[36] = TxLast; 
assign FifoWrite = TxValid & ~FifoFull; 
assign TxReady = ~FifoFull; 
SyncFifoBram37x1024 EchFifo (.clk(clk),
          .srst(rst),
          .din(FifoDataW),
          .wr_en(FifoWrite),
          .rd_en(FifoRead),
          .dout(FifoDataR),
          .full(),
          .empty(FifoEmpty),
          .prog_full(FifoFull));
assign RxData = FifoDataR[31:0]; 
assign RxKeep = FifoDataR[35:32]; 
assign RxLast = FifoDataR[36]; 
assign RxValid = ~FifoEmpty; 
assign FifoRead = RxReady; 
assign DDR_addr = VHDL2V_DDR_addr; 
assign DDR_ba = VHDL2V_DDR_ba; 
assign DDR_cas_n = VHDL2V_DDR_cas_n; 
assign DDR_ck_n = VHDL2V_DDR_ck_n; 
assign DDR_ck_p = VHDL2V_DDR_ck_p; 
assign DDR_cke = VHDL2V_DDR_cke; 
assign DDR_cs_n = VHDL2V_DDR_cs_n; 
assign DDR_dm = VHDL2V_DDR_dm; 
assign DDR_dq = VHDL2V_DDR_dq; 
assign DDR_dqs_n = VHDL2V_DDR_dqs_n; 
assign DDR_dqs_p = VHDL2V_DDR_dqs_p; 
assign DDR_odt = VHDL2V_DDR_odt; 
assign DDR_ras_n = VHDL2V_DDR_ras_n; 
assign DDR_reset_n = VHDL2V_DDR_reset_n; 
assign DDR_we_n = VHDL2V_DDR_we_n; 
assign FIXED_IO_ddr_vrn = VHDL2V_FIXED_IO_ddr_vrn; 
assign FIXED_IO_ddr_vrp = VHDL2V_FIXED_IO_ddr_vrp; 
assign FIXED_IO_mio = VHDL2V_FIXED_IO_mio; 
assign FIXED_IO_ps_clk = VHDL2V_FIXED_IO_ps_clk; 
assign FIXED_IO_ps_porb = VHDL2V_FIXED_IO_ps_porb; 
assign FIXED_IO_ps_srstb = VHDL2V_FIXED_IO_ps_srstb; 

endmodule // module E9DmaTransferTop
