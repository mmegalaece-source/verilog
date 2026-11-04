module comparator(
    input A,
    input B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);
always @(*)
begin
    A_greater = 0;
    A_equal = 0;
    A_less = 0;

    if(A > B)
        A_greater = 1;

    else if(A == B)
        A_equal = 1;

    else
        A_less = 1;
end
endmodule
