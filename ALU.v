//******************************************************************************
// MIPS verilog model
//
// ALU.v
//
// The ALU performs all the arithmetic/logical integer operations 
// specified by the ALUsel from the decoder. 
// 
// verilog written QMJ
// modified by Xu Guorui(3150104717)
// modified by Xu Guorui(3150104717)
//
//******************************************************************************

module ALU (
  // Outputs
  Result, overflow,
  // Inputs
  ALUCode, A, B
);

  input [4:0]  ALUCode;        // Operation select
  input [31:0]  A, B;

  output reg[31:0]  Result;
  output overflow;

//******************************************************************************
// Shift operation: ">>>" will perform an arithmetic shift, but the operand
// must be reg signed
//******************************************************************************
  reg signed [31:0] B_reg;
  
  always @(B) begin
    B_reg = B;
  end
  
  reg [31:0] ALUResult;
  
  always @(ALUResult) begin
    Result = ALUResult;
  end

  
// Decoded ALU operation select (ALUsel) signals
  parameter alu_add  =  5'b00000;
  parameter alu_and  =  5'b00001;
  parameter alu_xor  =  5'b00010;
  parameter alu_or   =  5'b00011;
  parameter alu_nor  =  5'b00100;
  parameter alu_sub  =  5'b00101;
  parameter alu_andi = 5'b00110;
  parameter alu_xori = 5'b00111;
  parameter alu_ori  = 5'b01000;
  parameter alu_jr   =  5'b01001;
  parameter alu_beq  =  5'b01010;
  parameter alu_bne  =  5'b01011;
  parameter alu_bgez = 5'b01100;
  parameter alu_bgtz = 5'b01101;
  parameter alu_blez = 5'b01110;
  parameter alu_bltz = 5'b01111;
  parameter alu_sll  =  5'b10000;
  parameter alu_srl  =  5'b10001;
  parameter alu_sra  =  5'b10010;  
  parameter alu_slt  =  5'b10011;
  parameter alu_sltu = 5'b10100;
   

//******************************************************************************
// ALU Result datapath
//******************************************************************************


// Add-Sub
wire Binvert, co;
wire[31:0] actB;
wire[31:0] sum;

assign Binvert = ~(ALUCode==alu_add);
assign actB = B^{32{Binvert}};
adder_32bits adder(A, actB, sum, Binvert, co);

// SLT
wire SLTResult;
wire SLTUResult;
assign SLTResult = (A[31]&&(~B[31]))||((A[31]~^B[31])&&sum[31]);
assign SLTUResult = ((~A[31])&&(B[31]))||((A[31]~^B[31])&&sum[31]);

// SRA
wire[31:0] SRAResult;
assign SRAResult = B_reg>>>A;

// AND XOR ...
wire[31:0] ANDResult;
assign ANDResult = A & B;
wire[31:0] XORResult;
assign XORResult = A ^ B;
wire[31:0] ORResult;
assign ORResult  = A | B;
wire[31:0] NORResult;
assign NORResult = ~(A & B);
wire[31:0] ANDIResult;
assign ANDIResult = A & {16'b0, B[15:0]};
wire[31:0] XORIResult;
assign XORIResult = A ^ {16'b0, B[15:0]};
wire[31:0] ORIResult;
assign ORIResult = A | {16'b0, B[15:0]};
wire[31:0] JRResult;
assign JRResult = A;
wire[31:0] SLLResult;
assign SLLResult = B<<A;
wire[31:0] SRLResult;
assign SRLResult = B>>A;

//******************************************************************************
// Overflow
//******************************************************************************

// Overflow

wire sum32, sum33;
assign sum32 = A[31]^actB[31]^co;
assign sum33 = (A[31]&&actB[31])||(co&&(A[31]||actB[31]));
assign overflow = (sum32^sum[31]);

//******************************************************************************
// ALU Result MUX
//******************************************************************************

always @(*)
  begin
    case (ALUCode)
      alu_add:  ALUResult = sum;
      alu_and:  ALUResult = ANDResult;
      alu_xor:  ALUResult = XORResult;
      alu_or :  ALUResult = ORResult;
      alu_nor:  ALUResult = NORResult;
      alu_sub:  ALUResult = sum;
      alu_andi: ALUResult = ANDIResult;
      alu_xori: ALUResult = XORIResult;
      alu_ori:  ALUResult = ORIResult;
      alu_jr:   ALUResult = JRResult; //
      alu_sll:  ALUResult = SLLResult;
      alu_srl:  ALUResult = SRLResult;
      alu_sra:  ALUResult = SRAResult;
      alu_slt:  ALUResult = {15'd0, SLTResult};
      alu_sltu: ALUResult = {15'd0, SLTUResult};
      alu_beq:  ALUResult = 32'b0;
      alu_bne:  ALUResult = 32'b0;
      alu_bgez: ALUResult = 32'b0;
      alu_bgtz: ALUResult = 32'b0;
      alu_blez: ALUResult = 32'b0;
      alu_bltz: ALUResult = 32'b0;
    endcase
  end
  
endmodule