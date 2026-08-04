module top_module(
    input clk,
    input areset,
    input x,
    output z
);
    parameter A  = 3'd0,
              B0 = 3'd1,
              B1 = 3'd2;
    reg [2:0] state, next_state;
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end
    always @(*) begin
        case (state)
            A: begin
                if (x)
                    next_state = B1;
                else
                    next_state = A;
            end
            B0: begin
                if (x)
                    next_state = B0;
                else
                    next_state = B1;
            end
            B1: begin
                if (x)
                    next_state = B0;
                else
                    next_state = B1;
            end
            default: next_state = A;
        endcase
    end
    always @(*) begin
        case (state)
            A:  z = 1'b0;
            B0: z = 1'b0;
            B1: z = 1'b1;
            default: z = 1'b0;
        endcase
    end
endmodule
