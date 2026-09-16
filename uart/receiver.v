module receiver #(
    parameter CLK_FREQ  = 50000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data_out,
    output reg rx_valid
);
localparam CLK_PER_BIT = CLK_FREQ / BAUD_RATE;
localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [15:0] baud_count;
reg [3:0] bit_count;
reg [7:0] shift_reg;
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        state      <= IDLE;
        baud_count <= 16'd0;
        bit_count  <= 4'd0;
        shift_reg  <= 8'd0;
        data_out   <= 8'd0;
        rx_valid   <= 1'b0;
    end
    else begin
        rx_valid <= 1'b0;
        case (state)

		IDLE: begin

            baud_count <= 16'd0;
            bit_count  <= 4'd0;

            if (rx == 1'b0) begin
                state      <= START;
                baud_count <= 16'd0;
            end

        end

	START: begin

            if (baud_count == (CLK_PER_BIT/2) - 1) begin
                baud_count <= 16'd0;
                if (rx == 1'b0) begin
                    state     <= DATA;
                    bit_count <= 4'd0;
                end
                else begin
                    state <= IDLE;
                end
            end
            else begin
                baud_count <= baud_count + 1'b1;
            end
        end

	DATA: begin

            if (baud_count == CLK_PER_BIT - 1) begin
                baud_count <= 16'd0;
                shift_reg[bit_count] <= rx;
                if (bit_count == 4'd7) begin
                    bit_count <= 4'd0;
                    state     <= STOP;
                end
                else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
            else begin
                baud_count <= baud_count + 1'b1;
            end
        end

	STOP: begin

            if (baud_count == CLK_PER_BIT - 1) begin
                baud_count <= 16'd0;
                if (rx == 1'b1) begin
                    data_out <= shift_reg;
                    rx_valid <= 1'b1;
                end
                state <= IDLE;
            end
            else begin
                baud_count <= baud_count + 1'b1;
            end
        end
        default: begin
            state      <= IDLE;
            baud_count <= 16'd0;
            bit_count  <= 4'd0;
        end
        endcase
    end
end
endmodule
