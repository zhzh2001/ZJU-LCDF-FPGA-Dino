`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:57:35 12/12/2021 
// Design Name: 
// Module Name:    DinoDisp 
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
module DinoDisp(clk,game_clk,rst,over,cheat,row,col,key,d_out,jumping);
	input clk;
	input game_clk;
	input rst;
	input over; // game over
	input cheat; // cheating, dino will float in the sky
	input [8:0] row; // current scan addr
	input [9:0] col;
	input [1:0] key; // key pressed
	output [11:0] d_out; // pixel data
	output jumping;
	
	localparam dinoDefaultW = 44; // image size
	localparam dinoDefaultH = 47;
	localparam dinoDuckW = 59;
	localparam dinoDuckH = 30;
	localparam dinoCol = 50;
	localparam Ground = 300; // top row of dino
	localparam DuckPos = Ground + dinoDefaultH - dinoDuckH;
	// top row of ducked dino
	localparam G = 1; // gravity acceleration
	localparam initV = -5'd15; // jump initial velocity
	reg [8:0] pos = Ground; // actual dino row
	wire indino = row >= pos && row < pos + dinoDefaultH && 
					  col >= dinoCol && col < dinoCol + dinoDefaultW;
					  // current addr in dino?
	wire [11:0] dinoDefaultAddr = 
			indino ? (row - pos) * dinoDefaultW + col - dinoCol : 0;
			// if in, compute the addr in ROM
	wire [1:0] doutDefault,doutDead,doutLeft,doutRight;
	// data out from ROM
	dinoDefault dino1 (
	  .clka(clk), // input clka
	  .addra(dinoDefaultAddr), // input [11 : 0] addra
	  .douta(doutDefault) // output [1 : 0] douta
	);
	dinoDead dino2 (
	  .clka(clk), // input clka
	  .addra(dinoDefaultAddr), // input [11 : 0] addra
	  .douta(doutDead) // output [1 : 0] douta
	);
	dinoLeft dino3 (
	  .clka(clk), // input clka
	  .addra(dinoDefaultAddr), // input [11 : 0] addra
	  .douta(doutLeft) // output [1 : 0] douta
	);
	dinoRight dino4 (
	  .clka(clk), // input clka
	  .addra(dinoDefaultAddr), // input [11 : 0] addra
	  .douta(doutRight) // output [1 : 0] douta
	);
	wire indinoduck = row >= DuckPos && row < DuckPos + dinoDuckH && 
					      col >= dinoCol && col < dinoCol + dinoDuckW;
							// current addr in ducked dino?
	wire [10:0] dinoDuckAddr = 
			indinoduck ? (row - DuckPos) * dinoDuckW + col - dinoCol : 0;
	wire [1:0] doutDuckLeft,doutDuckRight;
	dinoDuckLeft dino5 (
	  .clka(clk), // input clka
	  .addra(dinoDuckAddr), // input [10 : 0] addra
	  .douta(doutDuckLeft) // output [1 : 0] douta
	);
	dinoDuckRight dino6 (
	  .clka(clk), // input clka
	  .addra(dinoDuckAddr), // input [10 : 0] addra
	  .douta(doutDuckRight) // output [1 : 0] douta
	);
	
	wire myclk;
	clkdiv #(19) cdiv(clk,myclk); // clock for physics engine
	reg jumping = 0;
	reg [4:0] v = 0; // dino velocity, down positive
	always@(posedge myclk)begin
		if (over || v == -initV)
			jumping <= 0; // game over or reach ground (v=-v0)
		if (rst)
			pos <= Ground; // reset pos to ground
		if (!over && !jumping && key==2'b01)begin
			jumping <= 1;
			v <= initV; // jump only when allowed
		end
		if (jumping)begin
			pos <= pos + {{4{v[4]}},v}; // sign extension
			v <= v + G; // update displacement and velocity
		end
		if (cheat)
			pos <= 100; // float
	end
	
	wire slow_game_clk; // for dino run animation
	clkdiv #(6) cdiv2(game_clk,slow_game_clk);
	wire [1:0] dout1=!indino?2'b00: // not in region, don't display
						  over?doutDead: // game over, display dead
						  jumping?doutDefault: // jumping, still image
						  (key==2'b10)?2'b00: // ducked, don't display
						  slow_game_clk?doutLeft: // perform animation
						  doutRight;
	wire [11:0] data1=(dout1==2'b00)?12'hfff: // background
							(dout1==2'b01)?12'heee: // border
							(dout1==2'b10)?12'h48f: // red dino!
							12'h000; // oops, something wrong
	wire [1:0] dout2=(!indinoduck||over||key!=2'b10||jumping)?2'b00:
							// not in region or not ducked or not allowed
						  slow_game_clk?doutDuckLeft: // perform ducked animation
						  doutDuckRight;
	wire [11:0] data2=(dout2==2'b00)?12'hfff:
							(dout2==2'b01)?12'heee:
							(dout2==2'b10)?12'h48f:
							12'h000;
	assign d_out = data1&data2; // at most one is not hfff
endmodule
