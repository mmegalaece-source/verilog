module priority_encoder8to3_tb;
wire [2:0]y;
reg [7:0]d;
priority_encoder8to3 uut(.y(y),.d(d));
initial begin
d=0;
d=8'b00000001;#10;
d=8'b00000010;#10;
d=8'b00000100;#10;
d=8'b00001000;#10;
d=8'b00010000;#10;
d=8'b00100000;#10;
d=8'b01000000;#10;
d=8'b10000000;#10;
$finish;
end
initial begin
$monitor("y=%b d=%b",y,d);
end
endmodule
