module mux_2to1_gate(input d0,d1,s,output f);
wire x,y,z;
not (y,s);
and g1(x,d0,y);
and g2(z,d1,s);
or (f,x,z);
endmodule
