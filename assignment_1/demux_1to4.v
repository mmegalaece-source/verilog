module demux_1to4(input s1,s0,e,output y0,y1,y2,y3);
assign y0=e & ~s1 & ~s0;
assign y1=e & ~s1 & s0;
assign y2=e & s1 & ~s0;
assign y3=e & s1 & s0;
endmodule 
