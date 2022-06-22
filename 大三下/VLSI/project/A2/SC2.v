`timescale 1ns/1ps
//产生sc序列
module SC2(clk,
           rst,
           en_in,
           en_out,
           num,
           seq,
           m);
    
    input wire [35:0] m;
    input wire [5:0] num;
    input wire clk,rst,en_in;
    output reg seq;
    output reg en_out;
    
    wire en_print;
    wire [5:0] out;
    
    always@(posedge clk or negedge rst)begin//seq
        if (!rst||!en_in)  seq <= 0;
        else if (en_print)  begin
        if (num>out) seq <= 1; // en-print is a SRAND(), used for the judge gate in this case
        else seq         <= 0;
    end
    else  seq <= seq;
    end
    
    always@(posedge clk or negedge rst)begin//en_out
        if (!rst||!en_in)  en_out  <= 0;
        else if (en_print)  en_out <= 1;
        else  en_out               <= 0;
    end
    
    
    
    
    SOBOL2 sobol(
    .m(m),
    .clk(clk),
    .rst(rst),
    .en_in(en_in),
    .en_out(en_print),
    .out(out)
    );
    
    
endmodule
