`timescale 1ns/1ns
module data_ram(
                clk,         //clk
                rst_n,       //initialize the ram
                data_in_en,  //this controls the data get input into data ram
                data_counter,//this choose which data to get out of the ram
                data_in,     //data_in signal, get new data into ram
                
                data_out,    //data_out, give data out to the 
                );
                

input clk,rst_n, data_in_en;
input [4:0] data_counter;
input  signed [15:0] data_in;
output signed [15:0] data_out;

wire clk,rst_n,data_in_en;
wire  [4:0] data_counter;
wire  signed [15:0] data_in;

reg  signed [15:0] data_out;

reg signed [15:0] data_ram[0:31];//32 datas in the ram

always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
    data_out<=16'b0;
  end
else
  begin
    data_out<=data_ram[data_counter];
  end

always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
  data_ram[0]<=16'b0;
  data_ram[1]<=16'b0;
  data_ram[2]<=16'b0;
  data_ram[3]<=16'b0;
  data_ram[4]<=16'b0;
  data_ram[5]<=16'b0;
  data_ram[6]<=16'b0;
  data_ram[7]<=16'b0;
  data_ram[8]<=16'b0;
  data_ram[9]<=16'b0;
  data_ram[10]<=16'b0;
  data_ram[11]<=16'b0;
  data_ram[12]<=16'b0;
  data_ram[13]<=16'b0;
  data_ram[14]<=16'b0;
  data_ram[15]<=16'b0;
  data_ram[16]<=16'b0;
  data_ram[17]<=16'b0;
  data_ram[18]<=16'b0;
  data_ram[19]<=16'b0;
  data_ram[20]<=16'b0;
  data_ram[21]<=16'b0;
  data_ram[22]<=16'b0;
  data_ram[23]<=16'b0;
  data_ram[24]<=16'b0;
  data_ram[25]<=16'b0;
  data_ram[26]<=16'b0;
  data_ram[27]<=16'b0;
  data_ram[28]<=16'b0;
  data_ram[29]<=16'b0;
  data_ram[30]<=16'b0;
  data_ram[31]<=16'b0;
end
else
  if(data_in_en) //data_in is enabled
  begin
    data_ram[31]<=data_ram[30];
    data_ram[30]<=data_ram[29];
    data_ram[29]<=data_ram[28];
    data_ram[28]<=data_ram[27];
    data_ram[27]<=data_ram[26];
    data_ram[26]<=data_ram[25];
    data_ram[25]<=data_ram[24];
    data_ram[24]<=data_ram[23];
    data_ram[23]<=data_ram[22];
    data_ram[22]<=data_ram[21];
    data_ram[21]<=data_ram[20];
    data_ram[20]<=data_ram[19];
    data_ram[19]<=data_ram[18];
    data_ram[18]<=data_ram[17];
    data_ram[17]<=data_ram[16];
    data_ram[16]<=data_ram[15];
    data_ram[15]<=data_ram[14];
    data_ram[14]<=data_ram[13];
    data_ram[13]<=data_ram[12];
    data_ram[12]<=data_ram[11];
    data_ram[11]<=data_ram[10];
    data_ram[10]<=data_ram[9];
    data_ram[9]<=data_ram[8];
    data_ram[8]<=data_ram[7];
    data_ram[7]<=data_ram[6];
    data_ram[6]<=data_ram[5];
    data_ram[5]<=data_ram[4];
    data_ram[4]<=data_ram[3];
    data_ram[3]<=data_ram[2];
    data_ram[2]<=data_ram[1];
    data_ram[1]<=data_ram[0];
    data_ram[0]<=data_in;
  end
else
  begin
    data_ram[31]<=data_ram[31];
    data_ram[30]<=data_ram[30];
    data_ram[29]<=data_ram[29];
    data_ram[28]<=data_ram[28];
    data_ram[27]<=data_ram[27];
    data_ram[26]<=data_ram[26];
    data_ram[25]<=data_ram[25];
    data_ram[24]<=data_ram[24];
    data_ram[23]<=data_ram[23];
    data_ram[22]<=data_ram[22];
    data_ram[21]<=data_ram[21];
    data_ram[20]<=data_ram[20];
    data_ram[19]<=data_ram[19];
    data_ram[18]<=data_ram[18];
    data_ram[17]<=data_ram[17];
    data_ram[16]<=data_ram[16];
    data_ram[15]<=data_ram[15];
    data_ram[14]<=data_ram[14];
    data_ram[13]<=data_ram[13];
    data_ram[12]<=data_ram[12];
    data_ram[11]<=data_ram[11];
    data_ram[10]<=data_ram[10];
    data_ram[9]<=data_ram[9];
    data_ram[8]<=data_ram[8];
    data_ram[7]<=data_ram[7];
    data_ram[6]<=data_ram[6];
    data_ram[5]<=data_ram[5];
    data_ram[4]<=data_ram[4];
    data_ram[3]<=data_ram[3];
    data_ram[2]<=data_ram[2];
    data_ram[1]<=data_ram[1];
    data_ram[0]<=data_ram[0];
  end
  

  
endmodule
  
    
  

