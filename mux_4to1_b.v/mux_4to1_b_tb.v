module mux_4to1_b_tb;
reg i0,i1,i2,i3;
reg [1:0]s;
wire y;
mux_4to1_b dut(.i0(i0),.i1(i1),.i3(i3),.s(s),.y(y));
initial begin
i0=0;i1=1;i2=0;i3=1;
s=2'b00;#10;
$display("i0=%b i1=%b i2=%b i3=%b s=%b y=%b",i0,i1,i2,i3,s,y);
s=2'b01;#10;
$display("i0=%b i1=%b i2=%b i3=%b s=%b y=%b",i0,i1,i2,i3,s,y);
s=2'b10;#10;
$display("i0=%b i1=%b i2=%b i3=%b s=%b y=%b",i0,i1,i2,i3,s,y);
s=2'b11;#10;
$display("i0=%b i1=%b i2=%b i3=%b s=%b y=%b",i0,i1,i2,i3,s,y);
$finish;

end
endmodule

