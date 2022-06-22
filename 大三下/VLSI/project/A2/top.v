`timescale 1ns/1ps

module TOP(clk,
           rst,
           en_in,
           en_out1,
           en_out2,
           num1,
           num2,
           num3,
           num4,
           num5,
           num6,
           num7,
           num8,
           result1,
           result2);
    
    input wire clk,rst,en_in;
    input wire [5:0] num1,num2,num3,num4,num5,num6,num7,num8;
    output wire en_out1, en_out2;
    output wire [8:0] result1, result2;
    ////////////////////////////////////////////////////////SC
    wire en_out1,en_out2,en_out3,en_out4,en_out5,en_out6,en_out7,en_out8,en_out9,en_out10,en_out11,en_out12,en_out13,en_out14,en_out15,en_out16;
    wire seq1,seq2,seq3,seq4,seq5,seq6,seq7,seq8,seq9,seq10,seq11,seq12,seq13,seq14,seq15,seq16;
    reg [35:0] m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16;
    
    initial begin
        m1[5: 0]  = 1;  m1[11: 6]  = 3; m1[17:12]  = 5; m1[23:18]  = 7; m1[29:24]  = 9; m1[35:30]  = 11;
        m2[5: 0]  = 3;  m2[11: 6]  = 5; m2[17:12]  = 7; m2[23:18]  = 9; m2[29:24]  = 11;m2[35:30]  = 1;
        m3[5: 0]  = 5;  m3[11: 6]  = 7; m3[17:12]  = 9; m3[23:18]  = 11;m3[29:24]  = 1; m3[35:30]  = 3;
        m4[5: 0]  = 7;  m4[11: 6]  = 9; m4[17:12]  = 11;m4[23:18]  = 1; m4[29:24]  = 3; m4[35:30]  = 5;
        m5[5: 0]  = 9;  m5[11: 6]  = 11;m5[17:12]  = 1; m5[23:18]  = 3; m5[29:24]  = 5; m5[35:30]  = 7;
        m6[5: 0]  = 11; m6[11: 6]  = 1; m6[17:12]  = 3; m6[23:18]  = 5; m6[29:24]  = 7; m6[35:30]  = 9;
        m7[5: 0]  = 11; m7[11: 6]  = 9; m7[17:12]  = 7; m7[23:18]  = 5; m7[29:24]  = 3; m7[35:30]  = 1;
        m8[5: 0]  = 1;  m8[11: 6]  = 11;m8[17:12]  = 9; m8[23:18]  = 7; m8[29:24]  = 5; m8[35:30]  = 3;
        m9[5: 0]  = 1;  m1[11: 6]  = 5; m1[17:12]  = 3; m1[23:18]  = 7; m1[29:24]  = 9; m1[35:30]  = 11;
        m10[5: 0] = 3;  m2[11: 6] = 7;  m2[17:12] = 5;  m2[23:18] = 9;  m2[29:24] = 11; m2[35:30] = 1;
        m11[5: 0] = 5;  m3[11: 6] = 11; m3[17:12] = 9;  m3[23:18] = 7;  m3[29:24] = 1;  m3[35:30] = 3;
        m12[5: 0] = 7;  m4[11: 6] = 1;  m4[17:12] = 11; m4[23:18] = 9;  m4[29:24] = 3;  m4[35:30] = 5;
        m13[5: 0] = 9;  m5[11: 6] = 1; m5[17:12] = 11;  m5[23:18] = 3;  m5[29:24] = 5;  m5[35:30] = 7;
        m14[5: 0] = 5; m6[11: 6] = 1;  m6[17:12] = 3;  m6[23:18] = 11;  m6[29:24] = 7;  m6[35:30] = 9;
        m15[5: 0] = 9; m7[11: 6] = 11;  m7[17:12] = 7;  m7[23:18] = 5;  m7[29:24] = 3;  m7[35:30] = 1;
        m16[5: 0] = 1;  m8[11: 6] = 11; m8[17:12] = 9;  m8[23:18] = 5;  m8[29:24] = 7;  m8[35:30] = 3;
    end
    
    SC sc1(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out1),.num(num1),.seq(seq1),.m(m1));
    SC sc2(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out2),.num(num2),.seq(seq2),.m(m2));
    SC sc3(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out3),.num(num3),.seq(seq3),.m(m3));
    SC sc4(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out4),.num(num4),.seq(seq4),.m(m4));
    SC sc5(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out5),.num(num5),.seq(seq5),.m(m5));
    SC sc6(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out6),.num(num6),.seq(seq6),.m(m6));
    SC sc7(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out7),.num(num7),.seq(seq7),.m(m7));
    SC sc8(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out8),.num(num8),.seq(seq8),.m(m8));
    SC2 sc9(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out9),.num(num1),.seq(seq9),.m(m9));
    SC2 sc10(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out10),.num(num2),.seq(seq10),.m(m10));
    SC2 sc11(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out11),.num(num3),.seq(seq11),.m(m11));
    SC2 sc12(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out12),.num(num4),.seq(seq12),.m(m12));
    SC2 sc13(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out13),.num(num5),.seq(seq13),.m(m13));
    SC2 sc14(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out14),.num(num6),.seq(seq14),.m(m14));
    SC2 sc15(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out15),.num(num7),.seq(seq15),.m(m15));
    SC2 sc16(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out16),.num(num8),.seq(seq16),.m(m16));
    ////////////////////////////////////////////////////////NAND
    wire en_and1,en_and2,en_and3,en_and4,en_and5,en_and6,en_and7,en_and8;
    wire en_and_out1,en_and_out2,en_and_out3,en_and_out4,en_and_out5,en_and_out6,en_and_out7,en_and_out8;
    wire and_out1,and_out2,and_out3,and_out4,and_out5,and_out6,and_out7,and_out8;
    
    assign en_and1 = (en_out1&&en_out2)?1:0;
    assign en_and2 = (en_out3&&en_out4)?1:0;
    assign en_and3 = (en_out5&&en_out6)?1:0;
    assign en_and4 = (en_out7&&en_out8)?1:0;
    
    AND and1(.clk(clk),.rst(rst),.en_in(en_and1),.in1(seq1),.in2(seq2),.out(and_out1),.en_out(en_and_out1));
    AND and2(.clk(clk),.rst(rst),.en_in(en_and2),.in1(seq3),.in2(seq4),.out(and_out2),.en_out(en_and_out2));
    AND and3(.clk(clk),.rst(rst),.en_in(en_and3),.in1(seq5),.in2(seq6),.out(and_out3),.en_out(en_and_out3));
    AND and4(.clk(clk),.rst(rst),.en_in(en_and4),.in1(seq7),.in2(seq8),.out(and_out4),.en_out(en_and_out4));
    AND and5(.clk(clk),.rst(rst),.en_in(en_and5),.in1(seq9),.in2(seq10),.out(and_out5),.en_out(en_and_out5));
    AND and6(.clk(clk),.rst(rst),.en_in(en_and6),.in1(seq11),.in2(seq12),.out(and_out6),.en_out(en_and_out6));
    AND and7(.clk(clk),.rst(rst),.en_in(en_and7),.in1(seq13),.in2(seq14),.out(and_out7),.en_out(en_and_out7));
    AND and8(.clk(clk),.rst(rst),.en_in(en_and8),.in1(seq15),.in2(seq16),.out(and_out8),.en_out(en_and_out8));
    ////////////////////////////////////////////////////////ADD
    wire en_add1;
    wire en_add2;
    
    assign en_add1 = (en_and_out1&&en_and_out2&&en_and_out3&&en_and_out4)?1:0;
    assign en_add2 = (en_and_out5&&en_and_out6&&en_and_out7&&en_and_out8)?1:0;
    
    ADD add1(
    .clk(clk),
    .rst(rst),
    .en_in(en_add1),
    .in1(and_out1),
    .in2(and_out2),
    .in3(and_out3),
    .in4(and_out4),
    .out(result1),
    .en_out(en_out1)
    );
    
    ADD add2(
    .clk(clk),
    .rst(rst),
    .en_in(en_add2),
    .in1(and_out5),
    .in2(and_out6),
    .in3(and_out7),
    .in4(and_out8),
    .out(result2),
    .en_out(en_out2)
    );
endmodule
