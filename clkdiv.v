`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:05:01 12/12/2021 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(clk,clk_out);
	parameter n=26;
	input clk;
	output clk_out;
	
	reg [n-1:0] cnt;
	always@(posedge clk)begin
		cnt<=cnt+1;
	end
	assign clk_out=cnt[n-1];

endmodule
