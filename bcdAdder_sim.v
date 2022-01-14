`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:04:40 01/09/2022
// Design Name:   bcdAdder4d
// Module Name:   D:/src/ISE/Dino/bcdAdder_sim.v
// Project Name:  Dino
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bcdAdder4d
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bcdAdder_sim;

	// Inputs
	reg [15:0] a;
	reg [15:0] b;

	// Outputs
	wire [15:0] c;

	// Instantiate the Unit Under Test (UUT)
	bcdAdder4d uut (
		.a(a), 
		.b(b), 
		.c(c)
	);

	initial begin
		a = 16'h1234;
		b = 16'h2918;#10;
		a = 16'h9999;
		b = 16'h0001;#10;
		a = 16'h0001;
		b = 16'h7999;#10;
		a = 16'h1234;
		b = 16'h4321;#10;
	end
      
endmodule

