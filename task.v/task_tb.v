module alu_tb;
reg [2:0]a;
reg [2:0]b;
wire [3:0]add;
wire [3:0]sub;
wire [3:0]multi;
wire [3:0]div;
alu uut(.a(a),.b(b),.add(add),.sub(sub),.multi(multi),.div(div));
initial begin
a=0;b=0;#10;
a=0;b=1;#10;
a=1;b=0;#10;
a=1;b=1;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b add=%b sub=%b multi=%b div=%b",a,b,add,sub,multi,div);
end
endmodule
