module even_number(
    input [3:0] a,
    output reg even
);
always @(*)
begin
    if (a % 2 == 0)
        even = 1'b1;
    else
        even = 1'b0;
end
endmodule
