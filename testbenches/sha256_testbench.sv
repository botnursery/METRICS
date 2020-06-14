////////circuit pucker 6 - sha256 duct testbench////////
`timescale 1ns/1ps
module tb #(parameter M=2) ();
	reg readout;
	reg reset_n;
	reg inclk;
	reg [511:0]data;
	wire result;
	wire ask;

	reg [1:0] vectornum; // test variables
	reg [511:0] testvectors[2:0]; // test data

//instantiate device under test
sha256_duct duct_dut(
	.readout(readout),
	.reset_n(reset_n),
	.inclk(inclk),
	.block_n(data),
	.result(result),
	.ask(ask)
);

//event announcement		
event reset_trigger;
event reset_done_trigger;
event load_trigger;
event load_done_trigger;
event terminate_sim;

initial	//Initialize will execute at the beginning once
	begin
		readout = 1'b0;
		reset_n = 1'b1;

		vectornum = 0;
		//M=1 blocks message case
//		testvectors[0] = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;	
//		testvectors[1] = 512'h0000000000000000000000000000000000000000000000000000000000000000f20015adb410ff6196177a9cb00361a35dae2223414140de8f01cfeaba7816bf;
		//M=2 blocks message case
		testvectors[0] = 512'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000;
		testvectors[1] = 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0;		
		testvectors[2] = 512'h000000000000000000000000000000000000000000000000000000000000000019DB06C1F6ECEDD464FF2167A33CE4590C3E6039E5C02693D20638B8248D6A61;
		
		$display("Running testbench");
		$dumpfile("tb.vcd");
		$dumpvars(0, tb);
	end

//Clock signal creating
initial
begin forever 
	begin
	inclk = 1; #10; inclk = 0; #10; //  50MHz clk 20ns period
	end
end

//Reset formation event
initial
begin 
forever 
	begin //infinite loop
		@ (reset_trigger); //waiting for event reset_trigger
		@ (negedge inclk); //waiting for clk
		#2 reset_n = 0;    //begin resetting
		@ (negedge inclk); //end resetting
		#2 reset_n = 1; 
		-> reset_done_trigger; //reset is complete signal
	end 
end

//received an Ask request to Load event
initial
begin 
forever 
	begin //infinite loop 
		@ (load_trigger); //waiting for event load_trigger
		#2 assign	data = testvectors[vectornum]; //loading test-case vector
		-> load_done_trigger; //signal that Ask is completed
	end 
end	
	
//Brake of simulation
initial 
	begin  
		@ (terminate_sim); 
		#20 $stop; 
	end
	
//Simulation progress (0th cycle reset and data request, 1st load and calculation up to 64/0th, 65/1st new load and output)
initial
  	begin: TEST_CASE
		#5 -> reset_trigger;  //making a reset with a delay
		@ (reset_done_trigger); //waiting for reset_done_trigger signal
		#2600 -> terminate_sim; //the end of the simulation
	end
	
always @ (negedge inclk) // for M rounds message case
	begin
		if (!reset_n)
			begin		
			vectornum=0;
			$display ("vectornum@- = %0d (%b binary)", vectornum, vectornum);
			-> load_trigger;  //making a delayed load
			@ (load_done_trigger); //load ready @ posedge clk # 1
				if (vectornum==M-1) readout=1; // if the last block in the message
			end
		else if (ask)
			begin		
			vectornum=vectornum+1;
			$display ("vectornum@+ = %0d (%b binary)", vectornum, vectornum);
			-> load_trigger;
			@ (load_done_trigger);
				if (vectornum==M-1) readout=1;
			end
	end
endmodule
