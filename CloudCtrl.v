`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:03:06 12/17/2021 
// Design Name: 
// Module Name:    CloudCtrl 
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
module CloudCtrl(clk,rst,over,cloud1,cloud2,cloud3,cloud4);
	input clk;
	input rst;
	input over;
	output reg [15:0] cloud1,cloud2,cloud3,cloud4;
	// cloud fmt: en'row_offset<5>'col<10>

	// logic simplified from ObstacleCtrl, not commented again
	localparam minEmpty = 114;
	localparam newCloudCol = 10'd700;
	wire [29:0] rand;
	random rnd(clk,rand);
	wire cloud_clk;
	clkdiv #(20) cdiv(clk,cloud_clk);
	reg [6:0] emptyCnt;
	wire newCloud = rand < 30'h12345678;
	always@(posedge cloud_clk)begin
		if(rst)begin
			emptyCnt<=0;
			cloud1<=0;
			cloud2<=0;
			cloud3<=0;
			cloud4<=0;
		end else
		if(!over)begin
			if(cloud1[15]&cloud2[15]&cloud3[15]&cloud4[15]==1)
				emptyCnt<=0;
			else if(emptyCnt<minEmpty)
				emptyCnt<=emptyCnt+1;
			else if(newCloud)begin
				if(cloud1[15]==0)
					cloud1<={1'b1,rand[15:11],newCloudCol};
				else if(cloud2[15]==0)
					cloud2<={1'b1,rand[5:1],newCloudCol};
				else if(cloud3[15]==0)
					cloud3<={1'b1,rand[29:25],newCloudCol};
				else
					cloud4<={1'b1,rand[12:8],newCloudCol};
				emptyCnt<=0;
			end else
				emptyCnt<=emptyCnt-29;
			
			if(cloud1[15]&cloud2[15]&cloud3[15]&cloud4[15]==1||
				emptyCnt<minEmpty||!newCloud)begin
				if(cloud1[9:0]==0)
					cloud1[15]<=0;
				else if(cloud1[15])
					cloud1[9:0]<=cloud1[9:0]-1;
				else
					cloud1<=0;
				if(cloud2[9:0]==0)
					cloud2[15]<=0;
				else if(cloud2[15])
					cloud2[9:0]<=cloud2[9:0]-1;
				else
					cloud2<=0;
				if(cloud3[9:0]==0)
					cloud3[15]<=0;
				else if(cloud3[15])
					cloud3[9:0]<=cloud3[9:0]-1;
				else
					cloud3<=0;
				if(cloud4[9:0]==0)
					cloud4[15]<=0;
				else if(cloud4[15])
					cloud4[9:0]<=cloud4[9:0]-1;
				else
					cloud4<=0;
			end
		end
	end
endmodule
