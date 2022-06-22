`timescale 1ns/1ps
//产生单个sobol序列
module SOBOL(m,clk,rst,en_in,en_out,out_bit);

input wire [35:0] m;
input wire clk,rst,en_in;
output reg out_bit;
output wire en_out;
reg en_next;
reg [5:0]count;
wire en_print;
wire [5:0] out;
reg [2:0] out_index;
reg [1:0] out_flag;

assign en_out=(out_flag==0)?0:1;

always@(posedge clk or negedge rst)begin//en_next
    if(!rst||!en_in)  en_next <= 0;
    else if (out_flag==2)  en_next <= 0;//输出完毕
    else  en_next <= 1;
end

always@(posedge clk or negedge rst)begin//count
    if(!rst||!en_in)  count <= 0;
    else if (out_flag==2) begin
        if (count==31) count<=0;
        else count <= count+1;
    end
    else count <= count;

end

always@(posedge clk or negedge rst)begin//out_index
    if(!rst||!en_in)  out_index <= 0;
    else if (en_print) out_index <= out_index+1;
    else out_index <= 0;
end

always@(posedge clk or negedge rst)begin//out_bit
    if(!rst||!en_in)  out_bit <= 0;
    else if (!en_print) out_bit <= 0;
    else begin
        case(out_index)
        3'b000: out_bit<=out[0];
        3'b001: out_bit<=out[1];
        3'b010: out_bit<=out[2];
        3'b011: out_bit<=out[3];
        3'b100: out_bit<=out[4];
        3'b101: out_bit<=out[5];
        default: out_bit <= 0;
        endcase
    end
end

always@(posedge clk or negedge rst)begin//out_flag
    if(!rst||!en_in)  out_flag <= 0;
    else if (!en_print) out_flag <= 0;
    else begin
        case(out_index)
        3'b000: out_flag<=1;
        3'b001: out_flag<=1;
        3'b010: out_flag<=1;
        3'b011: out_flag<=1;
        3'b100: out_flag<=2;
        3'b101: out_flag<=3;
        default: out_flag <= 0;
        endcase
    end
end

SOBOL_single sobol_single(
    .m(m),
    .clk(clk),
    .rst(rst),
    .en_next(en_next),
    .en_out(en_print),
    .out(out),
    .count(count)
);

endmodule