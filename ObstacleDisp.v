`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:04:22 12/12/2021 
// Design Name: 
// Module Name:    ObstacleDisp 
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
module ObstacleDisp(clk,game_clk,rst,obstacle,row,col,d_out);
	input clk;
	input game_clk;
	input rst;
	input [14:0] obstacle; // en'type<4>'col<10>
	input [8:0] row; // current scan addr
	input [9:0] col;
	output reg [11:0] d_out; // pixel data
	
	localparam Nothing = 4'd0; // obstacle types
	localparam CactusS1 = 4'd1;
	localparam CactusS2 = 4'd2;
	localparam CactusS3 = 4'd3;
	localparam CactusL1 = 4'd5;
	localparam CactusL2 = 4'd6;
	localparam CactusL3 = 4'd7;
	localparam BirdLow = 4'd9;
	localparam BirdMid = 4'd10;
	localparam BirdHi = 4'd11;
	localparam CactusS1W = 17; // image sizes
	localparam CactusSH = 35;
	localparam CactusS2W = 34;
	localparam CactusS3W = 51;
	localparam CactusL1W = 25;
	localparam CactusLH = 50;
	localparam CactusL2W = 50;
	localparam CactusL3W = 75;
	localparam BirdW = 46;
	localparam BirdH = 40;
	localparam BirdLH = 350;
	localparam BirdMH = 314;
	localparam BirdHH = 286;
	localparam Ground = 347; // bottom row of image
	reg [9:0] CS1addr;
	wire [1:0] CS1data;
	cactusS1 cs1 (
	  .clka(clk), // input clka
	  .addra(CS1addr), // input [9 : 0] addra
	  .douta(CS1data) // output [1 : 0] douta
	);
	reg [10:0] CS2addr;
	wire [1:0] CS2data;
	cactusS2 cs2 (
	  .clka(clk), // input clka
	  .addra(CS2addr), // input [10 : 0] addra
	  .douta(CS2data) // output [1 : 0] douta
	);
	reg [10:0] CS3addr;
	wire [1:0] CS3data;
	cactusS3 cs3 (
	  .clka(clk), // input clka
	  .addra(CS3addr), // input [10 : 0] addra
	  .douta(CS3data) // output [1 : 0] douta
	);
	reg [10:0] CL1addr;
	wire [1:0] CL1data;
	cactusL1 cl1 (
	  .clka(clk), // input clka
	  .addra(CL1addr), // input [10 : 0] addra
	  .douta(CL1data) // output [1 : 0] douta
	);
	reg [11:0] CL2addr;
	wire [1:0] CL2data;
	cactusL2 cl2 (
	  .clka(clk), // input clka
	  .addra(CL2addr), // input [11 : 0] addra
	  .douta(CL2data) // output [1 : 0] douta
	);
	reg [11:0] CL3addr;
	wire [1:0] CL3data;
	cactusL3 cl3 (
	  .clka(clk), // input clka
	  .addra(CL3addr), // input [11 : 0] addra
	  .douta(CL3data) // output [1 : 0] douta
	);
	reg [10:0] B1addr;
	wire [1:0] B1data;
	bird1 b1 (
	  .clka(clk), // input clka
	  .addra(B1addr), // input [10 : 0] addra
	  .douta(B1data) // output [1 : 0] douta
	);
	reg [10:0] B2addr;
	wire [1:0] B2data;
	bird2 b2 (
	  .clka(clk), // input clka
	  .addra(B2addr), // input [10 : 0] addra
	  .douta(B2data) // output [1 : 0] douta
	);
	wire slow_game_clk; // for bird fly animation
	clkdiv #(8) cdiv2(game_clk,slow_game_clk);
	wire [8:0] BirdBottom = (obstacle[13:10]==BirdLow)?BirdLH:
									(obstacle[13:10]==BirdMid)?BirdMH:
									BirdHH; // compute bottom row of bird
	wire [1:0] Bdata = (slow_game_clk||rst)?B1data:B2data;
	always@(posedge clk)begin
		if(obstacle[14]==1) // enabled
		begin
			if(obstacle[13:10]==Nothing)
				d_out<=12'hfff; // something wrong
			else if(obstacle[13:10]==CactusS1)
			begin
				if(row>=Ground-CactusSH && row<Ground &&
					col+CactusS1W>=obstacle[9:0] && col<=obstacle[9:0]) begin
					// within obstacle region
					if(col+CactusS1W>obstacle[9:0])
					// write pixel data from previous cycle, not on first cycle
						case(CS1data)
							2'b00:d_out<=12'hfff; // background
							2'b01:d_out<=12'heee; // border
							2'b10:d_out<=12'h0f0; // green cactus!
							2'b11:d_out<=12'h000; // something wrong
						endcase
					if(col<obstacle[9:0])
					// write addr for ROM, not on last cycle
						CS1addr <= (row-(Ground-CactusSH))*CactusS1W
									+ col-(obstacle[9:0]-CactusS1W);
				end else
					d_out <= 12'hfff; // out of region
			end
			else if(obstacle[13:10]==CactusS2)
			begin
				if(row>=Ground-CactusSH && row<Ground &&
					col+CactusS2W>=obstacle[9:0] && col<=obstacle[9:0]) begin
					if(col+CactusS2W>obstacle[9:0])
						case(CS2data)
							2'b00:d_out<=12'hfff;
							2'b01:d_out<=12'heee;
							2'b10:d_out<=12'h0f0;
							2'b11:d_out<=12'h000;
						endcase
					if(col<obstacle[9:0])
						CS2addr <= (row-(Ground-CactusSH))*CactusS2W
									+ col-(obstacle[9:0]-CactusS2W);
				end else
					d_out <= 12'hfff;
			end
			else if(obstacle[13:10]==CactusS3)
			begin
				if(row>=Ground-CactusSH && row<Ground &&
					col+CactusS3W>=obstacle[9:0] && col<=obstacle[9:0]) begin
					if(col+CactusS3W>obstacle[9:0])
						case(CS3data)
							2'b00:d_out<=12'hfff;
							2'b01:d_out<=12'heee;
							2'b10:d_out<=12'h0f0;
							2'b11:d_out<=12'h000;
						endcase
					if(col<obstacle[9:0])
						CS3addr <= (row-(Ground-CactusSH))*CactusS3W
									+ col-(obstacle[9:0]-CactusS3W);
				end else
					d_out <= 12'hfff;
			end
			else if(obstacle[13:10]==CactusL1)
			begin
				if(row>=Ground-CactusLH && row<Ground &&
					col+CactusL1W>=obstacle[9:0] && col<=obstacle[9:0]) begin
					if(col+CactusL1W>obstacle[9:0])
						case(CL1data)
							2'b00:d_out<=12'hfff;
							2'b01:d_out<=12'heee;
							2'b10:d_out<=12'h0f0;
							2'b11:d_out<=12'h000;
						endcase
					if(col<obstacle[9:0])
						CL1addr <= (row-(Ground-CactusLH))*CactusL1W
									+ col-(obstacle[9:0]-CactusL1W);
				end else
					d_out <= 12'hfff;
			end
			else if(obstacle[13:10]==CactusL2)
			begin
				if(row>=Ground-CactusLH && row<Ground &&
					col+CactusL2W>=obstacle[9:0] && col<=obstacle[9:0]) begin
					if(col+CactusL2W>obstacle[9:0])
						case(CL2data)
							2'b00:d_out<=12'hfff;
							2'b01:d_out<=12'heee;
							2'b10:d_out<=12'h0f0;
							2'b11:d_out<=12'h000;
						endcase
					if(col<obstacle[9:0])
						CL2addr <= (row-(Ground-CactusLH))*CactusL2W
									+ col-(obstacle[9:0]-CactusL2W);
				end else
					d_out <= 12'hfff;
			end
			else if(obstacle[13:10]==CactusL3)
			begin
				if(row>=Ground-CactusLH && row<Ground &&
					col+CactusL3W>=obstacle[9:0] && col<=obstacle[9:0]) begin
					if(col+CactusL3W>obstacle[9:0])
						case(CL3data)
							2'b00:d_out<=12'hfff;
							2'b01:d_out<=12'heee;
							2'b10:d_out<=12'h0f0;
							2'b11:d_out<=12'h000;
						endcase
					if(col<obstacle[9:0])
						CL3addr <= (row-(Ground-CactusLH))*CactusL3W
									+ col-(obstacle[9:0]-CactusL3W);
				end else
					d_out <= 12'hfff;
			end
			else // bird now
			begin
				if(row>=BirdBottom-BirdH && row<BirdBottom &&
					col+BirdW>=obstacle[9:0] && col<=obstacle[9:0]) begin
					if(col+BirdW>obstacle[9:0])
						case(Bdata)
							2'b00:d_out<=12'hfff;
							2'b01:d_out<=12'heee;
							2'b10:d_out<=12'h2ff; // yellow bird!
							2'b11:d_out<=12'h000;
						endcase
					if(col<obstacle[9:0])begin
					   // compute two addr altogether
						B1addr <= (row-(BirdBottom-BirdH))*BirdW
									+ col-(obstacle[9:0]-BirdW);
						B2addr <= (row-(BirdBottom-BirdH))*BirdW
									+ col-(obstacle[9:0]-BirdW);
					end
				end else
					d_out <= 12'hfff;
			end
		end else
			d_out<=12'hfff; // not enabled
	end

endmodule
