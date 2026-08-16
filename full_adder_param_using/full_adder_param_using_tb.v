module full_adder_tb;
reg [7:0]a;
reg [7:0]b;
reg cin;
wire [7:0]sum;
wire cout;
full_adder #(.N(8)) dut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
initial begin
a=8'b00000001;b=8'b00101000;cin=0;#10;
a=8'b11001010;b=8'b00100100;cin=0;#10;
a=8'b00001001;b=8'b00001001;cin=1;#10;
a=8'b00001011;b=8'b00011001;cin=0;#10;
a=8'b11010100;b=8'b01001000;cin=0;#10;
$finish;
end
initial begin
$monitor("a=%b b=%b cin=%b sum=%b cout=%b",a,b,cin,sum,cout);
end
endmodule

