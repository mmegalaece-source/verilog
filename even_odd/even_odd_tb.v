module even_odd_tb;
reg [3:0]a;
wire y;
even_odd uut(.a(a),.y(y));
initial begin
a=4'b0001;#10;
a=4'b1001;#10;
a=4'b1010;#10;
a=4'b1110;#10;
$finish;
end
initial begin
$monitor("a=%b y=%b",a,y);
end
endmodule
