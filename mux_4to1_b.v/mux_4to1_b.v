module mux_4to1_b(
input i0,i1,i2,i3,
input [1:0]s,
output reg y
);
always@(*) begin
if
	(s==2'b00) begin
y=i0;
end

else if(s==2'b01) begin 
y=i1;
end
else if(s==2'b10) begin
y=i2;
end
else begin
y=i3;
end
end
endmodule
