module demux_1to4_tb;
reg e,s1,s0;
wire y0,y1,y2,y3;
demux_1to4 uut(.e(e),.s1(s1),.s0(s0),.y0(y0),.y1(y1),.y2(y2),.y3(y3));
initial begin
e=1;s1=0;s0=0;#10;
e=1;s1=0;s0=1;#10;
e=1;s1=1;s0=0;#10;
e=1;s1=1;s0=1;#10;
$finish;
end
initial begin
$monitor("e=%b s1=%b s0=%b y0=%b y1=%b y2=%b y3=%b",e,s0,s1,y0,y1,y2,y3);
end
endmodule
