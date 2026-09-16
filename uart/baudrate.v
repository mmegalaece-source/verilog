module baudrate #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
) (
    input  wire clk,
    input  wire reset,
    output reg  baud_clk
);
localparam CLK_PER_BIT = CLK_FREQ / BAUD_RATE;
reg [15:0] count;
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        count <= 16'd0;
        baud_clk <= 1'b0;
    end
    else begin
        if (count == CLK_PER_BIT - 1) begin
            count <= 16'd0;
            baud_clk <= 1'b1;
        end
        else begin
            count <= count + 1'b1;
            baud_clk <= 1'b0;
        end
    end
end
endmodule
