module full_subtractor(
    input a,
    input b,
    input c,
    output d,
    output bo
);
assign d = a ^ b ^ c; 
assign bo = (~a & b)|(~a & c)|(b & c);
endmodule

