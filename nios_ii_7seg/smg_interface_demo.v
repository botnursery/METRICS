//	QMTECH board project for Hex to 7 segment LED from NiosII	//

 `timescale 1ns / 1ps
 module smg_interface_demo(
    input CLK,								// Input clock
	 input RSTn,							// Reset button
	 output [7:0]SMG_Data,           // Output segment selection signal (LEDA .. LEDH)
	 output [2:0]Scan_Sig,           // Output column scan signal (SEL0_T~SEL2_T)
	 output LED           				// Output LED indicator pin
);
	 
		wire [7:0]gpio_ext;
		assign LED = gpio_ext[7];
		
	     qmtech_7seg_nios2 nios(
	     .clk_clk( CLK ),
		  .reset_reset_n( RSTn ),
		  .gpio_export( gpio_ext ) 	// 8bit out
	 );
	  
	 display_hex_7_seg_led hex_show(	// 2digit+radix
	     .CLK( CLK ),
	     .RSTn( RSTn ),
	     .Byte_data( gpio_ext ),
	     .Scan_Sig( Scan_Sig ),
	     .SMG_Data( SMG_Data )
	 );
	 
endmodule
