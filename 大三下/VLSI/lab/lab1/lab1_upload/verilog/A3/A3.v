/*
 * @Author: [Zhuohao Lee]
 * @Date: 2022-04-12 15:45:35
 * @LastEditors: [Zhuohao Lee]
 * @LastEditTime: 2022-04-19 22:13:03
 * @FilePath: /undefined/Users/edith_lzh/Desktop/???/VLSI/github/lab/lab1/A3/IIR_fold.v
 * @Description: edith_lzh@sjtu.edu.cn
 * yes
 * Copyright (c) 2022 by Zhuohao Lee, All Rights Reserved.
 */

//reg_x?reg_y???reg_y??OUT??????mid???
//IIR_folding_up
//?????FSM????????x???->????x????????->?????????->??????????????
//y[n] = a_n*x[n]+a_{n-1}*x[n-1]+...+a_{n-16}*x[n-16]+b_{n-1}*y[n-1]+...+b_{n-16}*y[n-16]

`timescale 1ns/1ps

module IIR #(parameter Width = 10)
            (input wire rst_n,                  //?????????
             input wire clk,                    //????
             input wire signed [Width-1:0] Din, //??9??????????
             output reg signed[Width-1:0] Dout, //??9??????????
             input wire input_valid,            //????????
             output reg output_valid);          //??????????
    
    //?????????IDLE?????READ?????CALC?????OUT??????
    //?????????
    reg [1:0] state_current;
    reg [1:0] state_next;
    
    parameter [1:0]  IDLE = 2'b00,
    READ = 2'b01,
    CALC = 2'b11,
    OUT = 2'b10;
    
    wire signed [9:0] coe [32:0];    //???????????a_n,a_{n-1},...,a_{n-16},b_{n-1},b_{n-2},...,b_{n-16}
    
    assign coe[0]  = 10'b0000000110;  //a_n
    assign coe[1]  = 10'b0000000000;  //a_{n-1}
    assign coe[2]  = 10'b1111010010;
    assign coe[3]  = 10'b0000000000;
    assign coe[4]  = 10'b0010100001;
    assign coe[5]  = 10'b0000000000;
    assign coe[6]  = 10'b1010111110;
    assign coe[7]  = 10'b0000000000;
    assign coe[8]  = 10'b0110010011;
    assign coe[9]  = 10'b0000000000;
    assign coe[10] = 10'b1010111110;
    assign coe[11] = 10'b0000000000;
    assign coe[12] = 10'b0010100001;
    assign coe[13] = 10'b0000000000;
    assign coe[14] = 10'b1111010010;
    assign coe[15] = 10'b0000000000;
    assign coe[16] = 10'b0000000110;  //a_{n-16}
    
    assign coe[17] = 10'b0010001101;  //b_{n-1}
    assign coe[18] = 10'b1010110100;
    assign coe[19] = 10'b0100101010;
    assign coe[20] = 10'b1000011011;
    assign coe[21] = 10'b0101101001;
    assign coe[22] = 10'b1001010111;
    assign coe[23] = 10'b0100000110;
    assign coe[24] = 10'b1100000110;
    assign coe[25] = 10'b0001111100;
    assign coe[26] = 10'b1110100000;
    assign coe[27] = 10'b0000100101;
    assign coe[28] = 10'b1111101000;
    assign coe[29] = 10'b0000000110;
    assign coe[30] = 10'b1111111101;
    assign coe[31] = 10'b0000000000;
    assign coe[32] = 10'b0000000000;  //b_{n-16}
    
    
    //??x[n]?x[n-16],y[n-1]?y[n-16]
    reg  signed [9:0] mid_reg_x [16:0];
    reg  signed [9:0] mid_reg_y [15:0];
    
    //mid ???????mid <= mid + coe * reg
    reg signed [29:0] mid;
    
    //??????
    //?????????????????????????????????????????????
    //?state_current == IDLE???????(input_valid?1)??????????????out_valid?0,count?0
    //???????????????????x[n-16]?x[n]?????????x[n-16]????????x[n-17]????x[n]
    //??????33??????count????count = 17???reg_x???reg_y??count = 33?????????OUT??
    //??OUT??????y[n]???y[n]??reg_y?????out_valid?1???????
    
    reg [5:0] count; //count??33
    
    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            state_current <= IDLE;
        else
            state_current <= state_next;
    
    
    always @ (*)
        case (state_current)
            IDLE:
            if (input_valid == 0 || output_valid == 0) state_next  = IDLE;
            else state_next  = READ;
            READ: state_next = CALC;
            CALC:
            if (count!          = 33) state_next          = CALC;
            else state_next     = OUT;
            OUT: state_next     = IDLE;
            default: state_next = IDLE;
        endcase
    
    //mid_reg_x
    always @ (posedge clk or negedge rst_n)
        if (!rst_n) begin
            mid_reg_x[0]  <= 10'd0;
            mid_reg_x[1]  <= 10'd0;
            mid_reg_x[2]  <= 10'd0;
            mid_reg_x[3]  <= 10'd0;
            mid_reg_x[4]  <= 10'd0;
            mid_reg_x[5]  <= 10'd0;
            mid_reg_x[6]  <= 10'd0;
            mid_reg_x[7]  <= 10'd0;
            mid_reg_x[8]  <= 10'd0;
            mid_reg_x[9]  <= 10'd0;
            mid_reg_x[10] <= 10'd0;
            mid_reg_x[11] <= 10'd0;
            mid_reg_x[12] <= 10'd0;
            mid_reg_x[13] <= 10'd0;
            mid_reg_x[14] <= 10'd0;
            mid_reg_x[15] <= 10'd0;
            mid_reg_x[16] <= 10'd0;
            
        end
    
    else if (state_current == IDLE && input_valid == 1) begin
    mid_reg_x[0]  <= Din;
    mid_reg_x[1]  <= mid_reg_x[0];
    mid_reg_x[2]  <= mid_reg_x[1];
    mid_reg_x[3]  <= mid_reg_x[2];
    mid_reg_x[4]  <= mid_reg_x[3];
    mid_reg_x[5]  <= mid_reg_x[4];
    mid_reg_x[6]  <= mid_reg_x[5];
    mid_reg_x[7]  <= mid_reg_x[6];
    mid_reg_x[8]  <= mid_reg_x[7];
    mid_reg_x[9]  <= mid_reg_x[8];
    mid_reg_x[10] <= mid_reg_x[9];
    mid_reg_x[11] <= mid_reg_x[10];
    mid_reg_x[12] <= mid_reg_x[11];
    mid_reg_x[13] <= mid_reg_x[12];
    mid_reg_x[14] <= mid_reg_x[13];
    mid_reg_x[15] <= mid_reg_x[14];
    mid_reg_x[16] <= mid_reg_x[15];
    
    end
    
    else begin
    mid_reg_x[0]  <= mid_reg_x[0];
    mid_reg_x[1]  <= mid_reg_x[1];
    mid_reg_x[2]  <= mid_reg_x[2];
    mid_reg_x[3]  <= mid_reg_x[3];
    mid_reg_x[4]  <= mid_reg_x[4];
    mid_reg_x[5]  <= mid_reg_x[5];
    mid_reg_x[6]  <= mid_reg_x[6];
    mid_reg_x[7]  <= mid_reg_x[7];
    mid_reg_x[8]  <= mid_reg_x[8];
    mid_reg_x[9]  <= mid_reg_x[9];
    mid_reg_x[10] <= mid_reg_x[10];
    mid_reg_x[11] <= mid_reg_x[11];
    mid_reg_x[12] <= mid_reg_x[12];
    mid_reg_x[13] <= mid_reg_x[13];
    mid_reg_x[14] <= mid_reg_x[14];
    mid_reg_x[15] <= mid_reg_x[15];
    mid_reg_x[16] <= mid_reg_x[16];
    
    end
    
    //mid_reg_y
    always @ (posedge clk or negedge rst_n)
        if (!rst_n) begin
            
            mid_reg_y[0]  <= 10'd0;
            mid_reg_y[1]  <= 10'd0;
            mid_reg_y[2]  <= 10'd0;
            mid_reg_y[3]  <= 10'd0;
            mid_reg_y[4]  <= 10'd0;
            mid_reg_y[5]  <= 10'd0;
            mid_reg_y[6]  <= 10'd0;
            mid_reg_y[7]  <= 10'd0;
            mid_reg_y[8]  <= 10'd0;
            mid_reg_y[9]  <= 10'd0;
            mid_reg_y[10] <= 10'd0;
            mid_reg_y[11] <= 10'd0;
            mid_reg_y[12] <= 10'd0;
            mid_reg_y[13] <= 10'd0;
            mid_reg_y[14] <= 10'd0;
            mid_reg_y[15] <= 10'd0;
        end
    
    else if (state_current == CALC && count == 33)  begin
    
    mid_reg_y[0]  <= mid[29:20];
    mid_reg_y[1]  <= mid_reg_y[0];
    mid_reg_y[2]  <= mid_reg_y[1];
    mid_reg_y[3]  <= mid_reg_y[2];
    mid_reg_y[4]  <= mid_reg_y[3];
    mid_reg_y[5]  <= mid_reg_y[4];
    mid_reg_y[6]  <= mid_reg_y[5];
    mid_reg_y[7]  <= mid_reg_y[6];
    mid_reg_y[8]  <= mid_reg_y[7];
    mid_reg_y[9]  <= mid_reg_y[8];
    mid_reg_y[10] <= mid_reg_y[9];
    mid_reg_y[11] <= mid_reg_y[10];
    mid_reg_y[12] <= mid_reg_y[11];
    mid_reg_y[13] <= mid_reg_y[12];
    mid_reg_y[14] <= mid_reg_y[13];
    mid_reg_y[15] <= mid_reg_y[14];
    end
    
    else begin
    
    mid_reg_y[0]  <= mid_reg_y[0];
    mid_reg_y[1]  <= mid_reg_y[1];
    mid_reg_y[2]  <= mid_reg_y[2];
    mid_reg_y[3]  <= mid_reg_y[3];
    mid_reg_y[4]  <= mid_reg_y[4];
    mid_reg_y[5]  <= mid_reg_y[5];
    mid_reg_y[6]  <= mid_reg_y[6];
    mid_reg_y[7]  <= mid_reg_y[7];
    mid_reg_y[8]  <= mid_reg_y[8];
    mid_reg_y[9]  <= mid_reg_y[9];
    mid_reg_y[10] <= mid_reg_y[10];
    mid_reg_y[11] <= mid_reg_y[11];
    mid_reg_y[12] <= mid_reg_y[12];
    mid_reg_y[13] <= mid_reg_y[13];
    mid_reg_y[14] <= mid_reg_y[14];
    mid_reg_y[15] <= mid_reg_y[15];
    end
    
    //count
    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            count <= 6'd0;
        else if (state_current == IDLE && input_valid == 1)
            count <= 6'd1;
        else if (state_current == CALC && count ! = 6'd33)
            count <= count+6'd1;
        else if (count == 6'd33)
            count <= 6'd0;
        else
            count <= count;
    
    //mid
    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            mid <= 30'd0;
        else if (state_current == READ)
            mid <= coe[0]*mid_reg_x[0];
        else if (count >6'd0 && count <6'd17)
            mid <= mid+coe[count]*mid_reg_x[count];
        else if (count >6'd16 && count <6'd33)
            mid <= mid+coe[count]*mid_reg_y[count-17];
        else if (state_current == OUT)
            mid <= 30'd0;
        else
            mid <= mid;
    
    //Dout
    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            Dout <= 10'd0;
        else if (state_current == CALC && count == 33)
            Dout <= mid;
        else
            Dout <= Dout;
    
    //output_valid
    always @ (posedge clk or negedge rst_n)
        if (!rst_n)
            output_valid <= 1;
        else if (state_current == OUT)
            output_valid <= 1;
        else if (state_current == IDLE && input_valid == 1)
            output_valid <= 0;
        else
            output_valid <= output_valid;
    
endmodule
