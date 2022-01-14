`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:50:55 12/12/2021 
// Design Name: 
// Module Name:    ObstacleCtrl 
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
module ObstacleCtrl(clk,game_clk,rst,over,minEmpty,obstacle1,obstacle2,obstacle3,score);
	input clk;
	input game_clk;
	input rst;
	input over; // game over
	input [8:0] minEmpty;
	// min pixels to keep empty (without obstacle)
	output reg [14:0] obstacle1,obstacle2,obstacle3;
	// obstacle fmt: en'type<4>'col<10>
	output reg [15:0] score; // current score
	
	localparam Nothing = 4'd0; // obstacle types
	localparam CactusS1 = 4'd1;
	localparam CactusS2 = 4'd2;
	localparam CactusS3 = 4'd3;
	localparam CactusL1 = 4'd5;
	localparam CactusL2 = 4'd6;
	localparam CactusL3 = 4'd7;
	localparam BirdL = 4'd9;
	localparam BirdM = 4'd10;
	localparam BirdH = 4'd11;
	localparam NothingEqui = 9'd53;
	// equivalent empty pixels of obstacle "Nothing"
	localparam newObstacleCol = 10'd700;
	// column of new obstacle
	reg [8:0] emptyCnt;
	// empty pixels, when reach minEmpty, generate obstacle
	reg [3:0] nextObstacle;
	// type of next obstacle
	wire [29:0] rand; // random 30-bit int
	random rnd(clk,rand);
	always@(posedge clk) // generate random nextObstacle
		if(rand<30'h23333333)
			nextObstacle<=Nothing;
		else if(rand<30'h27777777)
			nextObstacle<=CactusS1;
		else if(rand<30'h2bbbbbbb)
			nextObstacle<=CactusS2;
		else if(rand<30'h2fffffff)
			nextObstacle<=CactusS3;
		else if(rand<30'h34444444)
			nextObstacle<=CactusL1;
		else if(rand<30'h38888888)
			nextObstacle<=CactusL2;
		else if(rand<30'h3ccccccc)
			nextObstacle<=CactusL3;
		else if(rand<30'h3ddddddd)
			nextObstacle<=BirdL;
		else if(rand<30'h3eeeeeee)
			nextObstacle<=BirdM;
		else
			nextObstacle<=BirdH;
	reg [4:0] pxcnt;
	// pixels moved since last score update
	wire [15:0] sum;
	// score+1 in BCD code
	bcdAdder4d bcdadder(score,16'b1,sum);
	always@(posedge game_clk)begin
		if(rst==1)begin
			emptyCnt<=0;
			obstacle1<=0; // disable all obstacles
			obstacle2<=0;
			obstacle3<=0;
			score<=0;
			pxcnt<=0;
		end else
		if(!over)begin
			if(obstacle1[14]&obstacle2[14]&obstacle3[14]==1)
				emptyCnt<=0; // all slots full, don't generate obstacle
			else if (emptyCnt < minEmpty)
				emptyCnt<=emptyCnt+1;
			else if (nextObstacle!=Nothing) begin
				if(obstacle1[14]==0) // find empty obstacle slot and enable
					obstacle1<={1'b1,nextObstacle,newObstacleCol};
				else if(obstacle2[14]==0)
					obstacle2<={1'b1,nextObstacle,newObstacleCol};
				else
					obstacle3<={1'b1,nextObstacle,newObstacleCol};
				emptyCnt<=0;
			end else // obstacle "Nothing" equivalent
				emptyCnt<=emptyCnt-NothingEqui;
			
			if(obstacle1[14]&obstacle2[14]&obstacle3[14]==1
			  ||emptyCnt<minEmpty||nextObstacle==Nothing)begin
			  // no new slot enabled this clock
				if(obstacle1[9:0]==0)
					obstacle1[14]<=0; // move out of screen, free it
				else if(obstacle1[14])
					obstacle1[9:0]<=obstacle1[9:0]-1;
				else begin // problematic
					obstacle1<=0;
					//score<=score+16'h1000;
				end
				if(obstacle2[9:0]==0)
					obstacle2[14]<=0;
				else if(obstacle2[14])
					obstacle2[9:0]<=obstacle2[9:0]-1;
				else begin // problematic
					obstacle2<=0;
					//score<=score+16'h1000;
				end
				if(obstacle3[9:0]==0)
					obstacle3[14]<=0;
				else if(obstacle3[14])
					obstacle3[9:0]<=obstacle3[9:0]-1;
				else begin // problematic
					obstacle3<=0;
					//score<=score+16'h1000;
				end
			end
			
			if(pxcnt<20)
				pxcnt<=pxcnt+1;
			else begin // 20 px=1 point
				score<=sum; // inc score
				pxcnt<=0;
			end
		end
	end

endmodule
