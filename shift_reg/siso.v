module siso(input clk,rst,sin,output sout);
reg [3:0]shift;
always@(posedge clk)begin
if(rst)begin
shift<=4'b0000;
end
else begin
shift<={shift[2:0],sin};
end
end
assign sout=shift[3];
endmodule

