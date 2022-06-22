`timescale 1ns/1ns

/*************************************************
this module is designed for control. All the control signal 
are from this module
*************************************************/
module control(
               clk,
               rst_n,
               
               add_en,        //this is for adder control
               out_en,        //this is for the output control
               data_in_en,    //this is to control the enable signal of the data_in
               data_counter,  //this is to control which data to choose
               co_choose);    //this is to choose the coefficient

input clk,rst_n;

output add_en,out_en,data_in_en;
output [4:0] data_counter;
output [4:0] co_choose;

wire clk,rst_n;

reg add_en,out_en,data_in_en;
reg [4:0] data_counter;
reg [4:0] co_choose;

reg [4:0] counter;   //this is for control the data or the coefficient to choose

//count the cycles
always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
    counter<=0;
  end
else
  if(counter==31)
    begin
    counter<=0;
  begin
  end
else
  begin
    counter<=counter+1;
  end
  
always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
  end
else
  begin
  end

//this is for the data_in_en 
always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
    data_in_en<=1'b0;
  end
else
  begin
    if(counter==31)
      begin
      data_in_en<=1'b1;
    end
  else
    begin
      data_in_en<=1'b0;
    end
  end
  
//this is for the data_counter
always @(posedge clk or negedge rst_n)
if(!rst_n)
  begin
    data_counter<=5'b0;
  end
else
  begin
    if
  end