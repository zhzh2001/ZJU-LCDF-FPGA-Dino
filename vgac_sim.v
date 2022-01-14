`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:47:56 12/11/2021
// Design Name:   vgac
// Module Name:   D:/src/ISE/ProjectTest/vgac_sim.v
// Project Name:  ProjectTest
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vgac
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vgac_sim;

	// Inputs
	reg vga_clk;
	reg clrn;
	reg [11:0] d_in;

	// Outputs
	wire [8:0] row_addr;
	wire [9:0] col_addr;
	wire rdn;
	wire [3:0] r;
	wire [3:0] g;
	wire [3:0] b;
	wire hs;
	wire vs;

	// Instantiate the Unit Under Test (UUT)
	vgac uut (
		.vga_clk(vga_clk), 
		.clrn(clrn), 
		.d_in(d_in), 
		.row_addr(row_addr), 
		.col_addr(col_addr), 
		.rdn(rdn), 
		.r(r), 
		.g(g), 
		.b(b), 
		.hs(hs), 
		.vs(vs)
	);

	initial begin
		d_in=12'b100001000010;
		clrn=0;#30;
		clrn=1;
	end
	
	always begin
		vga_clk=0;#20;
		vga_clk=1;#20;
	end
      
endmodule

