`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:06:46 12/26/2021 
// Design Name: 
// Module Name:    SoundCtrl 
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
module SoundBasic(clk,rst,buzzer,waves);
	input clk;
	input rst;
	output reg buzzer;
	output reg [8:0] waves; // number of half waves
	parameter maxcnt = 100_000_000 / 500 / 2;//500 Hz
	
	reg [20:0] cnt;
	always@(posedge clk)
		if(rst)begin
			cnt<=0;
			buzzer<=0;
			waves<=0;
		end
		else if(cnt<maxcnt)
			cnt<=cnt+1;
		else begin
			cnt<=0;
			buzzer<=~buzzer;
			waves<=waves+1;
		end
endmodule

module SoundCtrl(clk,rst,jumping,milestone,over,buzzer);
	input clk;
	input rst;
	input jumping,milestone,over;
	output reg buzzer;

	localparam silence = 0; // state types
	localparam jump = 1;
	localparam milestone1 = 2;
	localparam milestone2 = 3;
	localparam dead1 = 4;
	localparam dead0 = 5;
	localparam dead2 = 6;
	reg [2:0] state;
	
	reg hcrst,hgrst,lorst;
	wire [8:0] hcwaves,hgwaves,lowaves;
	wire hcbuz,hgbuz,lobuz;
	SoundBasic #(100_000_000/514/2) sbhc(clk,hcrst|rst,hcbuz,hcwaves);
	SoundBasic #(100_000_000/767/2) sbhg(clk,hgrst|rst,hgbuz,hgwaves);
	SoundBasic #(100_000_000/64/2) sblo(clk,lorst|rst,lobuz,lowaves);
	
	always@(posedge clk)begin // output according to state
		if(state==silence||state==dead0)
			buzzer<=0;
		else if(state==jump||state==milestone1)
			buzzer<=hcbuz;
		else if(state==milestone2)
			buzzer<=hgbuz;
		else if(state==dead1||state==dead2)
			buzzer<=lobuz;
	end
	
	reg oldjmp,oldmile,oldover; // for detecting posedge
	always@(posedge clk)begin
		if(rst)begin
			state<=silence;
		end else
		if(state==jump)begin
			hcrst<=0; // rst done
			if(hcwaves==38)
				state<=silence;
		end else
		if(state==milestone1)begin
			hcrst<=0;
			if(hcwaves==81)begin
				state<=milestone2;
				hgrst<=1; // rst next wave
			end
		end else
		if(state==milestone2)begin
			hgrst<=0;
			if(hgwaves==342)
				state<=silence;
		end else
		if(state==dead1)begin
			if(lowaves==5)begin
				state<=dead0;
				lorst<=1;
			end else
				lorst<=0;
		end else
		if(state==dead0)begin
			if(lowaves==4)begin
				state<=dead2;
				lorst<=1;
			end else
				lorst<=0;
		end else
		if(state==dead2)begin
			lorst<=0;
			if(lowaves==10)
				state<=silence;
		end else
		if(!oldjmp&&jumping)begin
			state<=jump;
			hcrst<=1; // rst for 1 cycle
		end else
		if(!oldmile&&milestone)begin
			state<=milestone1;
			hcrst<=1;
		end else
		if(!oldover&&over)begin
			state<=dead1;
			lorst<=1;
		end
		oldjmp<=jumping;
		oldmile<=milestone;
		oldover<=over;
	end
endmodule
