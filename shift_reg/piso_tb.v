module piso_tb;
reg clk;
reg rst;
reg load;
reg [3:0]pin;
wire pout;
piso uut(.clk(clk),.rst(rst),.load(load),.pin(pin),.pout(pout));
always #5 clk=~clk;
initial begin
clk=0;
rst=1;
load=0;
pin=4'd0;
#10;
rst=0;
load=1;
#10;
pin=4'd3;#10;
pin=4'd4;#10;
load=0;
pin=4'd5;#10;
pin=4'd6;#10;
$finish;
end
initial begin
$monitor("clk=%d rst=%d pin=%d load=%d pout=%b",clk,rst,pin,load,pout);
end
endmodule
