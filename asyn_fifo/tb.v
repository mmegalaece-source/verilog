
`timescale 1ns/1ps

module async_fifo_tb;

    parameter data_width = 8;
    parameter addr_width = 3;

    reg wr_clk, rd_clk;
    reg rst_n;
    reg wr_en, rd_en;
    reg [data_width-1:0] wr_data;

    wire [data_width-1:0] rd_data;
    wire full, empty;

    // DUT
    async_fifo #(
        .data_width(data_width),
        .addr_width(addr_width)
    ) dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
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

    // Main test
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, async_fifo_tb);

        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        wr_data = 0;

        $display("time\toperation\tdata\tfull\tempty");

        // Reset
        repeat (3) @(negedge wr_clk);
        rst_n = 1;

        // Write all 8 entries
        write_data(8'hA1);
        write_data(8'hB2);
        write_data(8'hC3);
        write_data(8'hD4);
        write_data(8'hE5);
        write_data(8'hF6);
        write_data(8'h17);
        write_data(8'h28);

        // Allow the full flag to update
        repeat (3) @(negedge wr_clk);
        $display("%0t\tfull check\t--\t%b\t%b",
                 $time, full, empty);

        // Allow the write pointer to synchronize to read clock
        repeat (3) @(negedge rd_clk);

        // Read all 8 entries
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();
        read_data();

        // Allow empty flag to update
        repeat (3) @(negedge rd_clk);
        $display("%0t\tempty check\t--\t%b\t%b",
                 $time, full, empty);

        $finish;
    end

    // Write task
    task write_data(input [data_width-1:0] data);
        begin
            @(negedge wr_clk);

            if (!full) begin
                wr_en   = 1;
                wr_data = data;

                @(posedge wr_clk);
                #1;
                $display("%0t\twrite\t\t%h\t%b\t%b",
                         $time, data, full, empty);

                @(negedge wr_clk);
                wr_en = 0;
            end
            else begin
                $display("%0t\twrite blocked\t%h\t%b\t%b",
                         $time, data, full, empty);
            end
        end
    endtask

    // Read task
    task read_data;
        begin
            wait (empty == 0);
            @(negedge rd_clk);

            if (!empty) begin
                rd_en = 1;

                @(posedge rd_clk);
                #1;
                $display("%0t\tread\t\t%h\t%b\t%b",
                         $time, rd_data, full, empty);

                @(negedge rd_clk);
                rd_en = 0;
            end
        end
    endtask
endmodule
