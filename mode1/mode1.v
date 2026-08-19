module spi_protocol (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [7:0] tx_data,
    input  wire       miso,

    output reg        sclk,
    output reg        mosi,
    output reg        cs_n,
    output reg [7:0]  rx_data,
    output reg        busy,
    output reg        done
);

    localparam ST_IDLE     = 2'd0;
    localparam ST_ASSERT   = 2'd1;
    localparam ST_TRANSFER = 2'd2;
    localparam ST_DONE     = 2'd3;

    reg [1:0] state;
    reg [7:0] tx_shift;
    reg [7:0] rx_shift;
    reg [2:0] bit_cnt;

    always @(posedge clk) begin

        if (reset) begin

            state    <= ST_IDLE;
            sclk     <= 1'b0;
            mosi     <= 1'b0;
            cs_n     <= 1'b1;
            rx_data  <= 8'h00;
            busy     <= 1'b0;
            done     <= 1'b0;

            tx_shift <= 8'h00;
            rx_shift <= 8'h00;
            bit_cnt  <= 3'd7;
        end

        else begin

            done <= 1'b0;

            case (state)

                // ==================================
                // IDLE
                // ==================================
                ST_IDLE: begin

                    cs_n <= 1'b1;
                    busy <= 1'b0;
                    sclk <= 1'b0;

                    if (start) begin

                        tx_shift <= tx_data;
                        rx_shift <= 8'h00;
                        bit_cnt  <= 3'd7;

                        cs_n <= 1'b0;
                        busy <= 1'b1;

                        state <= ST_ASSERT;
                    end
                end


                // ==================================
                // ASSERT
                // ==================================
                ST_ASSERT: begin

                    // SPI MODE 1
                    // CPOL = 0
                    // CPHA = 1
                    //
                    // SCLK idle = LOW
                    // Rising edge  = LAUNCH
                    // Falling edge = SAMPLE

                    sclk <= 1'b0;
                    cs_n <= 1'b0;

                    // First data bit
                    mosi <= tx_shift[7];

                    state <= ST_TRANSFER;
                end


                // ==================================
                // TRANSFER
                // ==================================
                ST_TRANSFER: begin

                    // --------------------------------
                    // Rising Edge
                    // MODE 1 -> LAUNCH DATA
                    // --------------------------------
                    if (sclk == 1'b0) begin

                        sclk <= 1'b1;

                    end


                    // --------------------------------
                    // Falling Edge
                    // MODE 1 -> SAMPLE DATA
                    // --------------------------------
                    else begin

                        sclk <= 1'b0;

                        // Sample MISO
                        rx_shift <= {
                            rx_shift[6:0],
                            miso
                        };

                        // Check final bit
                        if (bit_cnt == 3'd0) begin

                            state <= ST_DONE;

                        end

                        else begin

                            bit_cnt <= bit_cnt - 3'd1;

                            // Shift TX data
                            tx_shift <= {
                                tx_shift[6:0],
                                1'b0
                            };

                            // Send next bit
                            mosi <= tx_shift[6];
                        end
                    end
                end


                // ==================================
                // DONE
                // ==================================
                ST_DONE: begin

                    cs_n <= 1'b1;
                    busy <= 1'b0;

                    sclk <= 1'b0;
                    mosi <= 1'b0;

                    // Store received data
                    rx_data <= rx_shift;

                    done <= 1'b1;

                    state <= ST_IDLE;
                end


                // ==================================
                // DEFAULT
                // ==================================
                default: begin

                    state <= ST_IDLE;
                    cs_n  <= 1'b1;
                    busy  <= 1'b0;
                    sclk  <= 1'b0;
                    mosi  <= 1'b0;

                end

            endcase
        end
    end

endmodule
