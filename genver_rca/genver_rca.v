module fulladder(input a,
input b,
input cin,
output sum,
output cout);
assign sum=a^b^cin;
assign cout=(a^b)|(b^cin)|(a^cin);
endmodule
module rca(input[3:0]a,
input[3:0]b,
input cin,
output[3:0]sum,
output cout);
wire [4:0]carry;
assign carry[0]=cin;
genvar i;
generate
for(i=0;i<4;i=i+1)begin
fulladder fa(.a(a[i]),
.b(b[i]),
.cin(carry[i]),
.sum(sum[i]),
.cout(carry[i+1]));
end
endgenerate
assign cout=carry[4];
endmodule


