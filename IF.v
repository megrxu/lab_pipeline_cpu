`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:23:21 11/12/2009 
// Design Name: 
// Module Name:    IF 
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
module IF(clk, reset, Z, J, JR, PC_IFWrite, JumpAddr, 
           JrAddr, BranchAddr, Instruction_if,PC, NextPC_if);
    input clk;
    input reset;
    input Z;
    input J;
    input JR;
    input PC_IFWrite;
    input [31:0] JumpAddr;
    input [31:0] JrAddr;
    input [31:0] BranchAddr;
    output [31:0] Instruction_if;
    output [31:0] NextPC_if;
    output [31:0] PC;
// MUX for PC
wire [31:0] PC_in;

mux8 mux8(NextPC_if, BranchAddr, JumpAddr, 0, JrAddr, 0, 0, 0, {JR, J, Z}, PC_in);

//PC REG
dffre #(.WIDTH(32))PC_reg(PC_in, PC_IFWrite, reset, clk, PC);

//Adder for NextPC
adder_32bits adder_32bits(PC, 4, NextPC_if, 0, co);


//ROM
InstructionROM  InstructionROM(
  .addr(PC[7:2]),
  .dout(Instruction_if));

endmodule
