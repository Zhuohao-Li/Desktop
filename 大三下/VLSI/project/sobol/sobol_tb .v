`timescale 1ns/1ps
module test( );

reg clk,rst,en_in;
reg [35:0] m;
wire en_out,out_bit;

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
    #1 rst <= 0;
    #1 rst <= 1;
    #5;
    
end

SOBOL sobol (
    .m(m),
    .clk(clk),
    .rst(rst),
    .en_in(en_in),
    .en_out(en_out),
    .out_bit(out_bit)
    );


    

endmodule