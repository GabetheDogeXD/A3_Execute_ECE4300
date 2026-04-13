`timescale 1ns / 1ps

// Tests alu.v

module ALU_Testbench; //now matches
// Inputs
reg [31:0] a;
reg [31:0] b;
reg [2:0] control;

// Outputs
wire [31:0] result;
wire zero;

// Instantiate the Unit Under Test (UUT)
alu uut (
    .a(a), 
    .b(b), 
    .control(control), 
    .result(result), 
    .zero(zero)
);

initial begin
    a = 32'd10; // 10 in 32 bit
    b = 32'd7 ; // 7  in 32 bit
    
    //from here, it is changed to better match ALU values
    $monitor("time=%0t control=%b a=%d b=%d result=%d zero=%b",
             $time, control, a, b, result, zero);

    control = 3'b010; #10; // add
    control = 3'b110; #10; // sub
    control = 3'b000; #10; // and
    control = 3'b001; #10; // or
    control = 3'b111; #10; // slt
    control = 3'b011; #10; // invalid

    a = 32'd5;
    b = 32'd5;
    control = 3'b110; #10; // zero should go high
$finish;
end
      
endmodule