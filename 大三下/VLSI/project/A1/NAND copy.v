`timescale 1ns/1ps

module NAND(clk,
            rst,
            en_in,
            in1,
            in2,
            out,
            en_out);
    
    input wire clk,rst,en_in;
    input wire in1,in2;
    output reg out;
    output reg en_out;
    
    always@(posedge clk or negedge rst)begin//out
        if (!rst||!en_in)  out <= out;
        else out               <= in1&in2;
    end
    
    always@(posedge clk or negedge rst)begin//en_out
        if (!rst||!en_in)  en_out <= 0;
        else en_out               <= 1;
    end
endmodule
