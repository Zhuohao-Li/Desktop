`timescale 1ns/1ns
module coef_mem(
                clk,
                rst_n,
                co_choose,
                
                co_out
                );

input clk,rst_n;
input [4:0] co_choose;

output signed [11:0] co_out; 

reg signed [11:0] coef_mem[0:31];    

wire clk,rst_n;
wire [4:0] co_choose;

reg signed [11:0] co_out;

always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
    coef_mem[0]<=12'b0;
    coef_mem[1]<=12'b0;
    coef_mem[2]<=12'b0;
    coef_mem[3]<=12'b0;
    coef_mem[4]<=12'b0;
    coef_mem[5]<=12'b0;
    coef_mem[6]<=12'b0;
    coef_mem[7]<=12'b0;
    coef_mem[8]<=12'b0;
    coef_mem[9]<=12'b0;
    coef_mem[10]<=12'b0;
    coef_mem[11]<=12'b0;
    coef_mem[12]<=12'b0;
    coef_mem[13]<=12'b0;
    coef_mem[14]<=12'b0;
    coef_mem[15]<=12'b0;
    coef_mem[16]<=12'b0;
    coef_mem[17]<=12'b0;
    coef_mem[18]<=12'b0;
    coef_mem[19]<=12'b0;
    coef_mem[20]<=12'b0;
    coef_mem[21]<=12'b0;
    coef_mem[22]<=12'b0;
    coef_mem[23]<=12'b0;
    coef_mem[24]<=12'b0;
    coef_mem[25]<=12'b0;
    coef_mem[26]<=12'b0;
    coef_mem[27]<=12'b0;
    coef_mem[28]<=12'b0;
    coef_mem[29]<=12'b0;
    coef_mem[30]<=12'b0;
    coef_mem[31]<=12'b0;
  end
else
    coef_mem[0]<=12'b0;
    coef_mem[1]<=12'b0;
    coef_mem[2]<=12'b0;
    coef_mem[3]<=12'b0;
    coef_mem[4]<=12'b0;
    coef_mem[5]<=12'b0;
    coef_mem[6]<=12'b0;
    coef_mem[7]<=12'b0;
    coef_mem[8]<=12'b0;
    coef_mem[9]<=12'b0;
    coef_mem[10]<=12'b0;
    coef_mem[11]<=12'b0;
    coef_mem[12]<=12'b0;
    coef_mem[13]<=12'b0;
    coef_mem[14]<=12'b0;
    coef_mem[15]<=12'b0;
    coef_mem[16]<=12'b0;
    coef_mem[17]<=12'b0;
    coef_mem[18]<=12'b0;
    coef_mem[19]<=12'b0;
    coef_mem[20]<=12'b0;
    coef_mem[21]<=12'b0;
    coef_mem[22]<=12'b0;
    coef_mem[23]<=12'b0;
    coef_mem[24]<=12'b0;
    coef_mem[25]<=12'b0;
    coef_mem[26]<=12'b0;
    coef_mem[27]<=12'b0;
    coef_mem[28]<=12'b0;
    coef_mem[29]<=12'b0;
    coef_mem[30]<=12'b0;
    coef_mem[31]<=12'b0;
  end
  
always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
    c_out<=12'b0;
  end
else
  begin
    c_out<=coef_mem[co_choose];
  end
  
endmodule
    
      
