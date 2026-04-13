`timescale 1ns / 1ps
/*
Execute Stage: This uses the outputs of Fetch and Decode Stages as well as combining the modules: adder, bottom_mux(5-bit), alu_control, alu, top_mux (32-bit),
and ex_mem.
*/
module execute(
    input wire       clk, //added clk here too and just had to change most input outputs
    input wire [1:0] ctlwb_in,
    input wire [2:0]  ctlm_in,
    input wire [31:0] npc,
    input wire [31:0] rdata1,
    input wire [31:0] rdata2,
    input wire [31:0] s_extend,
    input wire [4:0]  instr_2016,
    input wire [4:0]  instr_1511,
    input wire [1:0]  alu_op,
    input wire [5:0]  funct,
    input wire        alusrc,
    input wire        regdst,
    
    output wire [1:0] ctlwb_out, 
    output wire [2:0]  ctlm_out,
    output wire [31:0] adder_out,
    output wire        zero_out,
    output wire [31:0] alu_result_out,
    output wire [31:0] rdata2_out,
    output wire [4:0]  muxout_out
);

// Signals
wire [31:0] alu_src_b;//internal wires to connect internal EXECUTE components together
wire [2:0]  alu_control_sel;
wire [31:0] alu_result_wire;
wire        zero_wire;
wire [4:0]  write_reg_wire;

// Branch address adder
adder branch_adder (       // was "adder adder3"
    .add_in1(npc),         // removed out ending to these two variables
    .add_in2(s_extend),
    .add_out(adder_out)
);

// Destination register mux
bottom_mux dest_mux (
    .a(instr_2016),     //rt
    .b(instr_1511),     //rd
    .sel(regdst),
    .y(write_reg_wire)
);

// ALU input mux
top_mux alu_mux (
    .a(rdata2),
    .b(s_extend),
    .sel(alusrc),
    .y(alu_src_b)
);

// ALU control
alu_control alu_control_unit (
    .funct(funct),
    .aluop(alu_op),
    .select(alu_control_sel)
);

// ALU
alu alu_unit (
    .a(rdata1),
    .b(alu_src_b),
    .control(alu_control_sel),
    .result(alu_result_wire),
    .zero(zero_wire)
);

// EX/MEM latch
ex_mem ex_mem_latch (
    .clk(clk),
    .ctlwb_in(ctlwb_in),
    .ctlm_in(ctlm_in),
    .add_result_in(adder_out),
    .zero_in(zero_wire),
    .alu_result_in(alu_result_wire),
    .rdata2_in(rdata2),
    .muxout_in(write_reg_wire),
    .ctlwb_out(ctlwb_out),
    .ctlm_out(ctlm_out),
    .add_result_out(),
    .zero_out(zero_out),
    .alu_result_out(alu_result_out),
    .rdata2_out(rdata2_out),
    .muxout_out(muxout_out)
);
    
endmodule // IEXECUTE

//new top and bottom mux section
module top_mux(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        sel,
    output wire [31:0] y
);
assign y = sel ? b : a;
endmodule


module bottom_mux(
    input  wire [4:0] a,
    input  wire [4:0] b,
    input  wire       sel,
    output wire [4:0] y
);
assign y = sel ? b : a;
endmodule