`timescale 1ns / 1ps
module test ();
  
wire [2:0] select;  //Wire Port        
reg [1:0] alu_op;   //Register Declarations
reg [5:0] funct;

alu_control aluccontrol1 (.select(select), .aluop(alu_op), .funct(funct) );

initial begin
    //changed to match the canvas table
    $monitor("time=%0t alu_op=%b funct=%b select=%b", $time, alu_op, funct, select);
    alu_op = 2'b00; funct = 6'b100000; #10; // add  
    alu_op = 2'b01; funct = 6'b100000; #10; // sub  
    alu_op = 2'b10; funct = 6'b100000; #10; // add
    alu_op = 2'b10; funct = 6'b100010; #10; // sub
    alu_op = 2'b10; funct = 6'b100100; #10; // and
    alu_op = 2'b10; funct = 6'b100101; #10; // or
    alu_op = 2'b10; funct = 6'b101010; #10; // slt
    alu_op = 2'b11; funct = 6'b000000; #10; // invalid
    
    $finish;
end
endmodule //alu_control_testbench
