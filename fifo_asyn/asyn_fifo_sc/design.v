`timescale 1ns/1ps

`define SC_FIFO_ASYNC_RESET

module generic_fifo_sc_a (
    clk, rst, clr, din, we, dout, re,
    full, empty, full_r, empty_r,
    full_n, empty_n, full_n_r, empty_n_r,
    level
);

parameter dw = 8;
parameter aw = 8;
parameter n = 32;
parameter max_size = 1 << aw;

input clk, rst, clr;
input [dw-1:0] din;
input we;
output [dw-1:0] dout;
input re;

output full, empty;
output full_r, empty_r;
output full_n, empty_n;
output full_n_r, empty_n_r;
output [1:0] level;

reg [aw-1:0] wp, rp;
wire [aw-1:0] wp_pl1;
wire [aw-1:0] wp_pl2;
wire [aw-1:0] rp_pl1;

reg full_r, empty_r;
reg gb, gb2;
reg [aw:0] cnt;
reg full_n_r, empty_n_r;

wire full, empty;
wire full_n, empty_n;

////////////////////////////////////////////////////////////////////
// Internal Memory Block
////////////////////////////////////////////////////////////////////

reg [dw-1:0] mem [0:max_size-1];
reg [dw-1:0] dout_reg;

assign dout = dout_reg;

// Write data into memory
always @(posedge clk) begin
    if (!rst)
        ;
    else if (clr)
        ;
    else if (we)
        mem[wp] <= din;
end

// Read data from memory
always @(posedge clk) begin
    if (!rst)
        dout_reg <= {dw{1'b0}};
    else if (clr)
        dout_reg <= {dw{1'b0}};
    else if (re)
        dout_reg <= mem[rp];
end

////////////////////////////////////////////////////////////////////
// Write Pointer
////////////////////////////////////////////////////////////////////

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        wp <= {aw{1'b0}};
    else if (clr)
        wp <= {aw{1'b0}};
    else if (we)
        wp <= wp_pl1;
end

assign wp_pl1 = wp + 1'b1;
assign wp_pl2 = wp + 2'd2;

////////////////////////////////////////////////////////////////////
// Read Pointer
////////////////////////////////////////////////////////////////////

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        rp <= {aw{1'b0}};
    else if (clr)
        rp <= {aw{1'b0}};
    else if (re)
        rp <= rp_pl1;
end

assign rp_pl1 = rp + 1'b1;

////////////////////////////////////////////////////////////////////
// Combinational Full and Empty Flags
////////////////////////////////////////////////////////////////////

assign empty = ((wp == rp) && !gb);
assign full  = ((wp == rp) && gb);

// Guard bit
always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        gb <= 1'b0;
    else if (clr)
        gb <= 1'b0;
    else if ((wp_pl1 == rp) && we)
        gb <= 1'b1;
    else if (re)
        gb <= 1'b0;
end

////////////////////////////////////////////////////////////////////
// Registered Full and Empty Flags
////////////////////////////////////////////////////////////////////

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        gb2 <= 1'b0;
    else if (clr)
        gb2 <= 1'b0;
    else if ((wp_pl2 == rp) && we)
        gb2 <= 1'b1;
    else if ((wp != rp) && re)
        gb2 <= 1'b0;
end

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        full_r <= 1'b0;
    else if (clr)
        full_r <= 1'b0;
    else if (we && (wp_pl1 == rp) && gb2 && !re)
        full_r <= 1'b1;
    else if (re && ((wp_pl1 != rp) || !gb2) && !we)
        full_r <= 1'b0;
end

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        empty_r <= 1'b1;
    else if (clr)
        empty_r <= 1'b1;
    else if (we && ((wp != rp_pl1) || gb2) && !re)
        empty_r <= 1'b0;
    else if (re && (wp == rp_pl1) && !gb2 && !we)
        empty_r <= 1'b1;
end

////////////////////////////////////////////////////////////////////
// Full_n, Empty_n and FIFO Level
////////////////////////////////////////////////////////////////////

assign empty_n = (cnt < n);
assign full_n  = !(cnt < (max_size - n + 1));

assign level = {2{cnt[aw]}} | cnt[aw-1:aw-2];

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        cnt <= 0;
    else if (clr)
        cnt <= 0;
    else if (re && !we)
        cnt <= cnt - 1'b1;
    else if (!re && we)
        cnt <= cnt + 1'b1;
end

////////////////////////////////////////////////////////////////////
// Registered Full_n and Empty_n Flags
////////////////////////////////////////////////////////////////////

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        empty_n_r <= 1'b1;
    else if (clr)
        empty_n_r <= 1'b1;
    else if (we && (cnt >= (n-1)) && !re)
        empty_n_r <= 1'b0;
    else if (re && (cnt <= n) && !we)
        empty_n_r <= 1'b1;
end

always @(posedge clk `SC_FIFO_ASYNC_RESET) begin
    if (!rst)
        full_n_r <= 1'b0;
    else if (clr)
        full_n_r <= 1'b0;
    else if (we && (cnt >= (max_size-n)) && !re)
        full_n_r <= 1'b1;
    else if (re && (cnt <= (max_size-n+1)) && !we)
        full_n_r <= 1'b0;
end

////////////////////////////////////////////////////////////////////
// Sanity Check
////////////////////////////////////////////////////////////////////

// synopsys translate_off
always @(posedge clk) begin
    if (we && full)
        $display("%m WARNING: Writing while FIFO is FULL (%t)", $time);

    if (re && empty)
        $display("%m WARNING: Reading while FIFO is EMPTY (%t)", $time);
end
// synopsys translate_on

endmodule
