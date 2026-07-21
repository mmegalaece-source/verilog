module comparator_4bit_tb;
reg x,y;
wire a_g_b,a_l_b,a_e_b;
comparator_4bit uut(.*);
initial begin
x=5;y=3;#5;
x=7;y=7;#5;
x=6;y=9;#5;
$finish;
end
initial begin
$monitor("x=%b y=%b a_g_b=%b a_l_b=%b a_e_b=%b",x,y,a_g_b,a_l_b,a_e_b);
end
endmodule
