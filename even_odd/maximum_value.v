module maximum_value(
input [3:0]a,b,
output reg [3:0]max);
always@(*)
begin
if(a>b)
max=a;
else
max=b;	
end
endmodule
