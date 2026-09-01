module piso(input clk,
input rst,
input load,
input [3:0]pin,
output pout);
reg[3:0]shift;
always@(posedge clk)begin
if(rst)begin
shift<=4'b0000;
end
else if(load)
	shift<=pin;
else
shift<={shift[2:0],1'b0};
end
assign pout=shift[3];
endmodule
