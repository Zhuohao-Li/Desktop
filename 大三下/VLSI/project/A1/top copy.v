`timescale 1ns/1ps

module TOP(clk,rst,en_in,en_out,num1,num2,num3,num4,num5,num6,num7,num8,result);

input wire clk,rst,en_in;
input wire [5:0] num1,num2,num3,num4,num5,num6,num7,num8;
output wire en_out;
output wire [8:0] result;
////////////////////////////////////////////////////////SC
wire en_out1,en_out2,en_out3,en_out4,en_out5,en_out6,en_out7,en_out8;
wire seq1,seq2,seq3,seq4,seq5,seq6,seq7,seq8;
reg [35:0] m1,m2,m3,m4,m5,m6,m7,m8;

initial begin
    m1[ 5: 0]=1;m1[11: 6]=3;m1[17:12]=5;m1[23:18]=7;m1[29:24]=9;m1[35:30]=11;
    m2[ 5: 0]=3;m2[11: 6]=5;m2[17:12]=7;m2[23:18]=9;m2[29:24]=11;m2[35:30]=1;
    m3[ 5: 0]=5;m3[11: 6]=7;m3[17:12]=9;m3[23:18]=11;m3[29:24]=1;m3[35:30]=3;
    m4[ 5: 0]=7;m4[11: 6]=9;m4[17:12]=11;m4[23:18]=1;m4[29:24]=3;m4[35:30]=5;
    m5[ 5: 0]=9;m5[11: 6]=11;m5[17:12]=1;m5[23:18]=3;m5[29:24]=5;m5[35:30]=7;
    m6[ 5: 0]=11;m6[11: 6]=1;m6[17:12]=3;m6[23:18]=5;m6[29:24]=7;m6[35:30]=9;
    m7[ 5: 0]=11;m7[11: 6]=9;m7[17:12]=7;m7[23:18]=5;m7[29:24]=3;m7[35:30]=1;
    m8[ 5: 0]=1;m8[11: 6]=11;m8[17:12]=9;m8[23:18]=7;m8[29:24]=5;m8[35:30]=3;
end

SC sc1(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out1),.num(num1),.seq(seq1),.m(m1));
SC sc2(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out2),.num(num2),.seq(seq2),.m(m2));
SC sc3(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out3),.num(num3),.seq(seq3),.m(m3));
SC sc4(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out4),.num(num4),.seq(seq4),.m(m4));
SC sc5(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out5),.num(num5),.seq(seq5),.m(m5));
SC sc6(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out6),.num(num6),.seq(seq6),.m(m6));
SC sc7(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out7),.num(num7),.seq(seq7),.m(m7));
SC sc8(.clk(clk),.rst(rst),.en_in(en_in),.en_out(en_out8),.num(num8),.seq(seq8),.m(m8));
////////////////////////////////////////////////////////NAND
wire en_nand1,en_nand2,en_nand3,en_nand4;
wire en_nand_out1,en_nand_out2,en_nand_out3,en_nand_out4;
wire nand_out1,nand_out2,nand_out3,nand_out4;

assign en_nand1=(en_out1&&en_out2)?1:0;
assign en_nand2=(en_out3&&en_out4)?1:0;
assign en_nand3=(en_out5&&en_out6)?1:0;
assign en_nand4=(en_out7&&en_out8)?1:0;

NAND nand1(.clk(clk),.rst(rst),.en_in(en_nand1),.in1(seq1),.in2(seq2),.out(nand_out1),.en_out(en_nand_out1));
NAND nand2(.clk(clk),.rst(rst),.en_in(en_nand2),.in1(seq3),.in2(seq4),.out(nand_out2),.en_out(en_nand_out2));
NAND nand3(.clk(clk),.rst(rst),.en_in(en_nand3),.in1(seq5),.in2(seq6),.out(nand_out3),.en_out(en_nand_out3));
NAND nand4(.clk(clk),.rst(rst),.en_in(en_nand4),.in1(seq7),.in2(seq8),.out(nand_out4),.en_out(en_nand_out4));
////////////////////////////////////////////////////////ADD
wire en_add;

assign en_add=(en_nand_out1&&en_nand_out2&&en_nand_out3&&en_nand_out4)?1:0;

ADD add1(
    .clk(clk),
    .rst(rst),
    .en_in(en_add),
    .in1(nand_out1),
    .in2(nand_out2),
    .in3(nand_out3),
    .in4(nand_out4),
    .out(result),
    .en_out(en_out)
);
endmodule