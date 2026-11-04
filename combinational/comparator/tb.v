module tb_comparator;
reg A,B;
wire A_greater,A_equal,A_less;
comparator uut(
    .A(A),
    .B(B),
    .A_greater(A_greater),
    .A_equal(A_equal),
    .A_less(A_less)
);
initial begin
A=0; B=0;#10;
A=0; B=1;#10;
A=1; B=0;#10;
A=1; B=1;#10;
$finish;
end
initial
$monitor("A=%b B=%b Greater=%b Equal=%b Less=%b",A,B,A_greater,A_equal,A_less);
endmodule
