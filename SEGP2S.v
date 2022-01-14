`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:35:24 12/15/2021 
// Design Name: 
// Module Name:    SEGP2S 
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
module SEGP2S(clk,num,SEGCLK,SEGCLR,SEGDT,SEGEN);
	input clk;
	input [63:0] num;
	output SEGCLK;
	output SEGCLR;
	output SEGDT; // transmit MSB first
	output SEGEN;

	reg [64:0] shift = 0;
	reg [63:0] old_num = 0;
	wire moving = | shift[63:0]; // not finish yet
	assign SEGCLK = ~clk & moving; // complement clock
	assign SEGDT = shift[64]; // MSB
	assign SEGCLR = 1'b1;
	assign SEGEN = 1'b1;
	
	always@(posedge clk)begin
		old_num<=num;
		if(moving)
			shift={shift[63:0],1'b0}; // fill 0 for finish detection
		else if(old_num!=num)
			shift={num,1'b1}; // update number
	end
endmodule
