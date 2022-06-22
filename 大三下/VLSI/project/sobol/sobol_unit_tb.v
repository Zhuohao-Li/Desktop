`timescale 1ns/1ps
module test( );

reg clk,rst,en_in;
reg [35:0] c;
reg [5:0] xi,count;
wire [5:0] xo;
wire en_out;

always #5 clk <= ~clk;

initial begin
    c[ 5: 0]=1*32;
    c[11: 6]=3*16;
    c[17:12]=5*8;
    c[23:18]=7*4;
    c[29:24]=9*2;
    c[35:30]=11;

    xi=0;
    count=31;
    en_in=1;
    clk=0;
    rst<=1;
    #1 rst <= 0;
    #1 rst <= 1;
    #5
    $display(xo);
end



SOBOL_unit sobolunit(
                     .xi(xi),
                     .xo(xo),
                     .c(c),
                     .count(count),
                     .en_in(en_in),
                     .en_out(en_out),
                     .clk(clk),
                     .rst(rst)
                     );

    

endmodule