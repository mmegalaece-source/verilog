module gray_to_binary_tb;
reg[3:0]g;
wire[3:0]b;
gray_to_binary uut(.g(g),.b(b));
initial begin
g=4'b0001;#10;
g=4'b0000;#10;
g=4'b0011;#10;
g=4'b0010;#10;
g=4'b0110;#10;
g=4'b0111;#10;
g=4'b0101;#10;
g=4'b0110;#10;
$finish;
end
initial begin
$monitor("gray=%b binary=%b",g,b);
end
endmodule
