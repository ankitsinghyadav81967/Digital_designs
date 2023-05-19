// Code your design here
// Code your design here
//module Synchronous FIFO

module sync_fifo #(
  parameter WIDTH = 8,
  parameter DEPTH = 8)
  (
  
  input clk,
  input rst,
  input [WIDTH-1:0] data_in,
  input wr_en,rd_en,
  
  output fifo_full, fifo_empty,
  output reg [WIDTH-1:0] data_out
  
);
  
  parameter PTR_WIDTH = $clog2(DEPTH);
  //FIFO declaration
  reg [WIDTH-1:0] fifo [DEPTH];
  //pointer declaration
  reg [PTR_WIDTH:0] wptr,rptr;
  
  always@(posedge clk) begin
    if(!rst) begin
      wptr <= 0 ; rptr <=0;
      data_out <= 0;
    end
  end
  
  //read pointer update
  always@(posedge clk) begin
    if(rd_en & !fifo_empty) begin
    data_out <= fifo[rptr[PTR_WIDTH-1:0]];
      rptr <= rptr + 1;
    end
//       else begin
//         rptr <= rptr;
//   end
  end
  
  //write pointer update
  always@(posedge clk) begin
    if(wr_en & !fifo_full) begin 
      fifo[wptr[PTR_WIDTH-1:0]] <= data_in;
      wptr <= wptr + 1;
    end
//        else begin
//          wptr <= wptr;
//   end
  end
   
  reg wrap_around;
  assign wrap_around = wptr[PTR_WIDTH] ^ rptr[PTR_WIDTH]; // To check MSB of write and read pointers are different
  assign fifo_full = wrap_around & (wptr[PTR_WIDTH-1:0] == rptr[PTR_WIDTH-1:0]);
  assign fifo_empty = (wptr == rptr);
  
  
  //assign fifo_empty = (wptr[PTR_WIDTH:0] == rptr[PTR_WIDTH:0]) ? 1:0 ;
  //assign fifo_full = ({~wptr[PTR_WIDTH],wptr[PTR_WIDTH-1:0]} == rptr[PTR_WIDTH:0]) ? 1:0;
  
endmodule

//code you test bench here
//
module sync_fifo_TB;
  reg clk, rst_n;
  reg w_en, r_en;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire full, empty;
  
  sync_fifo s_fifo(.clk(clk), .rst(rst_n), .wr_en(w_en), .rd_en(r_en), .data_in(data_in), .data_out(data_out), .fifo_full(full), .fifo_empty(empty));
  
  always #2 clk = ~clk;
  initial begin
    clk = 0; rst_n = 0;
    w_en = 0; r_en = 0;
    #3 rst_n = 1;
    drive(20);
    drive(40);
    $finish;
  end
  
  task push();
    if(!full) begin
      w_en = 1;
      data_in = $random;
      #1 $display("Push In: w_en=%b, r_en=%b, data_in=%h",w_en, r_en,data_in);
    end
    else $display("FIFO Full!! Can not push data_in=%d", data_in);
  endtask 
  
  task pop();
    if(!empty) begin
      r_en = 1;
      #1 $display("Pop Out: w_en=%b, r_en=%b, data_out=%h",w_en, r_en,data_out);
    end
    else $display("FIFO Empty!! Can not pop data_out");
  endtask
  
  task drive(int delay);
    w_en = 0; r_en = 0;
    fork
      begin
        repeat(10) begin @(posedge clk) push(); end
        w_en = 0;
      end
      begin
        #delay;
        repeat(10) begin @(posedge clk) pop(); end
        r_en = 0;
      end
    join
  endtask
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
