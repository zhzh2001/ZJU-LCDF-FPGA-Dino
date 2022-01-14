`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:28:41 12/12/2021
// Design Name:   ObstacleCtrl
// Module Name:   D:/src/ISE/ProjectTest/ObstacleCtrl_sim.v
// Project Name:  ProjectTest
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ObstacleCtrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ObstacleCtrl_sim;

	// Inputs
	reg clk;
	reg game_clk;
	reg rst;
	reg over;
	reg [8:0] minEmpty;

	// Outputs
	wire [14:0] obstacle1;
	wire [14:0] obstacle2;
	wire [14:0] obstacle3;
	wire [15:0] score;

	// Instantiate the Unit Under Test (UUT)
	ObstacleCtrl uut (
		.clk(clk), 
		.game_clk(game_clk), 
		.rst(rst), 
		.over(over), 
		.minEmpty(minEmpty), 
		.obstacle1(obstacle1), 
		.obstacle2(obstacle2), 
		.obstacle3(obstacle3), 
		.score(score)
	);

	initial begin
		// Initialize Inputs
		rst = 1;#30;
		rst = 0;
		over = 0;
		minEmpty = 10;
	end
	
	always begin
		clk = 0;
		game_clk = 0;#10;
		clk = 1;
		game_clk = 1;#10;
	end
      
endmodule

