module siso_tb;
reg clk;
reg rst;
reg sin;
wire sout;
siso uut(.clk(clk),.rst(rst),.sin(sin),.sout(sout));
always #5 clk=~clk;
initial begin
clk=0;
rst=1;
sin=0;
#10;
rst=0;
sin=1;
#10;
sin=0;#10;
sin=1;#10;
sin=0;#10;
$finish;
end
initial begin
$monitor("clk=%b rst=%b sin=%b sout=%b",clk,rst,sin,sout);
end
endmodule
