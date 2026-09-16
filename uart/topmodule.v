module topmodule #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
) (
    input  wire clk,
    input  wire reset,
    output wire tx_pin,
    input  wire rx_pin,
    input  wire tx_start,
    input  wire [7:0]  tx_data_in,
    output wire tx_busy,
    output wire [7:0]  rx_data_out,
    output wire rx_valid
);

tx #(
    .CLK_FREQ  (CLK_FREQ),
    .BAUD_RATE (BAUD_RATE)
) u_tx (
    .clk (clk),
    .reset (reset),
    .ena (tx_start),
    .data_in (tx_data_in),
    .tx (tx_pin),
    .busy (tx_busy)
);

receiver #(
    .CLK_FREQ  (CLK_FREQ),
    .BAUD_RATE (BAUD_RATE)
) receiver (
    .clk       (clk),
    .reset     (reset),
    .rx        (rx_pin),
    .data_out  (rx_data_out),
    .rx_valid  (rx_valid)
);
endmodule
