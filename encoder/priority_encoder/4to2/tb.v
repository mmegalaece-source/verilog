module priorty_encoder_4to2_tb;
reg d0,d1,d2,d3;
wire a1,b1,v;
priorty_encoder_4to2 uut(.d0(d0),.d1(d1),.d2(d2),.d3(d3),.a1(a1),.b1(b1));
initial begin
d0=0;d1=0;d2=0;d3=0;#10;
d0=0;d1=0;d2=0;d3=1;#10;
d0=0;d1=0;d2=1;d3=0;#10;
d0=0;d1=0;d2=1;d3=1;#10;
d0=0;d1=1;d2=0;d3=0;#10;
d0=0;d1=1;d2=1;d3=1;#10;
d0=1;d1=0;d2=0;d3=0;#10;
d0=1;d1=1;d2=1;d3=1;#10;
$finish;
end
initial begin
$monitor("a1=%b b1=%b d0=%b d1=%b d2=%b d3=%b",a1,b1,d0,d1,d2,d3);
end
endmodule
