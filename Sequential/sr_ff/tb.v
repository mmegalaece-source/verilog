module sr_ff_tb;
reg s,r,clk,rst;
wire q,qbar;
sr_ff uut(.s(s),.r(r),.clk(clk),.rst(rst),.q(q),.qbar(qbar));
always #2 clk=~clk;
initial begin
	clk=0;rst=1;
s=0;r=0;#10;
s=0;r=1;#10;
s=1;r=0;#10;
s=1;r=1;#10;
$finish;
end
initial begin
$monitor("s=%b r=%b clk=%b rst=%b q=%b qbar=%b",s,r,clk,rst,q,qbar);
end
endmodule
