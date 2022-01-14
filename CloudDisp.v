`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:29:33 12/17/2021 
// Design Name: 
// Module Name:    CloudDisp 
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
module CloudDisp(clk,cloud,row,col,d_out);
	input clk;
	input [15:0] cloud;
	input [8:0] row;
	input [9:0] col;
	output reg [11:0] d_out;

	localparam CloudW = 92;
	localparam CloudH = 27;
	localparam CloudTop = 9'd200;
	reg [11:0] Caddr;
	wire Cdata;
	cloud cld (
	  .clka(clk), // input clka
	  .addra(Caddr), // input [11 : 0] addra
	  .douta(Cdata) // output [0 : 0] douta
	);
	wire [8:0] ctop = CloudTop+{4'b0,cloud[14:10]};
	// adjust cloud row with offset
	always@(posedge clk)begin
		if(cloud[15]==1)begin
			if(row>=ctop && row<ctop+CloudH &&
				col+CloudW>=cloud[9:0] && col<=cloud[9:0])begin
				if(col+CloudW>cloud[9:0])
					d_out<=Cdata?12'hfa2:12'hfff;
				if(col<cloud[9:0])
					Caddr<=(row-ctop)*CloudW+col-(cloud[9:0]-CloudW);
			end else
				d_out<=12'hfff;
		end else
			d_out<=12'hfff;
	end
endmodule
