module d_ff(
input d,clk,rst,
output qbar,
output reg q);
assign qbar = ~q;
always@(posedge clk)
begin
if(d==1'b0)
q<=1'b0;
else
q<=1'b1;
end
endmodule
