module pipo_tb;
reg clk;
reg rst;
reg [3:0]pin;
wire [3:0]pout;
pipo uut(.clk(clk),.rst(rst),.pin(pin),.pout(pout));
always #5 clk=~clk;
initial begin
clk=0;
rst=1;
pin=4'd0;
#10;
rst=0;
pin=4'd2;#10;
pin=4'd3;#10;
pin=4'd4;#10;
pin=4'd5;#10;
$finish;
end
initial begin
$monitor("clk=%b rst=%b pin=%b pout=%b",clk,rst,pin,pout);
end
endmodule
