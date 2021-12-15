////////blockpitcher.v testbench////////v.1bis
`timescale 1ns/100ps
//`timescale 1us/1ns
module tb ();
	reg reset_n;
	reg inclk;
	reg ask;
	reg result;
	
//instantiate device under test
blockpitcher blockpitcher_dut(
	.rst_n(reset_n),
	.clk(inclk),
	.ask(ask),
	.result(result)
);

//****Event announcement****		
event reset_trigger;
event reset_done_trigger;
event load_trigger;
event load_done_trigger;
event terminate_sim;
event ask_trigger;
event ask_done_trigger;

//Clock signal creating
initial
begin forever 
	begin
	inclk = 1; #10; inclk = 0; #10; //  50MHz clk 20ns period
	end
end

//****Events****
//Reset formation event
initial
begin 
forever 
	begin //infinite loop
		@ (reset_trigger); //waiting for event reset_trigger
		@ (negedge inclk); //waiting for clk
		#10 reset_n = 0;   //begin resetting
		ask = 1; // ask reset
		result = 1; // result rese
		@ (negedge inclk); //end resetting
		#10 reset_n = 1; 
		@ (negedge inclk); //contact bounce
		#20 reset_n = 0;   //
		@ (negedge inclk); //
		#5 reset_n = 1; 
		-> reset_done_trigger; //reset is complete signal
	end 
end
//Ask formation event
initial
begin 
forever 
	begin //infinite loop
		@ (ask_trigger); //waiting for event ask_trigger
		@ (posedge inclk); //waiting for clk
		#1 ask = 1;   //begin ask
		@ (posedge inclk); //end ask
		#1 ask = 0; 
		-> ask_done_trigger; //ask is complete signal
	end 
end
//Brake of simulation event
initial 
	begin  
		@ (terminate_sim); 
		#20 $stop; 
	end

//****Simulation progress****
initial
  	begin: TEST_CASE
		#5 -> reset_trigger;  //making a reset with a delay (generate event)
		@ (reset_done_trigger); //waiting for reset_done_trigger signal (wait event)
		
		@ (posedge inclk); //end 1-st ask
		#1 ask = 0; 
		
		#1000 -> ask_trigger;  //making a 2-nd ask with a delay (generate event)
		@ (ask_done_trigger); //waiting for ask_done_trigger signal (wait event)
		
		#1000 -> ask_trigger;  //making a 3-nd ask with a delay (generate event)
		@ (ask_done_trigger); //waiting for ask_done_trigger signal (wait event)
		
		#3999998000 -> terminate_sim; //the end of the simulation (generate event)
	end
	
endmodule

/*

*/
