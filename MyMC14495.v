`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:48:34 11/01/2021 
// Design Name: 
// Module Name:    MyMC14495 
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
module SegDecoder(
	input [3:0]D,
	output reg [7:0]LED
   );

	always @(D) begin
		case(D)
			4'h0:LED<=8'b11000000;
			4'h1:LED<=8'b11111001;
			4'h2:LED<=8'b10100100;
			4'h3:LED<=8'b10110000;
			4'h4:LED<=8'b10011001;
			4'h5:LED<=8'b10010010;
			4'h6:LED<=8'b10000010;
			4'h7:LED<=8'b11111000;
			4'h8:LED<=8'b10000000;
			4'h9:LED<=8'b10010000;
			4'hA:LED<=8'b10001000;
			4'hB:LED<=8'b10000011;
			4'hC:LED<=8'b11000110;
			4'hD:LED<=8'b10100001;
			4'hE:LED<=8'b10000110;
			4'hF:LED<=8'b10001110;
		endcase
	end

endmodule
