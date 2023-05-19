// Code your design here
//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2023 08:48:34 PM
// Design Name: 
// Module Name: ring_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ring_counter(
    Clock,
    Reset,
    Count_out
    );

input Clock;
  input Reset;
  output reg [3:0] Count_out;
  
  always@(posedge Clock or negedge Reset) 
    begin
      if(!Reset) begin
        Count_out =4'b0001;
      end
      else
        Count_out = {Count_out[2:0],Count_out[3]};
    end
  
  
endmodule
        
// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

// module tb_ring;
//     reg Clock;
//     reg Reset;

//     wire [3:0] Count_out;

//     ring_counter uut (
//         .Clock(Clock), 
//         .Reset(Reset), 
//         .Count_out(Count_out)
//     );

//     initial Clock = 0; 
//     always #10 Clock = ~Clock; 
    
//     initial
//     begin
//         Reset = 1; 
//         #50;     
//         Reset = 0; 
//     end
      
// endmodule

module ring_counter_tb;

reg clock;
reg Reset;
wire [3:0] Count_out;

ring_counter uut (
  .Clock(clock),
  .Reset(Reset),
  .Count_out(Count_out)
);

initial begin
  clock = 0;
  Reset = 1;
  #10 Reset = 0; // Release reset after 10 time units
end

always #5 clock = ~clock; // Generate a clock signal with a period of 10 time units

initial begin
  $dumpfile("ring_counter_tb.vcd"); // Dump waveforms to a file
  $dumpvars(0, ring_counter_tb); // Dump all signals in the testbench module
end

initial begin
  // Test the ring counter for 20 clock cycles
  #100;
  $finish;
end

endmodule
