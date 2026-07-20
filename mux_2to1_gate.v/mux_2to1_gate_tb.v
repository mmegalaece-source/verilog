module mux_2to1_gate_tb;
reg d0,d1,s;
wire f;
mux_2to1_gate uut(.d0(d0),.d1(d1),.s(s),.f(f));
initial begin
d0=0;d1=0;s=0;#10;
d0=0;d1=0;s=1;#10;
d0=0;d1=1;s=0;#10;
d0=0;d1=1;s=1;#10;
d0=1;d1=0;s=0;#10;
d0=1;d1=0;s=1;#10;
d0=1;d1=1;s=0;#10;
d0=1;d1=1;s=1;#10;
$finish;
end
initial begin
$monitor("d0=%b d1=%b s=%b f=%b",d0,d1,s,f);
end
endmodule
