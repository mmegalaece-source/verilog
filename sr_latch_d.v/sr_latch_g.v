module sr_latch_g(input s,r,output q,qbar);
nor n1(q,r,qbar);
nor n2(qbar,q,s);
endmodule
