module tx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input clk,
    input reset,
    input ena,
    input [7:0] data_in,
    output reg tx,
    output reg busy
);
localparam CLK_PER_BIT = CLK_FREQ / BAUD_RATE;
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;
reg [1:0] state, next_state;
reg [3:0] bit_count;
reg [7:0] shift_reg;
reg [15:0] baud_count;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        state      <= IDLE;
        tx         <= 1'b1;
        busy       <= 1'b0;
        baud_count <= 16'd0;
        bit_count  <= 4'd0;
        shift_reg  <= 8'd0;
    end
    else begin
        state <= next_state;
        case (state)
        IDLE: begin
            tx         <= 1'b1;
            busy       <= 1'b0;
            baud_count <= 16'd0;
            bit_count  <= 4'd0;
            if (ena) begin
                shift_reg <= data_in;
                busy      <= 1'b1;
            end
        end

	START: begin
            tx   <= 1'b0;
            busy <= 1'b1;
            if (baud_count == CLK_PER_BIT - 1) begin
                baud_count <= 16'd0;
            end
            else begin
                baud_count <= baud_count + 1'b1;
            end
        end

	DATA: begin
            tx   <= shift_reg[bit_count];
            busy <= 1'b1;
            if (baud_count == CLK_PER_BIT - 1) begin
                baud_count <= 16'd0;
                if (bit_count == 4'd7) begin
                    bit_count <= 4'd0;
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
            tx   <= 1'b1;
            busy <= 1'b1;
            if (baud_count == CLK_PER_BIT - 1) begin
                baud_count <= 16'd0;
                busy       <= 1'b0;
            end
            else begin
                baud_count <= baud_count + 1'b1;
            end
        end
        default: begin
            state <= IDLE;
            tx    <= 1'b1;
            busy  <= 1'b0;
        end
        endcase
    end
end

always @(*) begin
    next_state = state;
    case (state)
    IDLE: begin
        if (ena)
            next_state = START;
    end

    START: begin
        if (baud_count == CLK_PER_BIT - 1)
            next_state = DATA;
    end

    DATA: begin
        if (baud_count == CLK_PER_BIT - 1) begin
            if (bit_count == 4'd7)
                next_state = STOP;
            else
                next_state = DATA;
        end
    end

    STOP: begin
        if (baud_count == CLK_PER_BIT - 1)
            next_state = IDLE;
    end
    default: begin
        next_state = IDLE;
    end
    endcase
end
endmodule
