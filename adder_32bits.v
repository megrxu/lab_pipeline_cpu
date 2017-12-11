module adder_32bits(a, b, s, ci, co);
input [31:0] a;
input [31:0] b;
input ci;
output [31:0] s;
output co;
wire [31:0] s0;
wire [31:0] s1;

wire co01, co02, co03, co04, co05, co06, co07;
wire co11, co12, co13, co14, co15, co16, co17;
wire co1, co2, co3, co4, co5, co6, co7;

// Low 4 bits
adder_4bits adder_4bits_00_0(a[3:0], b[3:0], s[3:0], ci, co0);

// ci = 0
adder_4bits adder_4bits_01_0(a[7:4], b[7:4], s0[7:4], 0, co01);
adder_4bits adder_4bits_02_0(a[11:8], b[11:8], s0[11:8], 0, co02);
adder_4bits adder_4bits_03_0(a[15:12], b[15:12], s0[15:12], 0, co03);
adder_4bits adder_4bits_04_0(a[19:16], b[19:16], s0[19:16], 0, co04);
adder_4bits adder_4bits_05_0(a[23:20], b[23:20], s0[23:20], 0, co05);
adder_4bits adder_4bits_06_0(a[27:24], b[27:24], s0[27:24], 0, co06);
adder_4bits adder_4bits_07_0(a[31:28], b[31:28], s0[31:28], 0, co07);

// ci = 1
adder_4bits adder_4bits_01_1(a[7:4], b[7:4], s1[7:4], 1, co11);
adder_4bits adder_4bits_02_1(a[11:8], b[11:8], s1[11:8], 1, co12);
adder_4bits adder_4bits_03_1(a[15:12], b[15:12], s1[15:12], 1, co13);
adder_4bits adder_4bits_04_1(a[19:16], b[19:16], s1[19:16], 1, co14);
adder_4bits adder_4bits_05_1(a[23:20], b[23:20], s1[23:20], 1, co15);
adder_4bits adder_4bits_06_1(a[27:24], b[27:24], s1[27:24], 1, co16);
adder_4bits adder_4bits_07_1(a[31:28], b[31:28], s1[31:28], 1, co17);

//sel co
assign co1 = co01 || (co11 && co0);
assign co2 = co02 || (co12 && co1);
assign co3 = co03 || (co13 && co2);
assign co4 = co04 || (co14 && co3);
assign co5 = co05 || (co15 && co4);
assign co6 = co06 || (co16 && co5);
assign co = co07 || (co17 && co6);

//mux
mux_4bits mux_4bits_1(s0[7:4], s1[7:4], co0, s[7:4]);
mux_4bits mux_4bits_2(s0[11:8], s1[11:8], co1, s[11:8]);
mux_4bits mux_4bits_3(s0[15:12], s1[15:12], co2, s[15:12]);
mux_4bits mux_4bits_4(s0[19:16], s1[19:16], co3, s[19:16]);
mux_4bits mux_4bits_5(s0[23:20], s1[23:20], co4, s[23:20]);
mux_4bits mux_4bits_6(s0[27:24], s1[27:24], co5, s[27:24]);
mux_4bits mux_4bits_7(s0[31:28], s1[31:28], co6, s[31:28]);

endmodule // adder_32bits(a, b, ci, s, co)
