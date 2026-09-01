module sipo_tb;
reg clk;
reg rst;
reg sin;
wire [3:0]pout;
sipo uut(.clk(clk),.rst(rst),.sin(sin),.pout(pout));
always #5 clk=~clk;
initial begin
clk=0;
rst=1;
sin=0;#10;
rst=0;
sin=1;#10;
sin=0;#10;
sin=1;#10;
sin=1;#10;
$finish;
end
initial begin
$monitor("clk=%b rst=%b sin=%b pout=%b",clk,rst,sin,pout);
end
endmodule

