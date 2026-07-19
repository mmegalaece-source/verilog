module decoder_1to8(input a,b,c,e,output y0,y1,y2,y3,y4,y5,y6,y7);
assign y0=~a & ~b & ~c;
assign y1=~a & ~b & c & e;
assign y2=~a & b & ~c & e;
assign y3=~a & b & c & e;
assign y4=a & ~b & ~c & e;
assign y5=a & ~b & c & e;
assign y6=a & b & ~c & e;
assign y7=a & b & c & e;
endmodule
