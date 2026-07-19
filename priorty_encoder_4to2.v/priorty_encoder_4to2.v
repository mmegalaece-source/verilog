module priorty_encoder_4to2(
input d0,d1,d2,d3,
output reg a1,b1,
output reg v
);
always@(*) begin
if(d3==1'b1)begin
a1=1'b1;b1=1'b1;v=1'b1;
end
else if(d2==1'b1)begin
a1=1'b1;b1=1'b0;v=1'b1;
end
else if(d1==1'b1)begin
a1=1'b0;b1=1'b1;v=1'b1;
end
else if(d0==1'b1)begin
a1=1'b0;b1=1'b0;v=1'b1;
end
else begin
a1=1'b0;b1=1'b0;v=1'b0;
end
end
endmodule
