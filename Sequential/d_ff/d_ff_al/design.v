module dff_al(
    input  wire clk,
    input  wire reset,   
    input  wire d,
    output reg  q
);
always @(negedge clk or negedge reset)
begin
    if (!reset)
        q <= 1'b0;       
    else
        q <= d;          
end
endmodule
