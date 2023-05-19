// Code your design here


//Author: Gyan Chand Dhaka 
// Code your design here
//---------------Round Robin Arbiter (with Fixed Time Slices ---//

module round_robin_arbiter_fixed_time_slices(

		input clk,

		input rst_n,

		input [3:0] REQ,

		output reg [3:0] GNT

		);

	reg [2:0] present_state;

	reg [2:0] next_state;

	parameter [2:0] S_ideal = 3'b000;

	parameter [2:0] S_0 = 3'b001;

	parameter [2:0] S_1 = 3'b010;

	parameter [2:0] S_2 = 3'b011;

	parameter [2:0] S_3 = 3'b100;




  always @ (posedge clk or negedge rst_n) // State Register , Sequential always block
	
		begin

          if(!rst_n)

				present_state <= S_ideal;

			else

				present_state <= next_state;

		end

  always @(*) // Next State , Combinational always block

		begin

			case(present_state)

				S_ideal : begin
	
							if(REQ[0])

								begin

									next_state = S_0;

								end

							else if(REQ[1])

								begin

									next_state = S_1;

								end

							else if(REQ[2])

								begin

                                    next_state = S_2;

								end

							else if(REQ[3])

								begin

									next_state = S_3;

								end

							else

								begin

									next_state = S_ideal;

								end

						end // S_ideal

				S_0 : begin

							if(REQ[1])
	
								begin
	
									next_state = S_1;

								end

							else if(REQ[2])

								begin

									next_state = S_2;

								end

							else if(REQ[3])

								begin

									next_state = S_3;

								end

							else if(REQ[0])

								begin

									next_state = S_0;

								end

							else

								begin

									next_state = S_ideal;

								end

						end // S_0

				S_1 : begin

							if(REQ[2])

								begin
		
									next_state = S_2;

								end

							else if(REQ[3])

								begin

									next_state = S_3;

								end

                            else if(REQ[0])

								begin

									next_state = S_0;

								end

							else if(REQ[1])

								begin

									next_state = S_1;

								end

							else

								begin

									next_state = S_ideal;

								end

						end //S_1

				S_2 : begin

							if(REQ[3])

								begin

									next_state = S_3;

								end

							else if(REQ[0])

								begin

									next_state = S_0;

								end

							else if(REQ[1])

								begin

									next_state = S_1;

								end

							else if(REQ[2])

								begin

									next_state = S_2;

								end

							else
		
								begin

									next_state = S_ideal;

								end

						end // S_2

				S_3 : begin

							if(REQ[0])

                                  begin

									next_state = S_0;

								 end

							else if(REQ[1])

								begin

									next_state = S_1;

								end

							else if(REQ[2])

							    begin

									next_state = S_2;

								end

							else if(REQ[3])

								begin

									next_state = S_3;

							 	end

							else

								begin

									next_state = S_ideal;

								end

						end // S_3

				default : begin

							if(REQ[0])

								begin

									next_state = S_0;

								end

							else if(REQ[1])

								begin

									next_state = S_1;

								end

							else if(REQ[2])

								begin

									next_state = S_2;

								end

							else if(REQ[3])

								begin

									next_state = S_3;

								end

							else

								begin

									next_state = S_ideal;

								end

						end // default

			endcase // case(state)

	 end



  always @(*) // Output , Combinational always block

		begin
		
          case(present_state)

				S_0 : begin GNT = 4'b0001; end

				S_1 : begin GNT = 4'b0010; end

				S_2 : begin GNT = 4'b0100; end

				S_3 : begin GNT = 4'b1000; end

			default : begin GNT = 4'b0000; end

		  endcase

		end

endmodule // Round Robin Arbiter with Fixed Time Slice


// Code your testbench here
// or browse Examples
//Author: Gyan Chand Dhaka( M.Tech VLSI Design)
// Code your testbench here
// or browse Examples

module fixed_priority_Arbiter_fixed_time_slices_test;
  reg clk;
  reg rst_n;
  reg [3:0] REQ;
  wire [3:0] GNT;
  
  //Instantiate Design Under Test
  
  round_robin_arbiter_fixed_time_slices DUT(.clk(clk), .rst_n(rst_n), .REQ(REQ), .GNT(GNT));
  
  //Generate a 10 ns  Time Period Clock 
  always #5 clk = ~clk;
  
  //Drive the DUT or Generate stimuli for the DUT
  
  initial begin
    clk = 0;
    rst_n = 1;
    REQ = 4'b0;
    // Assert the Asynchronous Reset after 1 clock period 
    #10 rst_n = 0;
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
    
    
  
