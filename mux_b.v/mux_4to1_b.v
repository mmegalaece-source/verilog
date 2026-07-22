module mux_4to1_b(
input i0,i1,i2,i3,
input [1:0]s,
output reg y
);
always@(*) begin
if(s==2'b00)
y=i0;
else if(s==2'b01)
y=i1;
else if(s==2'b10)
y=i2;
else
y=i3;
end
endmodule
