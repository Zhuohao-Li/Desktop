`timescale 1ns/1ps
//产生sobol序列
module SOBOL(m,
             clk,
             rst,
             en_in,
             en_out,
             out);
    
    input wire [35:0] m;
    input wire clk,rst,en_in;
    output reg [5:0]out;
    output reg en_out;
    reg en_next;
    reg [5:0]count;
    wire en_print;
    wire [5:0] value;
    
    always@(posedge clk or negedge rst)begin//en_out
        if (!rst||!en_in)  en_out  <= 0;
        else if (en_print)  en_out <= 1;//输出完毕
        else  en_out               <= 0;
    end
    
    always@(posedge clk or negedge rst)begin//out
        if (!rst||!en_in)  out  <= 0;
        else if (en_print)  out <= value;//输出完毕
        else  out               <= out;
    end
    
    always@(posedge clk or negedge rst)begin//count
        if (!rst||!en_in)  count <= 0;
        else if (en_print) begin
        if (count == 31) count< = 0;
        else count <= count+1;
    end
    else count <= count;
    end
    
    always@(posedge clk or negedge rst)begin//en_next
        if (!rst||!en_in)  en_next  <= 0;
        else if (en_print)  en_next <= 0;//输出完毕
        else  en_next               <= 1;
    end
    
    
    
    
    SOBOL_single sobol_single(
    .m(m),
    .clk(clk),
    .rst(rst),
    .en_next(en_next),
    .en_out(en_print),
    .out(value),
    .count(count)
    );
    
endmodule
