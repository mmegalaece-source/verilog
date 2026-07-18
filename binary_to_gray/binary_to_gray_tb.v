module binary_to_gray_tb;
reg [3:0]b;
wire[3:0]g;
binary_to_gray uut(.g(g),.b(b));
initial begin
b=4'b0000;#10;
b=4'b0001;#10;
b=4'b0011;#10;
b=4'b0010;#10;
b=4'b0111;#10;
b=4'b0110;#10;
b=4'b0101;#10;
$finish;
end
initial begin
$monitor("gray=%b binary=%b",b,g);
end
endmodule
