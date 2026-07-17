module full_subtractor_tb;
reg a, b, c;
wire d, bo;
full_subtractor uut(
	.a(a),
	.b(b),
	.c(c),
	.d(d),
	.bo(bo)
);
initial begin
a=0;b=0;c=0;#10;
a=0;b=0;c=1;#10;
a=0;b=1;c=0;#10;
a=0;b=1;c=1;#10;
a=1;b=0;c=0;#10;
a=1;b=0;c=1;#10;
a=1;b=1;c=0;#10;
a=1;b=1;c=1;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b c=%b d=%b bo=%b",a, b, c, d, bo);
end
endmodule
