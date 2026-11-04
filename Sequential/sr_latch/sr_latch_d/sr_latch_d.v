module sr_latch_d(input s,r,output q,qbar);
assign q=~(r|qbar);
assign qbar=~(q|s);
endmodule
