module siso_tb;
reg clk,rst;
reg sin;
wire sout;
siso uut(.clk(clk),.rst(rst),.sin(sin),.sout(sout));
always #6 clk = ~ clk;
initial begin
clk=0;rst=0;sin=0;
#2;
rst=1;
sin=0;#4;
sin=1;#6;
sin=0;#8;
sin=0;#10;
$finish;
end
initial begin
$monitor("clk=%b rst=%b sin=%b sout=%b",clk,rst,sin,sout);
end
endmodule
