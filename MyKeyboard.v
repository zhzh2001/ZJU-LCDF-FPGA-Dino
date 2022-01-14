`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:40 12/15/2021 
// Design Name: 
// Module Name:    MyKeyboard 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MyKeyboard(clk,ps2_clk,ps2_data,key);
	input clk;
	input ps2_clk;
	input ps2_data;
	output [1:0] key;

	localparam NoKey=2'b00;
	localparam Up=2'b01;
	localparam Down=2'b10;
	localparam OtherKey=2'b11;
	wire ready,overflow;
	wire [7:0] raw_data;
	reg [7:0] last_raw,data;
	ps2_keyboard ps2(clk,1'b1,ps2_clk,ps2_data,1'b0,raw_data,ready,overflow);
	
	always@(posedge clk)begin
		if(ready&&raw_data!=8'he0)begin
			if(last_raw==8'hf0)
				data<=8'h00;
			else if(raw_data!=8'hf0)
				data<=raw_data;
			last_raw<=raw_data;
		end
	end
	
	assign key=(data==8'h00)?NoKey:
				  (data==8'h1d||data==8'h43||data==8'h75||data==8'h29)?Up:
				  (data==8'h1b||data==8'h42||data==8'h72)?Down:
				  OtherKey;

endmodule
