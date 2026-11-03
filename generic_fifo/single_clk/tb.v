`timescale 1ns/1ps

module test;

reg clk;
reg rst;
reg clr;
reg we, re;
reg [7:0] din;

wire [7:0] dout;
wire full, empty;
wire full_r, empty_r;
wire full_n, empty_n;
wire full_n_r, empty_n_r;
wire [1:0] level;

reg [7:0] buffer [0:255];

integer wr_count, rd_count;
integer errors;
integer i;

generic_fifo_sc_b #(8, 8, 9) uut (
    .clk(clk),
    .rst(rst),
    .clr(clr),
    .din(din),
    .we(we & !full),
    .dout(dout),
    .re(re & !empty),
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

initial begin
    clk = 0;
    rst = 0;
    clr = 0;
    we = 0;
    re = 0;
    din = 0;

    wr_count = 0;
    rd_count = 0;
    errors = 0;

    repeat (5) @(posedge clk);
    @(negedge clk);
    rst = 1;

    repeat (3) @(posedge clk);

    $display("SINGLE CLOCK FIFO TEST STARTED");

    for (i = 0; i < 17; i = i + 1)
        write_data(i + 8'h20);

    repeat (3) @(posedge clk);

    for (i = 0; i < 17; i = i + 1)
        read_data();

    if ((wr_count == rd_count) && (errors == 0))
        $display("FIFO TEST PASSED");
    else
        $display("FIFO TEST FAILED: writes=%0d reads=%0d errors=%0d",
                 wr_count, rd_count, errors);

    #20;
    $finish;
end

always #5 clk = ~clk;

task write_data(input [7:0] data);
begin
    @(negedge clk);

    if (!full) begin
        din = data;
        we = 1;

        buffer[wr_count] = data;

        @(posedge clk);
        #2;

        $display("WRITE: Index=%0d Data=%h Time=%0t",
                 wr_count, data, $time);

        wr_count = wr_count + 1;
        we = 0;
    end
    else begin
        $display("FIFO FULL: Write skipped at Time=%0t", $time);
    end
end
endtask

task read_data;
begin
    @(negedge clk);

    if (!empty) begin
        re = 1;

        @(posedge clk);
        #3;

        if (dout !== buffer[rd_count]) begin
            $display("ERROR: Index=%0d Expected=%h Actual=%h Time=%0t",
                     rd_count, buffer[rd_count], dout, $time);
            errors = errors + 1;
        end
        else begin
            $display("READ OK: Index=%0d Data=%h Time=%0t",
                     rd_count, dout, $time);
        end

        rd_count = rd_count + 1;
        re = 0;
    end
    else begin
        $display("FIFO EMPTY: Read skipped at Time=%0t", $time);
    end
end
endtask

endmodule
