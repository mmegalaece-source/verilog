// Dual-clock asynchronous FIFO
module generic_fifo_dc #(
    parameter dw = 8,
    parameter aw = 8,
    parameter n  = 32,
    parameter max_size = (1 << aw)
)(
    input                  rd_clk,
    input                  wr_clk,
    input                  rst,       // Active-low reset
    input                  clr,       // Synchronous clear
    input      [dw-1:0]    din,
    input                  we,
    output reg [dw-1:0]    dout,
    input                  re,
    output reg             full,
    output reg             empty,
    output reg             full_n,
    output reg             empty_n,
    output reg [1:0]       level
);

    localparam DEPTH = (1 << aw);

    // Binary and Gray-code pointers
    reg [aw:0] wbin, rbin;
    reg [aw:0] wgray, rgray;

    wire [aw:0] wbin_next, rbin_next;
    wire [aw:0] wgray_next, rgray_next;

    // Two-stage synchronizers
    reg [aw:0] rgray_sync1, rgray_sync2;
    reg [aw:0] wgray_sync1, wgray_sync2;

    // Pointer calculations
    wire write_accept;
    wire read_accept;

    wire [aw:0] rbin_sync;
    wire [aw:0] wbin_sync;

    wire [aw:0] wr_count;
    wire [aw:0] rd_count;

    wire [aw:0] full_compare;

    // FIFO storage
    reg [dw-1:0] mem [0:DEPTH-1];

    // Binary-to-Gray conversion
    assign wbin_next  = wbin + write_accept;
    assign rbin_next  = rbin + read_accept;

    assign wgray_next = (wbin_next >> 1) ^ wbin_next;
    assign rgray_next = (rbin_next >> 1) ^ rbin_next;

    // Convert synchronized Gray pointers back to binary
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

    assign rbin_sync = gray_to_bin(rgray_sync2);
    assign wbin_sync = gray_to_bin(wgray_sync2);

    // Local occupancy estimates
    assign wr_count = wbin - rbin_sync;
    assign rd_count = wbin_sync - rbin;

    // Accept only legal operations
    assign write_accept = we && !full && rst && !clr;
    assign read_accept  = re && !empty && rst && !clr;

    // Full comparison: invert the two most significant
    // bits of the synchronized read Gray pointer.
    assign full_compare = {
        ~rgray_sync2[aw:aw-1],
         rgray_sync2[aw-2:0]
    };

    // Synchronize read pointer into write clock domain
    always @(posedge wr_clk) begin
        if (!rst || clr) begin
            rgray_sync1 <= '0;
            rgray_sync2 <= '0;
        end
        else begin
            rgray_sync1 <= rgray;
            rgray_sync2 <= rgray_sync1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rd_clk) begin
        if (!rst || clr) begin
            wgray_sync1 <= '0;
            wgray_sync2 <= '0;
        end
        else begin
            wgray_sync1 <= wgray;
            wgray_sync2 <= wgray_sync1;
        end
    end

    // Write pointer, memory write, and full flag
    always @(posedge wr_clk) begin
        if (!rst || clr) begin
            wbin  <= '0;
            wgray <= '0;
            full  <= 1'b0;
            full_n <= 1'b1;
            level <= 2'b00;
        end
        else begin
            if (write_accept) begin
                mem[wbin[aw-1:0]] <= din;
                wbin  <= wbin_next;
                wgray <= wgray_next;
            end
            full <= (wgray_next == full_compare);
            full_n <= (wr_count <= DEPTH - n);
            if (wr_count >= (DEPTH * 3 / 4))
                level <= 2'b11;
            else if (wr_count >= (DEPTH / 2))
                level <= 2'b10;
            else if (wr_count >= (DEPTH / 4))
                level <= 2'b01;
            else
                level <= 2'b00;
        end
    end

    always @(posedge rd_clk) begin
        if (!rst || clr) begin
            rbin   <= '0;
            rgray  <= '0;
            dout   <= '0;
            empty  <= 1'b1;
            empty_n <= 1'b0;
        end
        else begin
            if (read_accept) begin
                dout  <= mem[rbin[aw-1:0]];
                rbin  <= rbin_next;
                rgray <= rgray_next;
            end
            empty <= (rgray_next == wgray_sync2);
            empty_n <= (rd_count >= n);
        end
    end

    always @(posedge wr_clk) begin
        if (we && full)
            $display(
                "WARNING: FIFO write attempted while FULL at time %0t",$time);
 end

    always @(posedge rd_clk) begin
        if (re && empty)
            $display(
                "WARNING: FIFO read attempted while EMPTY at time %0t",$time);
    end
endmodule
