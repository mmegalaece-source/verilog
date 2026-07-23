module mux_8to1_tb;
reg [7:0]d;
reg [2:0]sel;
wire y;
mux_8to1 uut(.d(d),.sel(sel),.y(y));
integer i;
initial begin
d=8'b10101010;
for(i=0;i<8;i=i+1);
begin
sel=i;#10;
end
$finish;
end
initial begin
$monitor("d=%b sel=%b y=%b",d,sel,y);
end
endmodule

