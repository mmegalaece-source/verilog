module sr_latch_b(
input s,r,
output reg q,qbar);
always@(*) begin
	if (s!=r)begin
		q=s;
		qbar=r;
	end
end
endmodule
