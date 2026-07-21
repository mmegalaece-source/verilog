module alu_condition_tb;
reg [3:0]a;
reg [3:0]b;
reg [2:0]sel;
wire [3:0]y;
alu_condition uut(.a(a),.b(b),.sel(sel),.y(y));
initial begin
a=4'b1101;
b=4'b1110;
sel=3'b000;#10;
sel=3'b001;#10;
sel=3'b010;#10;
sel=3'b100;#10;
sel=3'b101;#10;
sel=3'b110;#10;
sel=3'b111;#10;
$finish;
end
initial begin
$monitor("time=%0t,a=%b b=%b sel=%b y=%b",$time,a,b,sel,y);
end
endmodule
