`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:36 12/11/2017 
// Design Name: 
// Module Name:    HazardDetector 
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
module HazardDetector(MemRead_ex, RegWriteAddr_ex, RsAddr_id, RtAddr_id, stall, PC_IFWrite);
	input MemRead_ex;
	input [31:0] RegWriteAddr_ex;
	input [31:0]RsAddr_id;
	input [31:0]RtAddr_id;
	output stall;
	output PC_IFWrite;
	
	assign stall = ((RegWriteAddr_ex==RsAddr_id)||(RegWriteAddr_ex==RtAddr_id))&&MemRead_ex;
	assign PC_IFWrite = ~stall;

endmodule
