module mux_2to1_tb;
reg s,do,d1;
wire y;
mux_2to1 uut(.s(s),.do(do),.d1(d1),.y(y));
initial begin
do=1;d1=1;
s=0;#10;
s=1;#10;
end 
initial begin
$monitor("do=%b d1=%b s=%b y=%b",s,do,d1,y);
end 
endmodule
