// Code your testbench here
// or browse Examples
module TB;
  reg [3:0] binary, gray;
  g2b g2b(gray,binary);
  
  initial begin
    $monitor(" Gray = %b --> Binary = %b",gray, binary);
    gray = 4'b1011; #1;
    gray = 4'b0111; #1;
    gray = 4'b0101; #1;
    gray = 4'b1100; #1;
    gray = 4'b1111;
  end
endmodule

// Code your design here
//gray to binary
module g2b #(parameter WIDTH=4)(
input [WIDTH-1:0] gray,
output [WIDTH-1:0] binary
);

genvar i;
generate
for(i=2;i<=WIDTH;i++)begin
	assign binary[WIDTH-i] = gray[WIDTH-i]  ^ binary[WIDTH-i+1];
end
endgenerate

assign binary[WIDTH-1] = gray[WIDTH-1];
endmodule
