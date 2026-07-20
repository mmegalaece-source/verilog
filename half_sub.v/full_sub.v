module full_sub(input a,b,bin,output diff,bout);
wire d1,b1,b2;
half_sub ha1(.a(a),.b(b),.diff(d1),.bout(b1));
half_sub ha2(.a(a),.b(bin),.diff(diff),.bout(b2));
assign bout=b1|b2;
endmodule
