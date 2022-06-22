`timescale 1ns/1ps
module test( );

reg clk,rst,en_in;
reg [35:0] m1,m2;
reg [5:0]num1,num2;
wire en_out1,en_out2,en_nand,en_nand_out;
wire [31:0]seq1,seq2,out;
integer i1,i2;


always #5 clk <= ~clk;
assign en_nand=(en_out1&&en_out2)?1:0;

initial begin
    m1[ 5: 0]=1;
    m1[11: 6]=3;
    m1[17:12]=5;
    m1[23:18]=7;
    m1[29:24]=9;
    m1[35:30]=11;

    m2[ 5: 0]=3;
    m2[11: 6]=5;
    m2[17:12]=7;
    m2[23:18]=9;
    m2[29:24]=11;
    m2[35:30]=1;

    en_in=1;
    clk=0;
    rst<=1;
    i1=0.3;
    i2=0.8;
    num1=0.3*64;
    num2=0.8*64;
    #1 rst <= 0;
    #1 rst <= 1;
    #5;

    
end

SC sc1(
    .clk(clk),
    .rst(rst),
    .en_in(en_in),
    .en_out(en_out1),
    .num(num1),
    .seq(seq1),
    .m(m1)
);

SC sc2(
    .clk(clk),
    .rst(rst),
    .en_in(en_in),
    .en_out(en_out2),
    .num(num2),
    .seq(seq2),
    .m(m2)
);

NAND nand1(
    .clk(clk),
    .rst(rst),
    .en_in(en_nand),
    .in1(seq1),
    .in2(seq2),
    .out(out),
    .en_out(en_nand_out)
);
    

endmodule