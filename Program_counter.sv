// Code your design here
module program_counter (
    input clk,
    input reset,
    output reg [6:0] out
);

parameter [7:0] COUNT_LIMIT = 12;
parameter [7:0] COUNT_STEP = 4;

always @ (posedge clk) begin
    if (reset)
        out <= 7'd0;
    else if (out >= COUNT_LIMIT)
        out <= 7'd0;
    else
        out <= out + COUNT_STEP;
end

endmodule

module pipeline_reg #(
    parameter WIDTH = 32
)
(
    input clk,
    input reset,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);


always @ (posedge clk or posedge reset) begin
    if (reset)
        out <= {WIDTH{1'b0}};
    else
        out <= in;
end

endmodule

module instruction_memory (
    input clk,
    input reset,
    input [6:0] addr,
    input re,
    output reg [31:0] instruction
);

reg [7:0] memory [0:127];

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        memory[0] <= 8'h01; // MUL opcode
        memory[1] <= 8'h03; // reg3
        memory[2] <= 8'h02; // reg2
        memory[3] <= 8'h01; // reg1

        memory[4] <= 8'h02; // SHIFT opcode
        memory[5] <= 8'h06; // reg6
        memory[6] <= 8'h05; // reg5
        memory[7] <= 8'h04; // reg4

        memory[8] <= 8'h03; // XOR opcode
        memory[9] <= 8'h09; // reg9
        memory[10] <= 8'h08; // reg8
        memory[11] <= 8'h07; // reg7

        memory[12] <= 8'h04; // NOR opcode
        memory[13] <= 8'hd; // reg13
        memory[14] <= 8'hb; // reg11
        memory[15] <= 8'ha; // reg10

        for (int i = 16; i < 128; i = i + 1) begin
            memory[i] <= 8'h0;
        end

        instruction <= '0;
    end else if (re)
        instruction <= {9'b0,memory[addr], memory[addr + 1][4:0], memory[addr + 2][4:0],  memory[addr + 3][4:0]};
end

endmodule

module decode (
    input clk, reset,
    input [31:0] instruction,
    output reg [4:0] reg1, reg2, reg3,
    output reg [3:0] opcode
);

always @ (posedge clk) begin
    if (reset) begin
        reg1 <= '0;
        reg2 <= '0;
        reg3 <= '0;
        opcode <= '0;
    end else begin
        {opcode, reg3, reg1, reg2} <= instruction[18:0];
    end
end
endmodule

module alu (
    input [31:0] a,
    input [31:0] b,
    input [3:0] op,
    output reg [31:0] y
);

function [31:0] alu_op;
    input [31:0] a;
    input [31:0] b;
    input [3:0] op;
    begin
        case (op)
            4'h1: alu_op = a * b;
            4'h2: alu_op = b >> a;
            4'h3: alu_op = a ^ b;
            4'h4: alu_op = ~(a | b);
            default: alu_op = 32'h00000000;
        endcase
    end
endfunction

always @ (*) begin
    y = alu_op(a, b, op);
end

endmodule

module register_file (
    input clk, reset, ra_en, rb_en,
    input [4:0] ra,
    input [4:0] rb,
    input [4:0] wc,
    input [31:0] wd,
    input we,
    output reg [31:0] rd_a,
    output reg [31:0] rd_b
);

reg [31:0] registers[0:31];

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        registers[1]    <= 40; //reg1 value
        registers[2]    <= 60; //reg2 value
        registers[4]    <= 60; //reg4 value
        registers[5]    <= 40; //reg5 value
        registers[7]    <= 32'hFFFF856D; //reg7 value
        registers[8]    <= 32'hEEEE3721; //reg8 value
        registers[10]   <= 32'h1FFF756F; //reg10 value
        registers[11]   <= 32'hFFFF765E; //reg11 value
        rd_a            <= '0;
        rd_b            <= '0;
    end else begin 
        if (ra_en)
            rd_a <= registers[ra];
        if (rb_en)
            rd_b <= registers[rb];
    end
end

always @ (negedge clk ) begin
    if (we)
        registers[wc] <= wd;
end

endmodule


module risc_proc (
    input clk, reset, im_re, rf_ra_en, rf_rb_en, rf_we,
    output [7:0] o_pc,
  	output [31:0] o_im, o_rf_r1, o_rf_r2, o_alu,
    output [4:0] o_dec_reg1, o_dec_reg2, o_dec_reg3,
    output [3:0] o_dec_op

);

logic [6:0] pc_out;
logic [31:0] im_out, reg1_val, reg2_val, alu_out, alu_out_p1;
logic [4:0] reg1, reg2, reg3, reg3_p2, reg3_p1;
logic [3:0] opcode, opcode_p1;

program_counter pc (.clk(clk), .reset(reset), .out(pc_out));

instruction_memory im (.clk(clk), .reset(reset), .addr(pc_out), .re(im_re), .instruction(im_out));

decode dec_im (.clk(clk), .reset(reset), .instruction(im_out), .reg1(reg1), .reg2(reg2), .reg3(reg3), .opcode(opcode));

pipeline_reg #(.WIDTH(4)) dec_im_p1 (.clk(clk), .reset(reset), .in(opcode), .out(opcode_p1));
pipeline_reg #(.WIDTH(5)) dec_im_p2 (.clk(clk), .reset(reset), .in(reg3), .out(reg3_p1));
pipeline_reg #(.WIDTH(5)) dec_im_p3 (.clk(clk), .reset(reset), .in(reg3_p1), .out(reg3_p2));

register_file rf (.clk(clk), .reset(reset), .ra_en(rf_ra_en), .rb_en(rf_rb_en), .ra(reg1), .rb(reg2), .we(rf_we), .wc(reg3_p2), .wd(alu_out_p1), .rd_a(reg1_val), .rd_b(reg2_val));

alu alu_0 (.a(reg1_val), .b(reg2_val), .op(opcode_p1), .y(alu_out));

pipeline_reg #(.WIDTH(32)) alu1 (.clk(clk), .reset(reset), .in(alu_out), .out(alu_out_p1));
  
assign o_pc = pc_out;
assign o_im = im_out;
assign o_dec_reg1 = reg1;
assign o_dec_reg2 = reg2;
assign o_dec_reg3 = reg3;
assign o_dec_op = opcode;
assign o_rf_r1 = reg1_val;
assign o_rf_r2 = reg2_val;
assign o_alu = alu_out_p1;


endmodule

// Code your testbench here
// or browse Examples
module top_tb;

  // Declaring inputs and outputs
  logic clk_ipt;
  logic rst_ipt;
  logic im_re_ipt, rf_rd_a_ipt, rf_rd_b_ipt, rf_we_ipt;
  logic [7:0] opt_pc;
  logic [31:0] opt_im, opt_rf_r1, opt_rf_r2, opt_alu,risc_opt;
  logic [4:0]  o_dec_reg1, o_dec_reg2, o_dec_reg3;
  logic [3:0] o_dec_op,opcode;
  bit Test_Pass =1;
  
  // Instantiate of DUT
 risc_proc dut_instance (
    .clk(clk_ipt),
    .reset(rst_ipt),
    .im_re(im_re_ipt), 
    .rf_ra_en(rf_rd_a_ipt), 
    .rf_rb_en(rf_rd_b_ipt), 
    .rf_we(rf_we_ipt),
    .o_pc(opt_pc),
    .o_im(opt_im),
    .o_dec_reg1(o_dec_reg1),
    .o_dec_reg2(o_dec_reg2),
    .o_dec_reg3(o_dec_reg3),
    .o_dec_op(o_dec_op),
    .o_rf_r1(opt_rf_r1),
    .o_rf_r2(opt_rf_r2),
    .o_alu(opt_alu));

  // Clock 
initial
begin
  clk_ipt = 1'b0;
  forever #10 clk_ipt = ~clk_ipt; // 20ns clock period
end
  
  
initial
begin
    $dumpfile("dump.vcd");
    $dumpvars();
end
  
  // Reset generator
  initial begin
    rst_ipt = 1; // reset high
    #20; // delay 20ns
    rst_ipt = 0; //  reset low
    im_re_ipt =1;
    rf_rd_a_ipt=1;
    rf_rd_b_ipt=1;
    rf_we_ipt=1;
    
    #1000ns $finish;
  end
  assign opcode = dut_instance.alu_0.op;
  
  // Monitor
  always @(posedge clk_ipt) begin
    case(opcode)
      	4'h1: risc_opt = opt_rf_r1 * opt_rf_r2;
        4'h2: risc_opt = opt_rf_r2 >> opt_rf_r1;
        4'h3: risc_opt = opt_rf_r1 ^ opt_rf_r2;
        4'h4: risc_opt = ~(opt_rf_r1| opt_rf_r2);
    endcase
  end
  
  always @(negedge clk_ipt) begin
    if(risc_opt != opt_alu) begin
      Test_Pass=0;
    end
    else begin
      case(opcode)
        4'h1: $display("MULTIPLICATION COMPARE PASSED");
        4'h2: $display("SHIFT COMPARE PASSED");
        4'h3: $display("XOR COMPARE PASSED");
        4'h4: $display("NOR COMPARE PASSED");
      endcase
    end
  end
  
  final begin
    if(Test_Pass == 1)
      $display("TEST PASSED");//Test passed
    else
      $display("TEST FAILED");
  end
endmodule
