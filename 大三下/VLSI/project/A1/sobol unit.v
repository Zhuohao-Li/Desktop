`timescale 1ns/1ps
//计算sobol序列
module SOBOL_unit(xi,
                  xo,
                  c,
                  count,
                  en_in,
                  en_out,
                  clk,
                  rst);
    
    input  wire clk,rst,en_in;
    input  wire [5:0] xi,count;
    input  wire [35:0] c;
    output wire [5:0]xo;
    output wire en_out;
    
    reg [5:0] cr;
    
    reg flag;//标记cr查找结果
    
    assign xo     = (flag)?(xi^cr):0;
    assign en_out = flag;
    
    
    always@(posedge clk or negedge rst)begin//flag
        if (!rst||!en_in)  flag <= 0;
        else begin
        if (count[0] == 0) flag <      = 1;
        else if (count[1] == 0) flag < = 1;
        else if (count[2] == 0) flag < = 1;
        else if (count[3] == 0) flag < = 1;
        else if (count[4] == 0) flag < = 1;
        else if (count[5] == 0) flag < = 1;
    end
    end
    
    always@(posedge clk or negedge rst)begin//cr
        if (!rst||!en_in)  cr <= 0;
        else begin
        if (count[0] == 0)       cr <      = c[5:0];
        else if (count[1] == 0) cr < = c[11:6];
        else if (count[2] == 0) cr < = c[17:12];
        else if (count[3] == 0) cr < = c[23:18];
        else if (count[4] == 0) cr < = c[29:24];
        else if (count[5] == 0) cr < = c[35:30];
    end
    end
endmodule
