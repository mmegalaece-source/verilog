module mealy_111(
    input clk,
    input reset,
    input in,
    output reg y
);

reg [1:0] state, next_state;

parameter s0 = 2'b00,   // No 1 received
          s1 = 2'b01,   // One 1 received
          s2 = 2'b10;   // Two 1s received

// State register
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= s0;
    else
        state <= next_state;
end

// Next-state and output logic
always @(*) begin
    y = 1'b0;

    case (state)

        s0: begin
            if (in)
                next_state = s1;
            else
                next_state = s0;
        end

        s1: begin
            if (in)
                next_state = s2;
            else
                next_state = s0;
        end

        s2: begin
            if (in) begin
                next_state = s2;
                y = 1'b1;       // 111 detected
            end
            else begin
                next_state = s0;
            end
        end

        default: begin
            next_state = s0;
            y = 1'b0;
        end

    endcase
end

endmodule
