`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ZJU
// Engineer: 
// 
// Create Date:    19:44:48 11/12/2009 
// Design Name: 
// Module Name:    MipsPipelineCPU 
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
module MipsPipelineCPU(clk, reset, JumpFlag, Instruction_id, ALU_A, 
                     ALU_B, ALUResult, PC, MemDout_wb,Stall
            //  ,DataTest,ControlTest
              );
    input clk;
    input reset;
    output[2:0] JumpFlag;
    output [31:0] Instruction_id;
    output [31:0] ALU_A;
    output [31:0] ALU_B;
    output [31:0] ALUResult;
    output [31:0] PC;
    output [31:0] MemDout_wb;
    output Stall;
//  output[31:0] DataTest;
//  output    ControlTest;
   
//IF  module
   wire[31:0] Instruction_id;
   wire PC_IFWrite,J,JR,Z,IF_flush;
   wire[31:0] JumpAddr, JrAddr, BranchAddr, NextPC_if, Instruction_if;
   assign JumpFlag={JR,J,Z};
   assign IF_flush=Z || J ||JR;
  
  IF IF(
//input  
   .clk(clk), 
   .reset(reset), 
   .Z(Z), 
   .J(J), 
   .JR(JR), 
   .PC_IFWrite(PC_IFWrite), 
   .JumpAddr(JumpAddr), 
   .JrAddr(JrAddr), 
   .BranchAddr(BranchAddr), 
//  output
   .Instruction_if(Instruction_if),
   .PC(PC),
   .NextPC_if(NextPC_if));
 
//   IF->ID Register
wire IF_reg1;
wire ID_reg1;
wire [31:0] NextPC_id;
assign IF_reg1 = {NextPC_if, Instruction_if};
assign ID_reg1 = {NextPC_id, Instruction_id};

dffre #( .WIDTH(64)) IF_ID({NextPC_if, Instruction_if} , PC_IFWrite, IF_flush||reset, clk, {NextPC_id, Instruction_id});

//  ID Module  
    wire[4:0] RtAddr_id,RdAddr_id,RsAddr_id;
    wire  RegWrite_wb,MemRead_ex,MemtoReg_id,RegWrite_id,MemWrite_id;
    wire  MemRead_id,ALUSrcA_id,ALUSrcB_id,RegDst_id, Stall;
    wire[4:0]  RegWriteAddr_wb,RegWriteAddr_ex,ALUCode_id;
    wire[31:0] RegWriteData_wb,Imm_id,Sa_id,RsData_id,RtData_id;
    ID  ID (
         .clk(clk),
    .Instruction_id(Instruction_id), 
    .NextPC_id(NextPC_id), 
    .RegWrite_wb(RegWrite_wb), 
    .RegWriteAddr_wb(RegWriteAddr_wb), 
    .RegWriteData_wb(RegWriteData_wb), 
    .MemRead_ex(MemRead_ex), 
              .RegWriteAddr_ex(RegWriteAddr_ex), 
    .MemtoReg_id(MemtoReg_id), 
    .RegWrite_id(RegWrite_id), 
    .MemWrite_id(MemWrite_id), 
    .MemRead_id(MemRead_id), 
    .ALUCode_id(ALUCode_id), 
    .ALUSrcA_id(ALUSrcA_id), 
    .ALUSrcB_id(ALUSrcB_id), 
    .RegDst_id(RegDst_id), 
    .Stall(Stall), 
    .Z(Z), 
    .J(J), 
    .JR(JR), 
    .PC_IFWrite(PC_IFWrite),  
    .BranchAddr(BranchAddr), 
    .JumpAddr(JumpAddr),
    .JrAddr(JrAddr),
    .Imm_id(Imm_id), 
    .Sa_id(Sa_id), 
    .RsData_id(RsData_id), 
    .RtData_id(RtData_id),
    .RtAddr_id(RtAddr_id),
    .RdAddr_id(RdAddr_id),
    .RsAddr_id(RsAddr_id));

//   ID->EX  Register

wire ID_reg2;
wire EX_reg2;
wire MemWrite_ex;
wire RegWrite_ex;
wire MemtoReg_ex, ALUSrcA_ex, ALUSrcB_ex;
wire [4:0] ALUCode_ex, RdAddr_ex, RtAddr_ex, RsAddr_ex;
wire [31:0] Imm_ex, Sa_ex, RsData_ex, RtData_ex, ALU_result_ex;
wire RegDst_ex;
assign ID_reg2 = {ALUCode_id, ALUSrcA_id, ALUSrcB_id, RegDst_id, MemRead_id, MemWrite_id, RegWrite_id, MemtoReg_id, Imm_id, Sa_id, RdAddr_id, RsAddr_id, RtAddr_id, RsData_id, RtData_id};
assign EX_reg2 = {ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex, RegDst_ex, MemRead_ex, MemWrite_ex, RegWrite_ex, MemtoReg_ex, Imm_ex, Sa_ex, RdAddr_ex, RsAddr_ex, RtAddr_ex, RsData_ex, RtData_ex};

dffre #( .WIDTH(155)) ID_EX({ALUCode_id, ALUSrcA_id, ALUSrcB_id, RegDst_id, MemRead_id, MemWrite_id, RegWrite_id, MemtoReg_id, Imm_id, Sa_id, RdAddr_id, RsAddr_id, RtAddr_id, RsData_id, RtData_id}, 1, reset||Stall, clk, {ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex, RegDst_ex, MemRead_ex, MemWrite_ex, RegWrite_ex, MemtoReg_ex, Imm_ex, Sa_ex, RdAddr_ex, RsAddr_ex, RtAddr_ex, RsData_ex, RtData_ex});

// EX Module
 wire[31:0] ALUResult_mem,ALUResult_ex,MemWriteData_ex;
 wire[4:0] RegWriteAddr_mem;
 wire RegWrite_mem;
 EX  EX(
 .RegDst_ex(RegDst_ex), 
 .ALUCode_ex(ALUCode_ex), 
 .ALUSrcA_ex(ALUSrcA_ex), 
 .ALUSrcB_ex(ALUSrcB_ex), 
 .Imm_ex(Imm_ex), 
 .Sa_ex(Sa_ex), 
 .RsAddr_ex(RsAddr_ex), 
 .RtAddr_ex(RtAddr_ex), 
 .RdAddr_ex(RdAddr_ex),
 .RsData_ex(RsData_ex), 
 .RtData_ex(RtData_ex), 
 .RegWriteData_wb(RegWriteData_wb), 
 .ALUResult_mem(ALUResult_mem), 
 .RegWriteAddr_wb(RegWriteAddr_wb), 
 .RegWriteAddr_mem(RegWriteAddr_mem), 
 .RegWrite_wb(RegWrite_wb), 
 .RegWrite_mem(RegWrite_mem), 
 .RegWriteAddr_ex(RegWriteAddr_ex), 
 .ALUResult_ex(ALUResult_ex), 
 .MemWriteData_ex(MemWriteData_ex), 
 .ALU_A(ALU_A),
 .ALU_B(ALU_B));

assign ALUResult=ALUResult_ex;

//EX->MEM

wire EX_reg3;
wire MEM_reg3;
wire MemtoReg_mem;
wire MemWrite_mem;
wire [31:0]MemWriteData_mem;

assign EX_reg3 = {MemWrite_ex, RegWrite_ex, MemtoReg_ex, ALUResult_ex, MemWriteData_ex, RegWriteAddr_ex};
assign MEM_reg3 = {MemWrite_mem, RegWrite_mem, MemtoReg_mem, ALUResult_mem, MemWriteData_mem, RegWriteAddr_mem};

dffre #( .WIDTH(72)) EX_MEM({MemWrite_ex, RegWrite_ex, MemtoReg_ex, ALUResult_ex, MemWriteData_ex, RegWriteAddr_ex}, 1, reset, clk, {MemWrite_mem, RegWrite_mem, MemtoReg_mem, ALUResult_mem, MemWriteData_mem, RegWriteAddr_mem});

//MEM Module
  DataRAM DataRAM(
  .addr(ALUResult_mem[7:2]),
  .clk(clk),
  .din(MemWriteData_mem),
  .dout(MemDout_wb),
  .we(MemWrite_mem));

//MEM->WB

wire MEM_reg4;
wire WB_reg4;
wire MemToReg_wb;
wire [31:0] ALUResult_wb;

assign MEM_reg4 = {RegWrite_mem, MemtoReg_mem, ALUResult_mem, RegWriteAddr_mem};
assign WB_reg4 = {RegWrite_wb, MemToReg_wb, ALUResult_wb, RegWriteAddr_wb};

dffre #( .WIDTH(39)) MEM_WB({RegWrite_mem, MemtoReg_mem, ALUResult_mem, RegWriteAddr_mem}, 1, reset, clk, {RegWrite_wb, MemToReg_wb, ALUResult_wb, RegWriteAddr_wb});

//WB
  assign RegWriteData_wb=MemToReg_wb?MemDout_wb:ALUResult_wb;

endmodule
