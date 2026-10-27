
`timescale 1ns/1ps

module generic_fifo_dc_gray #(
    parameter dw = 16,
    parameter aw = 8
)(
    input                  rd_clk,
    input                  wr_clk,
    input                  rst,       // Active-low reset
    input                  clr,
    input      [dw-1:0]    din,
    input                  we,
    output reg [dw-1:0]    dout,
    input                  re,
    output                 full,
    output                 empty,
    output reg [1:0]       wr_level,
    output reg [1:0]       rd_level
);

    // aw must be at least 2
    localparam DEPTH = (1 << aw);

    // Memory
    reg [dw-1:0] mem [0:DEPTH-1];

    // Binary and Gray-code pointers
    reg [aw:0] wp_bin, wp_gray;
    reg [aw:0] rp_bin, rp_gray;

    // Two-stage pointer synchronizers
    reg [aw:0] wp_gray_sync1, wp_gray_sync2;
    reg [aw:0] rp_gray_sync1, rp_gray_sync2;

    wire [aw:0] wp_bin_next;
    wire [aw:0] wp_gray_next;
    wire [aw:0] rp_bin_next;
    wire [aw:0] rp_gray_next;

    wire [aw:0] rp_bin_sync;
    wire [aw:0] wp_bin_sync;

    wire [aw:0] wr_used;
    wire [aw:0] rd_used;

    // Gray to binary conversion
    function [aw:0] gray_to_bin;
        input [aw:0] gray;
        integer i;
        begin
            gray_to_bin[aw] = gray[aw];

            for (i = aw-1; i >= 0; i = i-1)
                gray_to_bin[i] =
                    gray_to_bin[i+1] ^ gray[i];
        end
    endfunction

    assign rp_bin_sync = gray_to_bin(rp_gray_sync2);
    assign wp_bin_sync = gray_to_bin(wp_gray_sync2);

    // FIFO status
    assign full =
        (wp_gray ==
        {~rp_gray_sync2[aw:aw-1],
          rp_gray_sync2[aw-2:0]});

    assign empty = (rp_gray == wp_gray_sync2);

    // Next pointer values
    assign wp_bin_next =
        wp_bin + ((we && !full) ? 1'b1 : 1'b0);

    assign wp_gray_next =
        wp_bin_next ^ (wp_bin_next >> 1);

    assign rp_bin_next =
        rp_bin + ((re && !empty) ? 1'b1 : 1'b0);

    assign rp_gray_next =
        rp_bin_next ^ (rp_bin_next >> 1);

    // Write pointer and memory write
    always @(posedge wr_clk or negedge rst) begin
        if (!rst) begin
            wp_bin  <= 0;
            wp_gray <= 0;
        end
        else if (clr) begin
            wp_bin  <= 0;
            wp_gray <= 0;
        end
        else begin
            wp_bin  <= wp_bin_next;
            wp_gray <= wp_gray_next;

            if (we && !full)
                mem[wp_bin[aw-1:0]] <= din;
        end
    end

    // Read pointer and memory read
    always @(posedge rd_clk or negedge rst) begin
        if (!rst) begin
            rp_bin <= 0;
            rp_gray <= 0;
            dout <= 0;
        end
        else if (clr) begin
            rp_bin <= 0;
            rp_gray <= 0;
            dout <= 0;
        end
        else begin
            rp_bin <= rp_bin_next;
            rp_gray <= rp_gray_next;

            if (re && !empty)
                dout <= mem[rp_bin[aw-1:0]];
        end
    end

    // Synchronize read pointer into write clock domain
    always @(posedge wr_clk or negedge rst) begin
        if (!rst) begin
            rp_gray_sync1 <= 0;
            rp_gray_sync2 <= 0;
        end
        else if (clr) begin
            rp_gray_sync1 <= 0;
            rp_gray_sync2 <= 0;
        end
        else begin
            rp_gray_sync1 <= rp_gray;
            rp_gray_sync2 <= rp_gray_sync1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rd_clk or negedge rst) begin
        if (!rst) begin
            wp_gray_sync1 <= 0;
            wp_gray_sync2 <= 0;
        end
        else if (clr) begin
            wp_gray_sync1 <= 0;
            wp_gray_sync2 <= 0;
        end
        else begin
            wp_gray_sync1 <= wp_gray;
            wp_gray_sync2 <= wp_gray_sync1;
        end
    end

    // Approximate occupancy counts
    assign wr_used = wp_bin - rp_bin_sync;
    assign rd_used = wp_bin_sync - rp_bin;

    // Two-bit occupancy indicators:
    // 00 = empty, 01 = below half, 10 = half or more,
    // 11 = full (write side only)
    always @(*) begin
        if (wr_used == 0)
            wr_level = 2'b00;
        else if (wr_used < (DEPTH/2))
            wr_level = 2'b01;
        else if (wr_used < DEPTH)
            wr_level = 2'b10;
        else
            wr_level = 2'b11;
    end

    always @(*) begin
        if (rd_used == 0)
            rd_level = 2'b00;
        else if (rd_used < (DEPTH/2))
            rd_level = 2'b01;
        else if (rd_used < DEPTH)
            rd_level = 2'b10;
        else
            rd_level = 2'b11;
    end

endmodule

