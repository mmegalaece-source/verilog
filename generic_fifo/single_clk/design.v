`timescale 1ns/1ps


`define SC_FIFO_ASYNC_RESET

module generic_fifo_sc_b(clk, rst, clr, din, we, dout, re,
                         full, empty, full_r, empty_r,
                         full_n, empty_n, full_n_r, empty_n_r,
                         level);

parameter dw = 8;
parameter aw = 8;
parameter n = 32;
parameter max_size = 1 << aw;

input clk, rst, clr;
input [dw-1:0] din;
input we;
output [dw-1:0] dout;
input re;
output full, full_r;
output empty, empty_r;
output full_n, full_n_r;
output empty_n, empty_n_r;
output [1:0] level;

reg [aw:0] wp;
wire [aw:0] wp_pl1;
reg [aw:0] rp;
wire [aw:0] rp_pl1;
reg full_r;
reg empty_r;
wire [aw:0] diff;
reg [aw:0] diff_r;
reg re_r, we_r;
wire full_n, empty_n;
reg full_n_r, empty_n_r;
reg [1:0] level;

generic_dpram #(aw, dw) u0(
    .rclk(clk),
    .rrst(!rst),
    .rce(1'b1),
    .oe(1'b1),
    .raddr(rp[aw-1:0]),
    .dout(dout),
    .wclk(clk),
    .wrst(!rst),
    .wce(1'b1),
    .we(we),
    .waddr(wp[aw-1:0]),
    .din(din)
);

always @(posedge clk `SC_FIFO_ASYNC_RESET)
    if (!rst)
        wp <= #1 {aw+1{1'b0}};
    else if (clr)
        wp <= #1 {aw+1{1'b0}};
    else if (we)
        wp <= #1 wp_pl1;

assign wp_pl1 = wp + {{aw{1'b0}}, 1'b1};

always @(posedge clk `SC_FIFO_ASYNC_RESET)
    if (!rst)
        rp <= #1 {aw+1{1'b0}};
    else if (clr)
        rp <= #1 {aw+1{1'b0}};
    else if (re)
        rp <= #1 rp_pl1;

assign rp_pl1 = rp + {{aw{1'b0}}, 1'b1};

assign empty = (wp == rp);
assign full = (wp[aw-1:0] == rp[aw-1:0]) & (wp[aw] != rp[aw]);

always @(posedge clk)
    empty_r <= #1 (wp == rp) | (re & (wp == rp_pl1));

always @(posedge clk)
    full_r <= #1
        ((wp[aw-1:0] == rp[aw-1:0]) & (wp[aw] != rp[aw])) |
        (we & (wp_pl1[aw-1:0] == rp[aw-1:0]) &
         (wp_pl1[aw] != rp[aw]));

assign diff = wp - rp;
assign empty_n = diff < n;
assign full_n = !(diff < (max_size - n + 1));

always @(posedge clk)
    level <= #1 {2{diff[aw]}} | diff[aw-1:aw-2];

always @(posedge clk)
    re_r <= #1 re;

always @(posedge clk)
    diff_r <= #1 diff;

always @(posedge clk)
    empty_n_r <= #1
        (diff_r < n) | ((diff_r == n) & (re | re_r));

always @(posedge clk)
    we_r <= #1 we;

always @(posedge clk)
    full_n_r <= #1
        (diff_r > max_size - n) |
        ((diff_r == max_size - n) & (we | we_r));

always @(posedge clk)
    if (we & full)
        $display("%m WARNING: Writing while fifo is FULL (%t)", $time);

always @(posedge clk)
    if (re & empty)
        $display("%m WARNING: Reading while fifo is EMPTY (%t)", $time);

endmodule


module generic_dpram #(
    parameter aw = 8,
    parameter dw = 8
)(
    input rclk,
    input rrst,
    input rce,
    input oe,
    input [aw-1:0] raddr,
    output reg [dw-1:0] dout,

    input wclk,
    input wrst,
    input wce,
    input we,
    input [aw-1:0] waddr,
    input [dw-1:0] din
);

localparam DEPTH = 1 << aw;

reg [dw-1:0] mem [0:DEPTH-1];

always @(posedge wclk) begin
    if (!wrst) begin
        if (wce && we)
            mem[waddr] <= din;
    end
end

always @(posedge rclk) begin
    if (rrst)
        dout <= 0;
    else if (rce && oe)
        dout <= mem[raddr];
end

endmodule
