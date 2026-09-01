module pipo(input clk,
	input rst,
	input [3:0]pin,
	output reg [3:0]pout);
always@(posedge clk)begin
if(rst)begin
pout<=4'b0000;
end
else begin
pout<=pin;
end
end
endmodule

