`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:47:09 12/17/2021
// Design Name:   random
// Module Name:   D:/src/ISE/Dino/random_sim.v
// Project Name:  Dino
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: random
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module random_sim;

	// Inputs
	reg clk;

	// Outputs
	wire [29:0] data;

	// Instantiate the Unit Under Test (UUT)
	random uut (
		.clk(clk), 
		.data(data)
	);

	always begin
		clk = 0;#10;
		clk = 1;#10;
	end
      
endmodule

