module decoder_2to4_tb;
reg a,b;
wire yo,y1,y2,y3;
decoder_2to4 uut(.a(a),.b(b),.yo(yo),.y1(y1),.y2(y2),.y3(y3));
initial begin 
a=0;b=0;#10;
a=0;b=1;#10;
a=1;b=0;#10;
a=1;b=1;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b yo=%b y1=%b y2=%b y3=%b",a,b,yo,y1,y2,y3);
end
endmodule

