`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:31:33 12/16/2021 
// Design Name: 
// Module Name:    gameclk 
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
module gameclk(clk,rst,clk_out,minEmpty);
	input clk;
	input rst;
	output reg clk_out;
	output reg [8:0] minEmpty;

	reg [17:0] tick = 0;
	reg [17:0] maxtick = 150000; // maxtick clks = 0.5 gameclk
	reg [11:0] maxcnt = 0;
	always@(posedge clk)begin
		if(rst)begin
			tick <= 0;
			maxtick <= 150000;
			maxcnt <= 0;
			clk_out <= ~clk_out; // highest freq
			minEmpty <= 240;
		end else
		if(tick<maxtick)
			tick <= tick + 1;
		else begin
			tick <= 0;
			if(maxcnt<3000)
				maxcnt <= maxcnt + 1;
			else begin
				maxcnt <= 0;
				if(maxtick > 80000)begin // don't accelerate too much!
					maxtick <= maxtick - 3555; // increase gameclk freq
					minEmpty <= 36_000_000 / maxtick;
				end
			end
			clk_out <= ~clk_out;
		end
	end
endmodule
