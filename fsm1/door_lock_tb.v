module door_lock_tb;
reg clk;
reg reset;
reg in;
reg close;
wire unlock;
door_lock uut(.clk(clk),.reset(reset),.in(in),.close(close),.unlock(unlock));
always #5 clk=~clk;
initial begin
clk=0;
reset=1;
in=0;
close=0;
#10;
reset=0;
in=1;
#10;
in=0;
#10;
in=1;
#10;
in=1;
#10;
close=1;
#10;
close=0;
#20;
$finish;
end
initial begin
$monitor("time=%0t clk=%b reset=%b in=%b close=%b unlock=%b",$time,clk,reset,in,close,unlock);
end
endmodule
