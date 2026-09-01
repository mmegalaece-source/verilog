module sipo(input clk,rst,sin,output reg [3:0]pout);
reg[3:0]shift;
always@(posedge clk)begin
if(rst)begin
pout<=4'b0000;
end
else begin
pout<={pout[2:0],sin};
end
end
endmodule

