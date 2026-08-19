`timescale 1ns/1ps

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

    // DUT
    spi_protocol dut (
        .clk      (clk),
        .reset    (reset),
        .start    (start),
        .tx_data  (tx_data),
        .miso     (miso),
        .sclk     (sclk),
        .mosi     (mosi),
        .cs_n     (cs_n),
        .rx_data  (rx_data),
        .busy     (busy),
        .done     (done)
    );

    // System clock
    always #5 clk = ~clk;


    // Slave data
    reg [7:0] slave_data;
    integer i;


    initial begin

        // Initial values
        clk       = 1'b0;
        reset     = 1'b1;
        start     = 1'b0;
        tx_data   = 8'h00;
        miso      = 1'b0;

        slave_data = 8'hA5;


        // Reset
        #20;
        reset = 1'b0;

        // Master transmit data
        tx_data = 8'hA5;

        // Start SPI transfer
        #10;
        start = 1'b1;

        #10;
        start = 1'b0;


        // ----------------------------------------
        // SPI Slave
        // Mode 1:
        // Rising edge  -> Master launches MOSI
        // Falling edge -> Slave launches MISO
        // ----------------------------------------

        wait(cs_n == 1'b0);

        // Send first MISO bit
        miso = slave_data[7];

        for (i = 7; i >= 0; i = i - 1) begin

            // Wait for rising edge
            @(posedge sclk);

            // Mode 1:
            // MISO changes on falling edge
            @(negedge sclk);

            if (i > 0)
                miso = slave_data[i-1];
        end


        // Wait until transfer is complete
        wait(done == 1'b1);

        #20;

        $display("--------------------------------");
        $display("SPI MODE 1 TRANSFER COMPLETE");
        $display("Master TX Data = %h", tx_data);
        $display("Slave  TX Data = %h", slave_data);
        $display("Master RX Data = %h", rx_data);
        $display("--------------------------------");

        #20;
        $finish;

    end


    // Generate waveform
    initial begin

        $dumpfile("spi_protocol.vcd");
        $dumpvars(0, spi_protocol_tb);

    end

endmodule
