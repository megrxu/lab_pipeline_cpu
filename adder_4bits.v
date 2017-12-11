module adder_4bits(a, b, s, ci, co);
input [3:0] a;
input [3:0] b;
input ci;
output [3:0] s;
output co;
integer i;
reg [3:0] s;
reg [4:0] c;

assign co=c[4];
always @(a or b or ci) begin
  c[0]=ci;
  for (i=0;i<=3;i=i+1)
    begin 
      s[i]= ((~(a[i] && b[i])) && (a[i] || b[i])) ^ c[i];
      c[i+1]=(a[i] && b[i]) || ((a[i] || b[i]) && c[i]);
    end
end

endmodule // adder_4bits