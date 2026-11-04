module sr_ff(input s,r,clk,rst,output reg q,qbar);
always@(posedge clk)
begin
case({s,r})
2'b00:q<=q;
2'b01:q<=2'b00;
2'b10:q<=2'b01;
2'b11:q<=2'bx;
endcase
begin
	qbar=~q;
end
end
endmodule
