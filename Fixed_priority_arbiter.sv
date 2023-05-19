// Code your design here

//Assume the priority order is : REQ[3] > REG[2] > REQ[1] > REQ[0]

//Author: Gyan Chand Dhaka 

// Code your design here

//---------------------------Fixed Priority Arbiter --------------------------------------------//

module fixed_priority_arbiter(

		input clk,

		input rst_n,

		input [3:0] REQ,

		output reg [3:0] GNT

		);

  always @ (posedge clk or negedge rst_n)

		begin
		
          if(!rst_n)

				GNT <= 4'b0000;

			else if(REQ[3])

				GNT <= 4'b1000;

			else if(REQ[2])

				GNT <= 4'b0100;

			else if(REQ[1])

				GNT <= 4'b0010;

			else if(REQ[0])

				GNT <= 4'b0001;

			else

				GNT <= 4'b0000;

		end

endmodule


//
// Code your testbench here
// or browse Examples
//Author: Gyan Chand Dhaka
// Code your testbench here


module fixed_priority_Arbiter_test;
  reg clk;
  reg rst_n;
  reg [3:0] REQ;
  wire [3:0] GNT;
  
  //Instantiate Design Under Test
  
  fixed_priority_arbiter DUT(.clk(clk), .rst_n(rst_n), .REQ(REQ), .GNT(GNT));
  
  //Generate a 10 ns  Time Period Clock 
  always #5 clk = ~clk;
  
  //Drive the DUT or Generate stimuli for the DUT
  
  initial begin
    clk = 0;
    rst_n = 0;
    REQ = 4'b0;
    // Assert the Asynchronous Reset after 1 clock period 
    //#10 rst_n = 0;
    //Deassert the Reset
    #5 rst_n = 1;
    
    @(negedge clk) REQ = 4'b1000;    
    
    @(negedge clk) REQ = 4'b1010;
    
    @(negedge clk) REQ = 4'b0010;
    
    @(negedge clk) REQ = 4'b0110;
    
    @(negedge clk) REQ = 4'b1110;
    
    @(negedge clk) REQ = 4'b1111;
    
    @(negedge clk) REQ = 4'b0100;
    
    @(negedge clk) REQ = 4'b0010;
    
    #5 rst_n = 0;
    
    #100 $finish;
  end
  
   initial begin
    // below two lines are used to show waveform
    $dumpfile("dump.vcd");
     $dumpvars(1);
  end
  
endmodule
    
