`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:22:32 01/09/2022
// Design Name:   gameclk
// Module Name:   D:/src/ISE/Dino/gameclk_sim.v
// Project Name:  Dino
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: gameclk
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module gameclk_sim;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire clk_out;
	wire [8:0] minEmpty;

	// Instantiate the Unit Under Test (UUT)
	gameclk uut (
		.clk(clk), 
		.rst(rst), 
		.clk_out(clk_out), 
		.minEmpty(minEmpty)
	);

	initial begin
		rst = 1;#15;
		rst = 0;
	end
	
	always begin
		clk = 0;#5;
		clk = 1;#5;
	end
      
endmodule

