module half_subtractor_tb;
reg a,b;
wire d,bo;
half_subtractor uut(.a(a),.b(b),.d(d),.bo(bo));
initial begin
a=0;b=0;#10;
a=0;b=1;#10;
a=1;b=0;#10;
a=1;b=1;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b d=%b bo=%b",a,b,d,bo);
end
endmodule
