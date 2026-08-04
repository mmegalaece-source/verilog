module top_module(
    input clk,
    input reset,    // Synchronous reset to state B
    input in,
    output out
);

    parameter A = 0, B = 1;

    reg present_state, next_state;

    // Next-state logic
    always @(*) begin
        case (present_state)
            A: next_state = (in) ? A : B;
            B: next_state = (in) ? B : A;
            default: next_state = B;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            present_state <= B;
        else
            present_state <= next_state;
    end

    // Output logic
    assign out = (present_state == B);

endmodule
