`timescale 1ns/1ps
//产生单个sobol序列
module SOBOL_single(m,
                    clk,
                    rst,
                    en_next,
                    en_out,
                    out,
                    count);
    
    input  wire clk,rst,en_next;
    input  wire [35:0]m;
    input  wire [5:0]count;
    output reg en_out;
    output reg [5:0]out;
    wire en_finish;
    wire [5:0]xi,xo;
    wire [35:0]c;
    reg [5:0]xtmp;
    reg en_on;
    assign xi = (count == 0)?0:xtmp;
    
    assign c[5: 0]  = m[5: 0]*32;
    assign c[11: 6] = m[11: 6]*16;
    assign c[17:12] = m[17:12]*8;
    assign c[23:18] = m[23:18]*4;
    assign c[29:24] = m[29:24]*2;
    assign c[35:30] = m[35:30];
    
    always@(posedge clk or negedge rst)begin//xtmp保留xi-1
        if (!rst||!en_next)  xtmp         <= xtmp;
        else if (en_finish&&!en_out) xtmp <= xo;
        else xtmp                         <= xtmp;
    end
    
    always@(posedge clk or negedge rst)begin//en_on输出阶段关闭sobol_unit
        if (!rst||!en_next)  en_on <= 0;
        else if (en_out) en_on     <= 0;
        else en_on                 <= 1;
    end
    
    always@(posedge clk or negedge rst)begin//en_out可输出时置1
        if (!rst||!en_next)  en_out <= 0;
        else if (en_finish&&(en_out == 0)) en_out < = 1;
        else en_out <= 0;
    end
    
    always@(posedge clk or negedge rst)begin//out
        if (!rst||!en_next)  out         <= 0;
        else if (en_finish&&!en_out) out <= xo;
        else out                         <= out;
    end
    
    SOBOL_unit sobol_unit(
    .xi(xi),
    .xo(xo),
    .c(c),
    .count(count),
    .en_in(en_on),
    .en_out(en_finish),
    .clk(clk),
    .rst(rst)
    );
    
    
endmodule
