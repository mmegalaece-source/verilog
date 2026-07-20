module odd_number(
    input [3:0] a,
    output reg odd
);
always @(*)
begin
    if (a % 2 == 1)
        odd = 1'b1;
    else
        odd = 1'b0;
end
endmodule
