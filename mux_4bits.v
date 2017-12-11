module mux_4bits(in0, in1, sel, out);
parameter N = 3;
input [N:0] in0;
input [N:0] in1;
input sel;
output reg [N:0] out;

always @(*) begin
  case (sel)
      0 : out = in0;
      1 : out = in1;
  endcase
end

endmodule // adder_4bits