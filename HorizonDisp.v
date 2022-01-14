`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:04:31 12/17/2021 
// Design Name: 
// Module Name:    HorizonDisp 
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
module HorizonDisp(clk,game_clk,rst,over,row,col,d_out);
	input clk;
	input game_clk;
	input rst;
	input over;
	input [8:0] row;
	input [9:0] col;
	output reg [11:0] d_out;
	
	localparam HorizonLeft = 20; // leave 20 px space
	localparam HorizonW = 600;
	localparam HorizonH = 14;
	localparam HorizonTop = 335;
	reg [9:0] TransCol; // terrain toggle column
	reg [1:0] terrain; // [0] left type, [1] right type
	wire [29:0] rand;
	random rnd(clk,rand);
	wire terrain1=rand<30'h214748364; // next terrain type
	always@(posedge game_clk)begin
		if(rst)begin
			TransCol<=HorizonW;
			terrain<=0;
		end else
		if(!over)begin
			if(TransCol)
				TransCol<=TransCol-1; // move toggle point
			else begin // left terrain end
				TransCol<=HorizonW;
				terrain[0]<=terrain[1];
				terrain[1]<=terrain1;
			end
		end
	end
	
	reg [13:0] H1addr;
	wire H1data;
	horizon1 h1 (
	  .clka(clk), // input clka
	  .addra(H1addr), // input [13 : 0] addra
	  .douta(H1data) // output [0 : 0] douta
	);
	reg [13:0] H2addr;
	wire H2data;
	horizon2 h2 (
	  .clka(clk), // input clka
	  .addra(H2addr), // input [13 : 0] addra
	  .douta(H2data) // output [0 : 0] douta
	);
	reg terrainid; // terrain *type* in last cycle
	always@(posedge clk)begin
		if(row>=HorizonTop && row<HorizonTop+HorizonH &&
		col>=HorizonLeft && col<=HorizonLeft+HorizonW)begin
			if(col>HorizonLeft)
				d_out<=terrainid?(H2data?12'h048:12'hfff):
									  (H1data?12'h048:12'hfff);
			if(col<HorizonLeft+HorizonW)begin // left side
				if(col-HorizonLeft<TransCol)begin
					if(terrain[0])
						H2addr<=(row-HorizonTop)*HorizonW+
						HorizonW-(TransCol-(col-HorizonLeft));
					else
						H1addr<=(row-HorizonTop)*HorizonW+
						HorizonW-(TransCol-(col-HorizonLeft));
					terrainid<=terrain[0];
				end else // right side
				begin
					if(terrain[1])
						H2addr<=(row-HorizonTop)*HorizonW+
						col-HorizonLeft-TransCol;
					else
						H1addr<=(row-HorizonTop)*HorizonW+
						col-HorizonLeft-TransCol;
					terrainid<=terrain[1];
				end
			end
		end else
			d_out<=12'hfff;
	end
endmodule
