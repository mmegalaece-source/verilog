module mealy_111_tb;
reg clk;
reg reset;
reg in;
wire y;
mealy_111 uut(.clk(clk),.reset(reset),.in(in),.y(y));
always #5 clk=~clk;
initial begin
clk=0;
reset=1;
in=0;
#10;
reset=0;
in=1;
#10;
in=1;
#10;
in=1;
#10;
$finish;
end
initial begin
$dumpfile("mealy_111.vcd");
$dumpvars(0,mealy_111_tb);
end
initial begin
$monitor("clk=%b reset=%b in=%b y=%b",clk,reset,in,y);
end
endmodule
