`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:44 12/15/2021 
// Design Name: 
// Module Name:    gameoverDisp 
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
module gameoverDisp(clk,row,col,d_out);
	input clk;
	input [8:0] row;
	input [9:0] col;
	output [11:0] d_out;

	localparam W = 198;
	localparam H = 71;
	localparam left = 220;
	localparam top = 204;
	wire indisp;
	assign indisp = row >= top && row < top + H &&
						 col >= left && col < left + W;
	wire [13:0] addr;
	assign addr = indisp ? (row - top) * W + col - left : 0;
	wire douta;
	gameover ins (
	  .clka(clk), // input clka
	  .addra(addr), // input [13 : 0] addra
	  .douta(douta) // output [0 : 0] douta
	);
	assign d_out = douta ? 12'h12c : 12'hfff;
endmodule
