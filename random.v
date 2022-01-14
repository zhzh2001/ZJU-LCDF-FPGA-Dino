`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:11:11 12/12/2021 
// Design Name: 
// Module Name:    random 
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
module random(
	input  wire clk,
	output reg [29:0] data
);

// fibonacci_lfsr
	initial
		data = 30'h20000029;
	wire feedback = data[29] ^ data[5] ^ data[3] ^ data[0];
	always @(posedge clk)
		data <= {data[28:0], feedback};

endmodule
