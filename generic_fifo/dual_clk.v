`timescale 1ns/1ps

module generic_fifo_dc #(
    parameter dw = 8,
    parameter aw = 8,
    parameter n = 32,
    parameter max_size = 1 << aw
)(
    input rd_clk,
    input wr_clk,
    input rst,
    input clr,
    input [dw-1:0] din,
    input we,
    output [dw-1:0] dout,
    input re,
    output reg full,
    output reg empty,
    output reg full_n,
    output reg empty_n,
    output reg [1:0] level
);

reg [aw:0] wp;
wire [aw:0] wp_pl1;
reg [aw:0] rp;
wire [aw:0] rp_pl1;

reg [aw:0] wp_s;
reg [aw:0] rp_s;

wire [aw:0] diff;
reg [aw:0] diff_r1;
reg [aw:0] diff_r2;

reg re_r;
reg we_r;

generic_dpram #(aw, dw) u0 (
    .rclk(rd_clk),
    .rrst(!rst),
    .rce(1'b1),
    .oe(1'b1),
    .raddr(rp[aw-1:0]),
    .dout(dout),
    .wclk(wr_clk),
    .wrst(!rst),
    .wce(1'b1),
    .we(we),
    .waddr(wp[aw-1:0]),
    .din(din)
);

always @(posedge wr_clk) begin
    if (!rst)
        wp <= 0;
    else if (clr)
        wp <= 0;
    else if (we)
        wp <= wp_pl1;
end

assign wp_pl1 = wp + 1'b1;

always @(posedge rd_clk) begin
    if (!rst)
        rp <= 0;
    else if (clr)
        rp <= 0;
    else if (re)
        rp <= rp_pl1;
end

assign rp_pl1 = rp + 1'b1;

always @(posedge rd_clk)
    wp_s <= wp;

always @(posedge wr_clk)
    rp_s <= rp;

always @(posedge rd_clk)
    empty <= (wp_s == rp) |
             (re && (wp_s == rp_pl1));

always @(posedge wr_clk)
    full <= ((wp[aw-1:0] == rp_s[aw-1:0]) &&
             (wp[aw] != rp_s[aw])) ||
            (we &&
             (wp_pl1[aw-1:0] == rp_s[aw-1:0]) &&
             (wp_pl1[aw] != rp_s[aw]));

assign diff = wp - rp;

always @(posedge rd_clk)
    re_r <= re;

always @(posedge rd_clk)
    diff_r1 <= diff;

always @(posedge rd_clk)
    empty_n <= (diff_r1 < n) ||
               ((diff_r1 == n) && (re || re_r));

always @(posedge wr_clk)
    we_r <= we;

always @(posedge wr_clk)
    diff_r2 <= diff;

always @(posedge wr_clk)
    full_n <= (diff_r2 > max_size - n) ||
              ((diff_r2 == max_size - n) && (we || we_r));

always @(posedge wr_clk)
    level <= {2{diff[aw]}} | diff[aw-1:aw-2];

always @(posedge wr_clk) begin
    if (we && full)
        $display("WARNING: Writing while FIFO is FULL at time %0t", $time);
end

always @(posedge rd_clk) begin
    if (re && empty)
        $display("WARNING: Reading while FIFO is EMPTY at time %0t", $time);
end

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
