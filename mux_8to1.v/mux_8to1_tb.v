module mux_8to1_tb;
reg [2:0]s;
reg [7:0]d;
wire y;
mux_8to1 uut(.s(s),.d(d),.y(y));
initial begin
d=8'b10101010;
s=3'b000;#10;
s=3'b001;#10;
s=3'b010;#10;
s=3'b011;#10;
s=3'b100;#10;
s=3'b101;#10;
s=3'b110;#10;
s=3'b111;#10;
$finish;
end
initial begin
$monitor("s=%b d=%b y=%b",s,d,y);
end
endmodule
