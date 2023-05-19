// Code your design here
module universal_shift_reg (
  input clk, rst_n,
  input [3:0] d_in,
  input [1:0] select,
  input shift_left_in,
  input shift_right_in,
  output reg [3:0] d_out
  
);
  
  always@(posedge clk) begin
    if(!rst_n) begin
      d_out <= 0;
    end
    else begin
      case(select)
        2'b00 : d_out <= d_out;
        2'h1 : d_out <= {shift_right_in,d_out[3:1]};
        2'h2 : d_out <= {d_out[2:0],shift_left_in};
        2'h3 : d_out <= d_in;
        default : d_out <= d_out;
      endcase
    end
  end
  
endmodule

// Code your testbench here
// or browse Examples
module TB;
  reg clk, rst_n;
  reg [1:0] select;
  reg [3:0] d_in;
  reg shift_left_in, shift_right_in;
  wire [3:0] d_out; //parallel data out
  //wire s_left_dout, s_right_dout;
  
  universal_shift_reg usr(clk, rst_n, select, d_in, shift_left_in, shift_right_in, d_out);
  
  always #2 clk = ~clk;
  initial begin
    $monitor("T=%t, select=%b, d_in=%b, shift_left_in=%b, shift_right_in=%b --> d_out = %b",$time , select, d_in, shift_left_in, shift_right_in, d_out);
    clk = 0; rst_n = 0;
    #3 rst_n = 1;
    
    #1 d_in = 4'b1101;
    shift_left_in = 1'b0;
    shift_right_in = 1'b1;
    
    select = 2'h3; #10;
    select = 2'h1; #20;
    
    #1 d_in = 4'b1001;
    select = 2'h3; #10;
    select = 2'h2; #20;
    select = 2'h0; #20;
    
    $finish;
  end
  // To enable waveform
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
   
endmodule
        
