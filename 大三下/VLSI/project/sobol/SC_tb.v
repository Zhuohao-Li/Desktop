`timescale 1ns/1ps
module test( );

reg clk,rst,en_in;
reg [35:0] m;
reg [5:0]num;
wire en_out;
wire [31:0]seq;
integer i;

always #5 clk <= ~clk;

initial begin
    m[ 5: 0]=1;
    m[11: 6]=3;
    m[17:12]=5;
    m[23:18]=7;
    m[29:24]=9;
    m[35:30]=11;

    en_in=1;
    clk=0;
    rst<=1;
    i=0.5;
    num=0.8*64;
    #1 rst <= 0;
    #1 rst <= 1;
    #5;
    
end

SC sc(
    .clk(clk),
    .rst(rst),
    .en_in(en_in),
    .en_out(en_out),
    .num(num),
    .seq(seq),
    .m(m)
);


    

endmodule