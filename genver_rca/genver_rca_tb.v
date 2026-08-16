module rca_tb;
reg [3:0]a;
reg [3:0]b;
reg cin;
wire [3:0]sum;
wire cout;
rca uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
initial begin
a=4'b0000;b=4'b0000;cin=0;#10;
a=4'b0011;b=4'b0101;cin=1;#10;
a=4'b0110;b=4'b0001;cin=1;#10;
a=4'b0111;b=4'b0111;cin=0;#10;
a=4'b1111;b=4'b1111;cin=0;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b cin=%b sum=%b cout=%b",a,b,cin,sum,cout);
end
endmodule



