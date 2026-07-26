module moore_seq_tb;
reg clk;
reg rst;
reg x;
wire y;
moore_seq dut(.clk(clk),.rst(rst),.x(x),.y(y));
always #5 clk = ~clk;
initial begin
clk=0;
rst=1;
x=0;
#10;
rst=0;
#10 x=1;
#10 x=0;
#10 x=1;
#10 x=0;
//overlapping
#10 x=1;
#10 x=0;
#10 x=1;
#10 x=0;
#20;
$finish;
end
initial begin
$monitor("time=%0t,clk=%b rst=%b x=%b y=%b",$time,clk,rst,x,y);
end
endmodule
