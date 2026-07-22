module maximum_value_tb;
reg [3:0]a,b;
wire [3:0]max;
maximum_value uut(.a(a),.b(b),.max(max));
initial begin
a=0;b=1;#10;
a=1;b=0;#10;
a=1;b=0;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b y=%b",a,b,max);
end
endmodule
