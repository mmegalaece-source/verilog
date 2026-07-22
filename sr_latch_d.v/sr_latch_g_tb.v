module sr_latch_g_tb;
reg s,r;
wire q,qbar;
sr_latch_g uut(.s(s),.r(r),.q(q),.qbar(qbar));
initial begin
s=0;r=0;#10;
s=0;r=1;#10;
s=1;r=0;#10;
s=1;r=1;#10;
$finish;
end
initial begin
$monitor("s=%b r=%b q=%b qbar=%b",s,r,q,qbar);
end
endmodule
