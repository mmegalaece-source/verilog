module spi_protocol_tb;
    reg        clk;
    reg        reset;
    reg        start;
    reg [7:0]  tx_data;
    reg        miso;

    wire       sclk;
    wire       mosi;
    wire       cs_n;
    wire [7:0] rx_data;
    wire       busy;
    wire       done;
    // Slave data
    reg [7:0] slave_tx_data;
    integer i;
    spi_protocol uut (
        .clk     (clk),
        .reset   (reset),
        .start   (start),
        .tx_data (tx_data),
        .miso    (miso),
        .sclk    (sclk),
        .mosi    (mosi),
        .cs_n    (cs_n),
        .rx_data (rx_data),
        .busy    (busy),
        .done    (done)
    );
    // 10 ns period
    always #5 clk = ~clk;
    // First MISO bit is available before the
    // first rising edge.
    always @(negedge cs_n) begin
        if (!cs_n) begin
            miso = slave_tx_data[7];
        end
    end
    // Change MISO on falling edge.
    // Mode 0:
    // Rising edge  -> SAMPLE
    // Falling edge -> LAUNCH
    always @(negedge sclk) begin
        if (!cs_n) begin
            slave_tx_data = {
                slave_tx_data[6:0],
                1'b0
            };
            miso = slave_tx_data[7];
        end
    end
    initial begin
        clk     = 1'b0;
        reset   = 1'b1;
        start   = 1'b0;
        tx_data = 8'hA5;
        miso    = 1'b0;
        // Slave will send 3C
        slave_tx_data = 8'hA5;
        // Reset
        #20;
        reset = 1'b0;
        // Start SPI transfer
        #10;
        start = 1'b1;
        #10;
        start = 1'b0;
        // Wait until transfer is complete
        wait(done);
        // Display result
        #1;
        $display("");
        $display("====================================");
        $display("       SPI TRANSFER COMPLETE");
        $display("====================================");
        $display("TX DATA  = %h", tx_data);
        $display("RX DATA  = %h", rx_data);
        $display("BUSY     = %b", busy);
        $display("DONE     = %b", done);
        $display("====================================");
        $display("");
        // Check received data
        if (rx_data == 8'hA5)
            $display("TEST PASSED: RX DATA = A5");
        else
            $display("TEST FAILED: Expected A5, Got %h",
                     rx_data);
        #20;
        $finish;
    end
    initial begin
        $monitor(
            "TIME=%0t | RESET=%b | START=%b | CS_N=%b | SCLK=%b | MOSI=%b | MISO=%b | RX=%h | BUSY=%b | DONE=%b",
            $time,
            reset,
            start,
            cs_n,
            sclk,
            mosi,
            miso,
            rx_data,
            busy,
            done
        );
    end
    initial begin
        $dumpfile("spi_protocol.vcd");
        $dumpvars(0, spi_protocol_tb);
    end
endmodule
