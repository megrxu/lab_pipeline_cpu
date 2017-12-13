//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:27 12/11/2017 
// Design Name: 
// Module Name:    mux4 
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
module mux4(A, B, C, D, sel, out);
  input [31:0]A;
  input [31:0]B;
  input [31:0]C;
  input [31:0]D;
  input [1:0] sel;
  output reg[31:0] out;
  
  always @(*)
    begin
      case(sel)
        2'b00: out = A;
        2'b01: out = B;
        2'b10: out = C;
        2'b11: out = D;
      endcase
    end
endmodule
