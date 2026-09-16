`timescale 1ns/1ps

module topmodule_tb;

reg clk;
reg reset;

reg tx_start;
reg [7:0] tx_data_in;

wire tx_pin;
wire rx_pin;
wire tx_busy;

wire [7:0] rx_data_out;
wire rx_valid;


//========================================
// TX -> RX LOOPBACK
//========================================

assign rx_pin = tx_pin;


//========================================
// DUT
//========================================

topmodule #(
    .CLK_FREQ  (50000000),
    .BAUD_RATE (9600)
) uut (
    .clk         (clk),
    .reset       (reset),

    .tx_pin      (tx_pin),
    .rx_pin      (rx_pin),

    .tx_start    (tx_start),
    .tx_data_in  (tx_data_in),
    .tx_busy     (tx_busy),

    .rx_data_out (rx_data_out),
    .rx_valid    (rx_valid)
);


//========================================
// 50 MHz CLOCK
//========================================

always #10 clk = ~clk;


//========================================
// TEST
//========================================

initial begin

    $dumpfile("uart.vcd");
    $dumpvars(0, topmodule_tb);

    clk        = 1'b0;
    reset      = 1'b0;
    tx_start   = 1'b0;
    tx_data_in = 8'h00;

    // Reset
    #100;
    reset = 1'b1;

    #100;

    //====================================
    // SEND A5
    //====================================

    tx_data_in = 8'hA5;
    tx_start   = 1'b1;

    #20;
    tx_start   = 1'b0;

    $display("TX Started");
    $display("TX Data = %h", tx_data_in);


    //====================================
    // WAIT FOR RX VALID
    //====================================

    @(posedge rx_valid);

    $display("RX Valid = %b", rx_valid);
    $display("RX Data  = %h", rx_data_out);


    //====================================
    // CHECK RESULT
    //====================================

    if (rx_data_out == 8'hA5)
        $display("TEST PASSED");
    else
        $display("TEST FAILED");

    #100;
    $finish;
end
endmodule
