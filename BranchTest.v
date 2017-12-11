//******************************************************************************
// //
// BranchTest.v
//
// - Branch Test

//******************************************************************************

module BranchTest(   
	// Outputs
	Z,
	
	// Inputs
	ALUCode, RsData, RtData
);

	
	input [31:0]	RsData;			// RsData
	input [31:0]	RtData;
	input [4:0]  ALUCode; // ALU operation select
	output reg Z;
	
	
//******************************************************************************
//  ALUCode 
//******************************************************************************//
	
	parameter	 alu_beq=  5'b01010;
  parameter	 alu_bne=  5'b01011;
	parameter	 alu_bgez= 5'b01100;
  parameter	 alu_bgtz= 5'b01101;
  parameter	 alu_blez= 5'b01110;
  parameter	 alu_bltz= 5'b01111;
  
  always @(*)
  begin
    case (ALUCode)
      alu_beq:  Z = &(RsData[31:0]~^RtData[31:0]);
      alu_bne:  Z = |(RsData[31:0]^RtData[31:0]);
      alu_bgez: Z = ~RsData[31];
      alu_bgtz: Z = ~RsData[31] && (|RsData[31:0]);
      alu_bltz: Z = RsData[31];
      alu_blez: Z = RsData[31] || ~(|RsData[31:0]);
      default:  Z = 0;
    endcase
  end
		

endmodule