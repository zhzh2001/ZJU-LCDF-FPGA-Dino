`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:18 12/15/2021 
// Design Name: 
// Module Name:    bcdAdder 
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
module bcdAdder1d(a,b,c,cin,cout);
	input [3:0] a,b;
	output [3:0] c;
	input cin;
	output cout;

	wire [4:0] sum;
	assign sum = {1'b0,a} + {1'b0,b} + {4'b0,cin};
	assign {cout,c} = (sum > 5'd9) ? sum + 5'd6 : sum;
endmodule

module bcdAdder4d(a,b,c);
	input [15:0] a,b;
	output [15:0] c;

	wire [3:0] carry;
	bcdAdder1d m0(a[3:0],b[3:0],c[3:0],1'b0,carry[0]);
	bcdAdder1d m1(a[7:4],b[7:4],c[7:4],carry[0],carry[1]);
	bcdAdder1d m2(a[11:8],b[11:8],c[11:8],carry[1],carry[2]);
	bcdAdder1d m3(a[15:12],b[15:12],c[15:12],carry[2],carry[3]);
endmodule
