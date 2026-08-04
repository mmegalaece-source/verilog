module traffic_light_tb;
reg clk;
reg reset;
wire [1:0]light;
traffic_light uut(.clk(clk),.reset(reset),.light(light));
always #10 clk=~clk;
initial begin
clk=0;
reset=1;
#10;
reset=1;
#60;
reset=0;
#30;
reset=1;
#10;
$finish;
end
initial begin
$monitor("time=%0t clk=%b reset=%b light=%b",$time,clk,reset,light);
end
endmodule

