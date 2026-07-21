module comparator_4bit(
input x,y,
output reg a_g_b,a_e_b,a_l_b
);
always@(*)begin
a_g_b=0;
a_l_b=0;
a_e_b=0;
if(x>y)
a_g_b=1;
else if(x==y)
a_e_b=1;
else
a_l_b=1;
end
endmodule
