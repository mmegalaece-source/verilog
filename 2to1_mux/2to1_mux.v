module mux_2to1(input s,do,d1,output y);
assign y=(~s&do)|(s&d1);
endmodule
