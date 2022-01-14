`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:33:55 12/12/2021 
// Design Name: 
// Module Name:    main 
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
module main(clk,ps2_clk,ps2_data,SW,R,G,B,HS,VS,LED,SEGCLK,SEGCLR,SEGDT,SEGEN,buzzer);
	input clk; // 100 MHz clock
	input ps2_clk; // PS/2 signals
	input ps2_data;
	input [15:0] SW;
	output [3:0] R,G,B; // VGA signals
	output HS,VS;
	output [7:0] LED;
	output SEGCLK,SEGCLR,SEGDT,SEGEN; // static 7-segment signals
	output buzzer; // buzzer sound driver

	wire clkdiv2; // VGA clock
	clkdiv #(2) cdiv(clk,clkdiv2);
	wire [11:0] dinodata;
	wire [8:0] row;
	wire [9:0] col;
	wire [1:0] key;
	MyKeyboard kbd(clk,ps2_clk,ps2_data,key);
	reg over = 0; // is game over
	reg rst; // reset when any key pressed in game over scene
	wire game_clk;
	wire [8:0] minEmpty;
	gameclk gc(clk,rst,game_clk,minEmpty);
	wire jumping;
	DinoDisp dinodisp(clkdiv2,game_clk,rst,over,SW[0],row,col,key,dinodata,jumping);
	
	wire [14:0] obstacle1,obstacle2,obstacle3;
	wire [15:0] score;
	reg [15:0] hi=0; // highest score achieved
	ObstacleCtrl obsc(clkdiv2,game_clk,rst,over,minEmpty,obstacle1,obstacle2,obstacle3,score);
	wire [11:0] data1,data2,data3;
	ObstacleDisp obsd1(clkdiv2,game_clk,over,obstacle1,row,col,data1);
	ObstacleDisp obsd2(clkdiv2,game_clk,over,obstacle2,row,col,data2);
	ObstacleDisp obsd3(clkdiv2,game_clk,over,obstacle3,row,col,data3);
	wire [11:0] obsdata = data1&data2&data3;
	
	wire [15:0] cloud1,cloud2,cloud3,cloud4;
	CloudCtrl ccl(clkdiv2,rst,over,cloud1,cloud2,cloud3,cloud4);
	wire [11:0] cdout1,cdout2,cdout3,cdout4;
	CloudDisp cdp1(clkdiv2,cloud1,row,col,cdout1);
	CloudDisp cdp2(clkdiv2,cloud2,row,col,cdout2);
	CloudDisp cdp3(clkdiv2,cloud3,row,col,cdout3);
	CloudDisp cdp4(clkdiv2,cloud4,row,col,cdout4);
	wire [11:0] cldata = cdout1&cdout2&cdout3&cdout4;
	
	wire [11:0] godata;
	gameoverDisp god(clkdiv2,row,col,godata);
	wire [11:0] hodata;
	HorizonDisp hod(clkdiv2,game_clk,rst,over,row,col,hodata);
	
	reg released; // is key released
	reg froze = 1; // froze when game first initialized
	always@(posedge clk)begin
		if(!rst&&dinodata!=12'hfff&&obsdata!=12'hfff)begin
			// collision detected
			over <= 1; // game over!
			released <= 0; // key not released yet
			if(score>hi)
				hi<=score;
		end
		if(over && !key)
			released <= 1; // key released now
		if(over && released && key)begin
			// any key pressed in game over scene
			rst <= 1; // perform reset
			over <= 0;
			released <= 0;
		end
		if(rst && !key)
			released <= 1;
		if(rst && released)
			rst <= 0; // game restart now
		
		if(froze)
			rst <= 1; // always reset when frozen
		if(key)
			froze <= 0; // any key start the game
	end
	// debug use
	assign LED={3'b0,key,rst,released,over};
	
	// background brightness
	reg [3:0] bg = 4'hf;
	// 1: day mode; 0: night mode
	reg bgtype = 1;
	always@(posedge clk)begin
		if(rst)
			bgtype <= 1;
		else begin
			if(score%16'h700==0&&score)
				bgtype <= 0; // day-night transition
			if(score%16'h700==16'h200)
				bgtype <= 1; // night-day transition
		end
	end
	wire slow_game_clk; // for background transition
	clkdiv #(5) cdiv2(game_clk,slow_game_clk);
	always@(posedge slow_game_clk)begin
		if(rst)
			bg <= 4'hf; // reset to day mode
		else if(bgtype)begin
			if(bg<4'hf) // during night-day transition
				bg <= bg + 1;
		end else
			if(bg>0) // during day-night transition
				bg <= bg - 1;
	end
	wire [11:0] data = (over && godata != 12'hfff) ? godata : 
							 (dinodata != 12'hfff) ? dinodata :
							 (obsdata != 12'hfff) ? obsdata :
							 (cldata != 12'hfff) ? cldata :
							 (hodata != 12'hfff) ? hodata :
							 {3{bg}}; // display background
	wire rdn;
	vgac vga(clkdiv2,1'b1,data,row,col,rdn,R,G,B,HS,VS);
	
	wire [63:0] seg;
	SegDecoder seg1(score[3:0],seg[7:0]);
	SegDecoder seg2(score[7:4],seg[15:8]);
	SegDecoder seg3(score[11:8],seg[23:16]);
	SegDecoder seg4(score[15:12],seg[31:24]);
	SegDecoder seg5(hi[3:0],seg[39:32]);
	SegDecoder seg6(hi[7:4],seg[47:40]);
	SegDecoder seg7(hi[11:8],seg[55:48]);
	SegDecoder seg8(hi[15:12],seg[63:56]);
	// perform parallel to serial convert
	SEGP2S p2s(clk,{seg[63:40],1'b0,seg[38:0]},SEGCLK,SEGCLR,SEGDT,SEGEN);

	SoundCtrl sc(clk,rst,jumping,score%16'h100==0,over,buzzer);
endmodule
