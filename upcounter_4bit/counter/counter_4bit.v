module counter_4bit(input count,output y);
always@(posedge clk)
if(!rst)
count=0;
else
count=count+1;
endmodule
