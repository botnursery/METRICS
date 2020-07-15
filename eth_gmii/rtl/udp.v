//////////////////////////////////////////////////////////////////////////////////
// Module Name:    udp数据通信模块 / udp data communication module
//////////////////////////////////////////////////////////////////////////////////

module udp(
			input wire           reset_n,
			
			input	 wire           e_rxc,
			input  wire	[7:0]	    e_rxd, 
			input	 wire           e_rxdv,
			output wire	          e_txen,
			output wire	[7:0]     e_txd,                              
			output wire		       e_txer,		
		
			output wire 	       data_o_valid,                        //接收数据有效信号// Receive data valid signal
			output wire [31:0]    ram_wr_data,                         //接收到的32bit IP包数据// Received 32bit IP packet data
			output wire [15:0]    rx_total_length,                     //接收IP包的总长度 / The total length of received IP packets

			output wire [3:0]     rx_state,                            //UDP数据接收状态机 / UDP data receiving state machine
			output wire [15:0]    rx_data_length,		                 //接收IP包的数据长度/ Data length of received IP packet
		   output wire [8:0]     ram_wr_addr,                         //ram数据写地址 / ram data write address
		
			input  wire [31:0]    ram_rd_data,                         //ram读出的数据 / ram read data
		   output      [3:0]     tx_state,                            //UDP数据发送状态机 / UDP data sending state machine

			input  wire [15:0]    tx_data_length,                      //发送IP包的数据长度/ Data length of sending IP packet
			input  wire [15:0]    tx_total_length,                     //发送IP包的总长度/ The total length of IP packets sent
		   output wire [8:0]     ram_rd_addr,                         //ram数据读地址 / ram data read address
			output wire           data_receive
);


wire	[31:0] crcnext;
wire	[31:0] crc32;
wire	crcreset;
wire	crcen;


//IP frame发送 / IP frame sending
ipsend ipsend_inst(
	.clk(e_rxc),
	.txen(e_txen),
	.txer(e_txer),
	.dataout(e_txd),
	.crc(crc32),
	.datain(ram_rd_data),
	.crcen(crcen),
	.crcre(crcreset),
	.tx_state(tx_state),
	.tx_data_length(tx_data_length),
	.tx_total_length(tx_total_length),
	.ram_rd_addr(ram_rd_addr)
	);
	
//crc32校验 / crc32 check
crc	crc_inst(
	.Clk(e_rxc),
	.Reset(crcreset),
	.Enable(crcen),
	.Data_in(e_txd),
	.Crc(crc32),
	.CrcNext(crcnext));

//IP frame接收程序 / IP frame receive
iprecieve iprecieve_inst(
	.clk(e_rxc),
	.datain(e_rxd),
	.e_rxdv(e_rxdv),	
	.clr(reset_n),
	.board_mac(),	
	.pc_mac(),
	.IP_Prtcl(),
	.IP_layer(),
	.pc_IP(),	
	.board_IP(),
	.UDP_layer(),
	.data_o(ram_wr_data),	
	.valid_ip_P(),
	.rx_total_length(rx_total_length),
	.data_o_valid(data_o_valid),                                       
	.rx_state(rx_state),
	.rx_data_length(rx_data_length),
	.ram_wr_addr(ram_wr_addr),
	.data_receive(data_receive)	
	
	
	);
	
endmodule
