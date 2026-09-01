module piso(input clk,
input rst,
input load,
input [3:0]pin,
output reg pout);
reg[3:0]shift;
always@(posedge clk)begin
if(rst)begin
shift<=4'b0000;
pout<=1'b0;
end
else if(load) begin
	shift<=pin;
	pout<=pin[3];
end
else begin
shift<={shift[2:0],1'b0};
pout<=shift[3];
end
end
endmodule
