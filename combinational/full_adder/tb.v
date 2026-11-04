module fulladder_tb;
reg a,b,c;
wire s1,c1;
fulladder uut(.a(a),.b(b),.c(c),.sum(s1),.carry(c1));
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
$monitor("a=%b,b=%b,c=%b,s1=%b,c1=%b",a,b,c,s1,c1);
end 
endmodule
