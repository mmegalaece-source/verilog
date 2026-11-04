module jk_ff_tb;
reg j,k,clk,rst;
wire q,qbar;
jk_ff uut(.j(j),.k(k),.clk(clk),.rst(rst),.q(q),.qbar(qbar));
always #2 clk=~clk;
initial begin
clk=0;rst=1;
j=0;k=0;#10;
j=0;k=1;#10;
j=1;k=0;#10;
j=1;k=1;#10;
$finish;
end
initial begin
$monitor("j=%b k=%b clk=%b rst=%b q=%b qbar=%b",j,k,clk,rst,q,qbar);
end
endmodule
