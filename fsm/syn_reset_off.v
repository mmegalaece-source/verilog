module top_module(
    input clk,
    input reset,  
    input j,
    input k,
    output out
);

    parameter OFF = 0, ON = 1;
    reg state, next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            OFF: begin
                case ({j,k})
                    2'b00: next_state = OFF;
                    2'b01: next_state = OFF;
                    2'b10: next_state = ON;
                    2'b11: next_state = ON;
                endcase
            end

            ON: begin
                case ({j,k})
                    2'b00: next_state = ON;
                    2'b01: next_state = OFF;
                    2'b10: next_state = ON;
                    2'b11: next_state = OFF;
                endcase
            end

            default: next_state = OFF;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule
