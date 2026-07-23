module siso(
input clk,rst,
input sin,
output sout);
reg q0,q1,q2;
assign sout=q2;
always@(posedge clk or negedge rst)
begin
if(!rst)
begin
q0<=1'b0;
q1<=1'b0;
q2<=1'b0;
end
else begin
q0<=sin;
q1<=q0;
q2<=q1;
end
end
endmodule

