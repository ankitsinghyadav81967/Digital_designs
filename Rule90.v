//Rule 90 is a one-dimensional cellular automaton with interesting properties.

//The rules are simple. There is a one-dimensional array of cells (on or off). At each time step, the next state of each cell is the XOR of the cell's two current neighbours. A more verbose way of expressing this rule is the following table, where a cell's next state is a function of itself and its two neighbours

//create a 512-cell system (q[511:0]), and advance by one time step each clock cycle. The load input indicates the state of the system should be loaded with data[511:0]. Assume the boundaries (q[-1] and q[512]) are both zero (off). Write in verilog.

module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 

      always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
        q[511] <= q[510];
        q[0] <= q[1];
        for (int i = 1; i < 511; i = i + 1) begin
        q[i] <= q[i-1] ^ q[i+1];
      end
      //q[0] <= q[1];
    end
  end
    
    
endmodule
