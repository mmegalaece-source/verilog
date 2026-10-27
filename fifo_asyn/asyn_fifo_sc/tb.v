`timescale 1ns/1ps

module tb_generic_fifo_sc;

    reg clk;
    reg rst;
    reg clr;
    reg we;
    reg re;
    reg [7:0] din;

    wire [7:0] dout;
    wire full, empty;
    wire full_r, empty_r;
    wire full_n, empty_n;
    wire full_n_r, empty_n_r;
    wire [1:0] level;

    integer i;
    integer wrp, rdp;
    reg [7:0] buffer [0:255];

    // DUT: Single-clock FIFO
    generic_fifo_sc_a #(8, 4, 4) dut (
        .clk(clk),
        .rst(rst),
        .clr(clr),
        .din(din),
        .we(we),
        .dout(dout),
        .re(re),
        .full(full),
        .empty(empty),
        .full_r(full_r),
        .empty_r(empty_r),
        .full_n(full_n),
        .empty_n(empty_n),
        .full_n_r(full_n_r),
        .empty_n_r(empty_n_r),
        .level(level)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        rst = 0;
        clr = 0;
        we = 0;
        re = 0;
        din = 0;
        wrp = 0;
        rdp = 0;

        $dumpfile("single_fifo.vcd");
        $dumpvars(0, tb_generic_fifo_sc);

        // Reset
        repeat (3) @(negedge clk);
        rst = 1;
        repeat (2) @(negedge clk);

        $display("\n--- FIFO WRITE TEST ---");

        // Write 10, 20, 30, 40
        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            if (!full) begin
                we = 1;
                din = (i + 1) * 10;
                buffer[wrp] = din;
                wrp = wrp + 1;
                $display("WRITE: din = %0d", din);
            end
        end

        @(negedge clk);
        we = 0;

        repeat (2) @(negedge clk);

        $display("\n--- FIFO READ TEST ---");

        // Read the stored values in FIFO order
        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            if (!empty) begin
                re = 1;
                @(posedge clk);
                #2;

                if (dout !== buffer[rdp])
                    $display("ERROR: expected %0d, got %0d",
                             buffer[rdp], dout);
                else
                    $display("READ PASS: dout = %0d", dout);

                rdp = rdp + 1;
                @(negedge clk);
                re = 0;
            end
        end

        @(negedge clk);
        we = 0;
        re = 0;

        repeat (3) @(negedge clk);

        $display("\n--- SIMULTANEOUS READ/WRITE TEST ---");

        // Write two values
        @(negedge clk);
        we = 1;
        din = 8'd55;
        buffer[wrp] = din;
        wrp = wrp + 1;

        @(negedge clk);
        din = 8'd66;
        buffer[wrp] = din;
        wrp = wrp + 1;

        @(negedge clk);
        we = 0;

        // Read one value while writing another
        @(negedge clk);
        we = 1;
        re = 1;
        din = 8'd77;
        buffer[wrp] = din;
        wrp = wrp + 1;

        @(posedge clk);
        #2;
        if (dout !== buffer[rdp])
            $display("ERROR: expected %0d, got %0d",
                     buffer[rdp], dout);
        else
            $display("READ PASS: dout = %0d", dout);

        rdp = rdp + 1;

        @(negedge clk);
        we = 0;
        re = 0;

        repeat (3) @(negedge clk);

        $display("\n--- TEST COMPLETED ---");
        $display("Final status: full=%b empty=%b level=%b",
                 full, empty, level);

        $finish;
    end

endmodule
