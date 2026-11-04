module decoder_1to8_tb;
reg a,b,c,e;
wire y0,y1,y2,y3,y4,y5,y6,y7;
decoder_1to8 uut(.a(a),.b(b),.c(c),.e(e),.y0(y0),.y1(y1),.y2(y2),.y3(y3),.y4(y4),.y5(y5),.y6(y6),.y7(y7));
initial begin
e=0;a=0;b=0;c=0;#10;
e=1;a=0;b=0;c=1;#10;
e=1;a=0;b=1;c=0;#10;
e=1;a=0;b=1;c=1;#10;
e=1;a=1;b=0;c=0;#10;
e=1;a=1;b=0;c=1;#10;
e=1;a=1;b=1;c=0;#10;
e=1;a=1;b=1;c=1;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b c=%b e=%b y0=%b y1=%b y2=%b y3=%b y4=%b y5=%b y6=%b y7=%b",a,b,c,e,y0,y1,y2,y3,y4,y5,y6,y7);
end 
endmodule
