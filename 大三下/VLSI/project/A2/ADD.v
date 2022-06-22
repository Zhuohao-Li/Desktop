`timescale 1ns/1ps

module ADD(clk,
           rst,
           en_in,
           in1,
           in2,
           in3,
           in4,
           out,
           en_out);
    
    input wire clk,rst,en_in;
    input wire in1,in2,in3,in4;
    output wire[8:0] out;
    output reg en_out;
    reg [4:0]count;
    reg [8:0] in1_dec,in2_dec,in3_dec,in4_dec;
    
    assign out = (in1_dec+in2_dec+in3_dec+in4_dec)*2;
    
    always@(posedge clk or negedge rst)begin//count
        if (!rst)  count       <= 0;
        else if (!en_in) count <= count;
        else begin
        if (count == 15) count< = 0;
        else count <= count+1;
    end
    end
    
    always@(posedge clk or negedge rst)begin//in1_dec
        if (!rst||!en_in)  in1_dec <= in1_dec;
        else if (count == 0) in1_dec< = in1;
        else in1_dec <= in1+in1_dec;
    end
    
    always@(posedge clk or negedge rst)begin//in2_dec
        if (!rst||!en_in)  in2_dec <= in2_dec;
        else if (count == 0) in2_dec< = in2;
        else in2_dec <= in2+in2_dec;
    end
    
    always@(posedge clk or negedge rst)begin//in3_dec
        if (!rst||!en_in)  in3_dec <= in3_dec;
        else if (count == 0) in3_dec< = in3;
        else in3_dec <= in3+in3_dec;
    end
    
    always@(posedge clk or negedge rst)begin//in4_dec
        if (!rst||!en_in)  in4_dec <= in4_dec;
        else if (count == 0) in4_dec< = in4;
        else in4_dec <= in4+in4_dec;
    end
    
    
    always@(posedge clk or negedge rst)begin//en_out
        if (!rst||!en_in)  en_out <= 0;
        else if (count == 31) en_out< = 1;
        else en_out <= 0;
    end
    
    
endmodule
