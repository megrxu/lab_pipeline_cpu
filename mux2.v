`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:52 12/11/2017 
// Design Name: 
// Module Name:    mux2 
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
module mux2(A, B, sel, out);
  parameter N = 31;
  input [N:0]A;
  input [N:0]B;
  input sel;
  output reg[N:0] out;
  
  always @(*)
    begin
      case(sel)
        0: out = A;
        1: out = B;
      endcase
    end
endmodule
