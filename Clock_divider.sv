// Design
// D flip-flop
module clk_divn #(
parameter WIDTH = 3,
parameter N = 5)
 
(clk,reset, clk_out);
 
input clk;
input reset;
output reg clk_out_pos,clk_out_neg;
 
reg [WIDTH-1:0] pos_count, neg_count;
//wire [WIDTH-1:0] r_nxt;
 
 always @(posedge clk)
   begin
   if (reset)
     	//clk_out <= 0;
     	pos_count <=0;
     else if(pos_count == N-1)
       //clk_out <= ~clk_out;
     	pos_count <= 0;
     else
       pos_count <= pos_count +1;
   end
  
  always @(posedge clk)
   begin
   if (reset)
     	clk_out_pos <= 0;
     	     else if(pos_count == N-1)
       clk_out_pos <= ~clk_out_pos;
     	     else
       clk_out_pos <= clk_out_pos;
   end
 
  always @(negedge clk)
   begin
   if (reset)
     	clk_out_neg <= 0;
     else if(pos_count == (N-1)*0.5)
       clk_out_neg <= ~clk_out_neg;
     	     else
       clk_out_neg <= clk_out_neg;
   end
  
  assign clk
  
endmodule
