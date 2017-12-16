//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:27 12/11/2017 
// Design Name: 
// Module Name:    mux8
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
module mux8(A, B, C, D, E, F, G, H, sel, out);
  input [31:0]A;
  input [31:0]B;
  input [31:0]C;
  input [31:0]D;
  input [31:0]E;
  input [31:0]F;
  input [31:0]G;
  input [31:0]H;
  input [2:0] sel;
  output reg[31:0] out;
  
  always @(*)
    begin
      case(sel)
        3'b000: out = A;
        3'b001: out = B;
        3'b010: out = C;
        3'b011: out = D;
        3'b100: out = E;
        3'b101: out = F;
        3'b110: out = G;
        3'b111: out = H;
      endcase
    end
endmodule
