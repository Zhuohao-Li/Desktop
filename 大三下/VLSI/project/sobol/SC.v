`timescale 1ns/1ps
//产生sc序列
 module SC(clk,rst,en_in,en_out,num,seq,m);

input wire [35:0] m;
input wire [5:0] num;
input wire clk,rst,en_in;
output reg [31:0]seq;
output wire en_out;

reg [5:0]collect,sc_index;
reg [2:0]collect_index;
reg [1:0]collect_flag,seq_flag;
reg sc_bit,en_next;
wire en_print,out_bit;

assign en_out=(sc_index==31&&collect_flag==3)?1:0;

always@(posedge clk or negedge rst)begin//en_next
    if(!rst||!en_in)  en_next <= 0;
    else if (sc_index==31&&collect_flag==3)  en_next <= 0;
    else  en_next <= 1;
end

always@(posedge clk or negedge rst)begin//seq_flag
    if(!rst||!en_in)  seq_flag<= 0;
    else if (collect_flag==3) begin
        case (sc_index)
        6'b000000: seq_flag<=1;
        6'b000001: seq_flag<=1;
        6'b000010: seq_flag<=1;
        6'b000011: seq_flag<=1;
        6'b000100: seq_flag<=1;
        6'b000101: seq_flag<=1;
        6'b000110: seq_flag<=1;
        6'b000111: seq_flag<=1;
        6'b001000: seq_flag<=1;
        6'b001001: seq_flag<=1;
        6'b001010: seq_flag<=1;
        6'b001011: seq_flag<=1;
        6'b001100: seq_flag<=1;
        6'b001101: seq_flag<=1;
        6'b001110: seq_flag<=1;
        6'b001111: seq_flag<=1;
        6'b010000: seq_flag<=1;
        6'b010001: seq_flag<=1;
        6'b010010: seq_flag<=1;
        6'b010011: seq_flag<=1;
        6'b010100: seq_flag<=1;
        6'b010101: seq_flag<=1;
        6'b010110: seq_flag<=1;
        6'b010111: seq_flag<=1;
        6'b011000: seq_flag<=1;
        6'b011001: seq_flag<=1;
        6'b011010: seq_flag<=1;
        6'b011011: seq_flag<=1;
        6'b011100: seq_flag<=1;
        6'b011101: seq_flag<=1;
        6'b011110: seq_flag<=2;
        6'b011111: seq_flag<=3;
         default: seq_flag<=0;
        endcase
    end
    else seq <= seq;
end

always@(posedge clk or negedge rst)begin//seq
    if(!rst||!en_in)  seq<= 0;
    else if (collect_flag==3) begin
        case (sc_index)
        6'b000000: seq[0]<=sc_bit;
        6'b000001: seq[1]<=sc_bit;
        6'b000010: seq[2]<=sc_bit;
        6'b000011: seq[3]<=sc_bit;
        6'b000100: seq[4]<=sc_bit;
        6'b000101: seq[5]<=sc_bit;
        6'b000110: seq[6]<=sc_bit;
        6'b000111: seq[7]<=sc_bit;
        6'b001000: seq[8]<=sc_bit;
        6'b001001: seq[9]<=sc_bit;
        6'b001010: seq[10]<=sc_bit;
        6'b001011: seq[11]<=sc_bit;
        6'b001100: seq[12]<=sc_bit;
        6'b001101: seq[13]<=sc_bit;
        6'b001110: seq[14]<=sc_bit;
        6'b001111: seq[15]<=sc_bit;
        6'b010000: seq[16]<=sc_bit;
        6'b010001: seq[17]<=sc_bit;
        6'b010010: seq[18]<=sc_bit;
        6'b010011: seq[19]<=sc_bit;
        6'b010100: seq[20]<=sc_bit;
        6'b010101: seq[21]<=sc_bit;
        6'b010110: seq[22]<=sc_bit;
        6'b010111: seq[23]<=sc_bit;
        6'b011000: seq[24]<=sc_bit;
        6'b011001: seq[25]<=sc_bit;
        6'b011010: seq[26]<=sc_bit;
        6'b011011: seq[27]<=sc_bit;
        6'b011100: seq[28]<=sc_bit;
        6'b011101: seq[29]<=sc_bit;
        6'b011110: seq[30]<=sc_bit;
        6'b011111: seq[31]<=sc_bit;
        default: seq<=seq;
        endcase
    end
    else seq <= seq;
end

always@(posedge clk or negedge rst)begin//sc_bit
    if(!rst||!en_in)  sc_bit<= 0;
    else if (collect_flag==3) begin
        if(num>=collect) sc_bit<=1;
        else sc_bit<=0;
    end
    else sc_bit <= sc_bit;
end


always@(posedge clk or negedge rst)begin//sc_index
    if(!rst||!en_in)  sc_index <= 0;
    else if (collect_flag==3) begin
        if(sc_index==31) sc_index<=0;
        else sc_index<=sc_index+1;
    end
    else sc_index <= sc_index;
end

always@(posedge clk or negedge rst)begin//collect_index
    if(!rst||!en_in)  collect_index <= 0;
    else if (en_print) collect_index<= collect_index+1;
    else collect_index <= 0;
end

always@(posedge clk or negedge rst)begin//collect
    if(!rst||!en_in)  collect<= 0;
    else if (!en_print) collect<= collect;
    else begin
        case(collect_index)
        3'b000: collect[0]<=out_bit;
        3'b001: collect[1]<=out_bit;
        3'b010: collect[2]<=out_bit;
        3'b011: collect[3]<=out_bit;
        3'b100: collect[4]<=out_bit;
        3'b101: collect[5]<=out_bit;
        default: collect<= collect;
        endcase
    end
end

always@(posedge clk or negedge rst)begin//collect_flag
    if(!rst||!en_in)  collect_flag<= 0;
    else if (!en_print) collect_flag<= 0;
    else begin
        case(collect_index)
        3'b000: collect_flag<=1;
        3'b001: collect_flag<=1;
        3'b010: collect_flag<=1;
        3'b011: collect_flag<=1;
        3'b100: collect_flag<=2;
        3'b101: collect_flag<=3;
        default: collect_flag<=0;
        endcase
    end
end



SOBOL sobol(
    .m(m),
    .clk(clk),
    .rst(rst),
    .en_in(en_next),
    .en_out(en_print),
    .out_bit(out_bit)
);


 endmodule