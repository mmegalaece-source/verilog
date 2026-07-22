module even_odd(
input [3:0]a,
output reg y);
always@(*) begin
	if(a[0]==0)begin
            y=1;
    end
    else begin
            y=0;
    end
end
endmodule

