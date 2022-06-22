`timescale 1ns/1ps
module test();
    
    reg clk,rst,en_in;
    reg [5:0]num1,num2,num3,num4,num5,num6,num7,num8;
    wire en_out1;
    wire en_out2;
    wire [8:0]result1;
    wire [8:0]result2;
    wire [16:0]ideal_result;
    reg flag;
    integer i,j,count,sigma;
    
    assign wire [16:0] result = {result1, result2};
    always #5 clk <= ~clk;
    initial begin
        
        
        en_in = 1;
        clk   = 0;
        rst <= 1;
        i     = 0;
        j     = 0;
        flag  = 0;
        num1  = 0.5*64;//放大64倍
        num2  = 0.5*64;
        num3  = 0.5*64;
        num4  = 0.5*64;
        num5  = 0.5*64;
        num6  = 0.5*64;
        num7  = 0.5*64;
        num8  = 0.5*64;
        count = 0;
        sigma = 0;
        #1 rst <= 0;
        #1 rst <= 1;
        #5;
        $display("ideal = ",ideal_result);
    end
    
    assign ideal_result = (num1*num2/64+num3*num4/64+num5*num6/64+num7*num8/64);
    
    
    
    
    always@(posedge clk or negedge rst)begin//sigma
        if (en_out1 && en_out2)   begin
            if (count == 1000) begin
                if (ideal_result>result) sigma <= ideal_result-result;
                else sigma                     <= result-ideal_result;
            end
            else begin
                if (ideal_result>result) sigma <= sigma+ideal_result-result;
                else sigma                     <= sigma-ideal_result+result;
            end
        end
        else  sigma <= sigma;
    end
    
    always@(posedge clk or negedge rst)begin//count
        if (en_out1 && en_out2)   begin
            if (count == 1000) count< = 1;
            else count <= count+1;
        end
        else  count <= count;
    end
    
    always@(posedge clk or negedge rst)begin//flag
        if (en_out1 && en_out2)   flag <= 1;
        else flag                      <= 0;
    end
    
    always@(posedge clk or negedge rst)begin//en_in
        if (en_out1 && en_out2)   en_in <= 0;
        else en_in                      <= 1;
    end
    always@(posedge clk or negedge rst)begin//num1
        if (en_out1 && en_out2)   num1 <= {$random} % 64;
        else num1                      <= num1;
    end
    always@(posedge clk or negedge rst)begin//num2
        if (en_out1 && en_out2)   num2 <= {$random} % 64;
        else num2                      <= num2;
    end
    always@(posedge clk or negedge rst)begin//num3
        if (en_out1 && en_out2)   num3 <= {$random} % 64;
        else num3                      <= num3;
    end
    always@(posedge clk or negedge rst)begin//num4
        if (en_out1 && en_out2)   num4 <= {$random} % 64;
        else num4                      <= num4;
    end
    always@(posedge clk or negedge rst)begin//num5
        if (en_out1 && en_out2)   num5 <= {$random} % 64;
        else num5                      <= num5;
    end
    always@(posedge clk or negedge rst)begin//num6
        if (en_out1 && en_out2)   num6 <= {$random} % 64;
        else num6                      <= num6;
    end
    always@(posedge clk or negedge rst)begin//num7
        if (en_out1 && en_out2)   num7 <= {$random} % 64;
        else num7                      <= num7;
    end
    always@(posedge clk or negedge rst)begin//num8
        if (en_out1 && en_out2)   num8 <= {$random} % 64;
        else num8                      <= num8;
    end
    
    
    always@(posedge clk or negedge rst)begin//print
        if (en_out1 && en_out2&&count == 1000)   $display("MAE = ",sigma);
        else i <= i+1;
    end
    
    TOP top1(
    .clk(clk),
    .rst(rst),
    .en_in(en_in),
    .en_out1(en_out1),
    .en_out2(en_out2),
    .num1(num1),
    .num2(num2),
    .num3(num3),
    .num4(num4),
    .num5(num5),
    .num6(num6),
    .num7(num7),
    .num8(num8),
    .result1(result1),
    .result2(result2)
    
    );
    
endmodule
