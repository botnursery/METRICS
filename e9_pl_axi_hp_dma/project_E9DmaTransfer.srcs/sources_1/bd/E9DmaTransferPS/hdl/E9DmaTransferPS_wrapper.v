//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3.1 (win64) Build 2489853 Tue Mar 26 04:20:25 MDT 2019
//Date        : Fri Mar 24 13:03:31 2023
//Host        : NUC running 64-bit major release  (build 9200)
//Command     : generate_target E9DmaTransferPS_wrapper.bd
//Design      : E9DmaTransferPS_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module E9DmaTransferPS_wrapper
   (DDR_addr,
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
    FIXED_IO_ps_srstb,
    iDmaRx_tdata,
    iDmaRx_tkeep,
    iDmaRx_tlast,
    iDmaRx_tready,
    iDmaRx_tvalid,
    oDmaTx_tdata,
    oDmaTx_tkeep,
    oDmaTx_tlast,
    oDmaTx_tready,
    oDmaTx_tvalid,
    oZynqClk,
    oZynqRst);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input [31:0]iDmaRx_tdata;
  input [3:0]iDmaRx_tkeep;
  input iDmaRx_tlast;
  output iDmaRx_tready;
  input iDmaRx_tvalid;
  output [31:0]oDmaTx_tdata;
  output [3:0]oDmaTx_tkeep;
  output oDmaTx_tlast;
  input oDmaTx_tready;
  output oDmaTx_tvalid;
  output oZynqClk;
  output [0:0]oZynqRst;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [31:0]iDmaRx_tdata;
  wire [3:0]iDmaRx_tkeep;
  wire iDmaRx_tlast;
  wire iDmaRx_tready;
  wire iDmaRx_tvalid;
  wire [31:0]oDmaTx_tdata;
  wire [3:0]oDmaTx_tkeep;
  wire oDmaTx_tlast;
  wire oDmaTx_tready;
  wire oDmaTx_tvalid;
  wire oZynqClk;
  wire [0:0]oZynqRst;

  E9DmaTransferPS E9DmaTransferPS_i
       (.DDR_addr(DDR_addr),
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
        .iDmaRx_tdata(iDmaRx_tdata),
        .iDmaRx_tkeep(iDmaRx_tkeep),
        .iDmaRx_tlast(iDmaRx_tlast),
        .iDmaRx_tready(iDmaRx_tready),
        .iDmaRx_tvalid(iDmaRx_tvalid),
        .oDmaTx_tdata(oDmaTx_tdata),
        .oDmaTx_tkeep(oDmaTx_tkeep),
        .oDmaTx_tlast(oDmaTx_tlast),
        .oDmaTx_tready(oDmaTx_tready),
        .oDmaTx_tvalid(oDmaTx_tvalid),
        .oZynqClk(oZynqClk),
        .oZynqRst(oZynqRst));
endmodule
