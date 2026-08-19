module moore_10110_tb;
reg clk;
reg reset;
reg din;
wire y;
moore_10110 uut(.clk(clk),.reset(reset),.din(din),.y(y));
always #5 clk=~clk;
initial begin
clk=0;
reset=1;
din=0;
#10;
reset=0;
din=1;
#10;
din=0;
#10;
din=1;
#10;
din=1;
#10;
din=0;
#10;
$finish;
end
initial begin
    $dumpfile("moore_10110.vcd");
    $dumpvars;
end
initial begin
$monitor("clk=%b reset=%b din=%b y=%b",clk,reset,din,y);
end
endmodule
