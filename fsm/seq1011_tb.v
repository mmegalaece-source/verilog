module seq1011_tb;
reg clk;
reg reset;
reg x;
wire y;
seq1011 uut(.clk(clk),.reset(reset),.x(x),.y(y));
always #5 clk=~clk;
initial begin
clk=0;reset=1;
x=0;
#10; reset=0;
x=1;
#10;
x=0;
#10;
x=1;
#10;
x=1;
#20;
$finish;
end
initial begin
$monitor("time=%0t clk=%b reset=%b x=%b y=%b",$time,clk,reset,x,y);
end
endmodule
