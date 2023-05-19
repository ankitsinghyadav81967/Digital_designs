// Code your design here
//dual edge counter

module counter #(parameter WIDTH = 4)(
  input clk,
  input rstn,
  //input d,
  //output reg [WIDTH-1:0] poscount,
  output [WIDTH-1:0] count
);
  
  reg [WIDTH-1:0] poscount;
  reg [WIDTH-1:0] negcount;
  
  assign count = poscount + negcount;
  
  always @(posedge clk or negedge rstn)
    begin
      if(!rstn) begin
        poscount <= 4'b0000;
      end
      else begin
        if (poscount == 0111) begin 
        poscount <= 4'b0000;
        end
      else
        poscount <= poscount + 1;
      end
    end    
      
      always @(negedge clk or negedge rstn)
    begin
      if(!rstn) begin
        negcount <= 4'b0000;
      end
      else begin
        if (negcount == 0111) begin 
        negcount <= 4'b0000;
        end
      else
  		negcount <= negcount + 1;
      end
    end
      
  
endmodule    
  

//testbench
`timescale 1ns/1ns


module counter_tb ();
  parameter WIDTH = 4;
 reg clk;
 reg rstn;
 wire [WIDTH-1:0] count;
  
  counter counter (.clk(clk), .rstn(rstn), .count(count)	);
  
  //always #10 clk= ~clk;
  
  initial begin
    clk <=1'b0;
    forever #10 clk = ~clk;
  end
  
  initial begin
    rstn <=1'b0;
    #5
    rstn <= 1'b1;
  end
    
  initial begin 
    $monitor("Time = %0t, clk=%0b, rstn=%0b, count=%0h", $time, clk, rstn, count);
    
    
    
    #200 $finish;
  end
  
endmodule
  
  
  
  
 
  
