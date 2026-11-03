// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb;

    parameter DW = 8;
    parameter AW = 3;
    parameter DEPTH = (1 << AW);
    parameter N = 2;

    reg rd_clk;
    reg wr_clk;
    reg rst;
    reg clr;

    reg [DW-1:0] din;
    reg we;
    reg re;

    wire [DW-1:0] dout;
    wire full;
    wire empty;
    wire full_n;
    wire empty_n;
    wire [1:0] level;

    integer i;
    integer errors;
    reg [DW-1:0] expected [0:DEPTH-1];

    // DUT: Device Under Test
    generic_fifo_dc #(
        .dw(DW),
        .aw(AW),
        .n(N),
        .max_size(DEPTH)
    ) dut (
        .rd_clk(rd_clk),
        .wr_clk(wr_clk),
        .rst(rst),
        .clr(clr),
        .din(din),
        .we(we),
        .dout(dout),
        .re(re),
        .full(full),
        .empty(empty),
        .full_n(full_n),
        .empty_n(empty_n),
        .level(level)
    );

    // Write clock: 10 ns period
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

    // Read clock: 14 ns period
    initial begin
        rd_clk = 0;
        forever #7 rd_clk = ~rd_clk;
    end

    // Test sequence
    initial begin
        rst = 0;
        clr = 0;
        din = 0;
        we = 0;
        re = 0;
        errors = 0;

        $display("-----------------------------------");
        $display("   ASYNCHRONOUS FIFO TEST START");
        $display("-----------------------------------");

        // Reset
        repeat (4) @(posedge wr_clk);
        @(negedge wr_clk);
        rst = 1;

        repeat (4) @(posedge rd_clk);

        // Test 1: Write data
        $display("\nTEST 1: Writing data");

        for (i = 0; i < DEPTH; i = i + 1) begin
            @(negedge wr_clk);

            // Wait for FIFO to report space
            while (full === 1'b1)
                @(negedge wr_clk);

            din = i + 8'h10;
            we = 1;

            // Save expected data in FIFO order
            expected[i] = i + 8'h10;

            @(posedge wr_clk);
            #1;
            $display("WRITE: din=%0h full=%b", din, full);
        end

        @(negedge wr_clk);
        we = 0;
        din = 0;

        // Allow pointer synchronization
        repeat (4) @(posedge rd_clk);

        // Test 2: Read data and compare
        $display("\nTEST 2: Reading and checking data");

        for (i = 0; i < DEPTH; i = i + 1) begin
            @(negedge rd_clk);

            while (empty === 1'b1)
                @(negedge rd_clk);

            re = 1;

            // Capture synchronous read output after the active edge
            @(posedge rd_clk);
            #1;

            if (dout !== expected[i]) begin
                $display(
                    "FAIL: expected=%0h actual=%0h index=%0d",
                    expected[i], dout, i
                );
                errors = errors + 1;
            end
            else begin
                $display("PASS: dout=%0h", dout);
            end
        end

        @(negedge rd_clk);
        re = 0;

        repeat (4) @(posedge rd_clk);

        // Test 3: Empty flag
        $display("\nTEST 3: Empty flag");
        if (empty === 1'b1)
            $display("PASS: FIFO is empty");
        else begin
            $display("FAIL: FIFO should be empty");
            errors = errors + 1;
        end

        // Test 4: Clear
        $display("\nTEST 4: Clear");

        @(negedge wr_clk);
        clr = 1;

        @(negedge wr_clk);
        clr = 0;

        repeat (4) @(posedge rd_clk);

        $display("\n-----------------------------------");
        if (errors == 0)
            $display("TEST RESULT: ALL CHECKS PASSED");
        else
            $display("TEST RESULT: FAILED, errors=%0d", errors);
        $display("-----------------------------------");

        $finish;
    end

    // Monitor FIFO status
    initial begin
        $monitor(
            "time=%0t rst=%b clr=%b we=%b re=%b din=%h dout=%h full=%b empty=%b",
            $time, rst, clr, we, re, din, dout, full, empty
        );
    end

    // Simulation timeout
    initial begin
        #5000;
        $display("ERROR: Simulation timeout");
        $finish;
    end

endmodule
