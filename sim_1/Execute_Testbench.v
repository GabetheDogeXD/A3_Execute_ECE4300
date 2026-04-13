//executeTB.v

module executeTB;

    reg clk;
    reg [1:0] ctlwb_in; 
    reg [2:0] ctlm_in;  //gave this memory control 1 more bit
    reg [31:0] npc, rdata1, rdata2, s_extend;
    reg [4:0] instr_2016, instr_1511;
    reg [1:0] alu_op;
    reg [5:0] funct;
    reg alusrc, regdst;

    wire [1:0] ctlwb_out; 
    wire [2:0] ctlm_out; //gave this memory control 1 more bit
    wire [31:0] adder_out, alu_result_out, rdata2_out;
    wire [4:0] muxout_out;
    wire zero_out;

    execute uut (
        .clk(clk),
        .ctlwb_in(ctlwb_in),
        .ctlm_in(ctlm_in),
        .npc(npc),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extend(s_extend),
        .instr_2016(instr_2016),
        .instr_1511(instr_1511),
        .alu_op(alu_op),
        .funct(funct),
        .alusrc(alusrc),
        .regdst(regdst),
        .ctlwb_out(ctlwb_out),
        .ctlm_out(ctlm_out),
        .adder_out(adder_out),
        .zero_out(zero_out),
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $monitor("time=%0t ctlwb_out=%b ctlm_out=%b adder_out=%d alu_result_out=%d rdata2_out=%d muxout_out=%d zero=%b",
                 $time, ctlwb_out, ctlm_out, adder_out, alu_result_out, rdata2_out, muxout_out, zero_out);
        // 
        // R-type add, regdst=1, alusrc=0
        ctlwb_in   = 2'b10;
        ctlm_in    = 3'b101;
        npc        = 32'd100;
        rdata1     = 32'd10;
        rdata2     = 32'd20;
        s_extend   = 32'd4;
        instr_2016 = 5'd5;
        instr_1511 = 5'd10;
        alu_op     = 2'b10;
        funct      = 6'b100000;
        alusrc     = 1'b0;
        regdst     = 1'b1;

        #12;

        // beq-style subtract, regdst=0, alusrc=0
        ctlwb_in   = 2'b01;
        ctlm_in    = 3'b010;
        npc        = 32'd200;
        rdata1     = 32'd30;
        rdata2     = 32'd30;
        s_extend   = 32'd8;
        instr_2016 = 5'd3;
        instr_1511 = 5'd12;
        alu_op     = 2'b01;
        funct      = 6'b100010;
        alusrc     = 1'b0;
        regdst     = 1'b0;

        #12;

        // lw/sw-style add immediate, alusrc=1
        ctlwb_in   = 2'b11;
        ctlm_in    = 3'b011;
        npc        = 32'd300;
        rdata1     = 32'd40;
        rdata2     = 32'd15;
        s_extend   = 32'd12;
        instr_2016 = 5'd8;
        instr_1511 = 5'd14;
        alu_op     = 2'b00;
        funct      = 6'b000000;
        alusrc     = 1'b1;
        regdst     = 1'b0;

        #12;

        $finish;
    end
endmodule