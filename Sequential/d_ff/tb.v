module d_ff_tb;
reg d,clk,rst;
wire q,qbar;
d_ff uut(.d(d),.clk(clk),.rst(rst),.q(q),.qbar(qbar));
always #2 clk=~clk;
initial begin
clk=0;rst=1;#2
d=0;#10;
d=1;#10;
d=0;#10;
d=1;#10;
$finish;
end
initial begin
$monitor("d=%b clk=%b rst=%b q=%b qbar=%b",d,clk,rst,q,qbar);
end
endmodule
