// Code your design here

module decoder (
  input [2:0] D,
  output reg [7:0] y
);
  
  always@(D) begin
    y = 8'b0;
    case(D) 
      3'b000 : y[0] = 1'b1;
      3'b001 : y[1] = 1'b1;
      3'b010 : y[2] = 1'b1;
      3'b011 : y[3] = 1'b1;
      3'b100 : y[4] = 1'b1;
      3'b101 : y[5] = 1'b1;
      3'b110 : y[6] = 1'b1;
      3'b111 : y[7] = 1'b1;
        default : y = 8'b0;
    endcase
  end
    
    endmodule


//
// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
module tb;
  reg [2:0] D;
  wire [7:0] y;
  
  decoder bin_dec(D, y);
  
  initial begin
    $monitor("D = %b -> y = %0b", D, y);
    repeat(5) begin
      D=$random; #1;
    end
  end
endmodule
