module function_example(
    input  [3:0] a,
    input  [3:0] b,
    output reg [3:0] max
);

function [3:0] find_max;
    input [3:0] x;
    input [3:0] y;
    begin
        if (x > y)
            find_max = x;
        else
            find_max = y;
    end
endfunction

always @(*)
begin
    max = find_max(a,b);
end

endmodule
