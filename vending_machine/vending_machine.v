module vending_machine(
    input clk,
    input rst,
    input I,
    input J,
    output reg X,
    output reg Y
);
parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100;

reg [2:0] present_state, next_state;

//
// State Register
//
always @(posedge clk or posedge rst)
begin
    if (rst)
        present_state <= S0;
    else
        present_state <= next_state;
end

//
// Next State Logic
//
always @(*)
begin
    next_state = present_state;

    case(present_state)

        // Rs.0
        S0:
        begin
            if(I==0 && J==1)
                next_state = S1;      // Rs.1
            else if(I==1 && J==0)
                next_state = S2;      // Rs.2
            else
                next_state = S0;
        end

        // Rs.1
        S1:
        begin
            if(I==0 && J==1)
                next_state = S2;      // Rs.2
            else if(I==1 && J==0)
                next_state = S3;      // Rs.3
            else
                next_state = S1;
        end

        // Rs.2
        S2:
        begin
            if(I==0 && J==1)
                next_state = S3;      // Rs.3
            else if(I==1 && J==0)
                next_state = S4;      // Rs.4
            else
                next_state = S2;
        end

        // Product Dispense
        S3:
            next_state = S0;

        // Product + Return Coin
        S4:
            next_state = S0;
        default:
            next_state = S0;

    endcase
end
always @(*)
begin
    case(present_state)
        S0:
        begin
            X = 1'b0;
            Y = 1'b0;
        end
        S1:
        begin
            X = 1'b0;
            Y = 1'b0;
        end
        S2:
        begin
            X = 1'b0;
            Y = 1'b0;
        end
        S3:
        begin
            X = 1'b1;   // Dispense Product
            Y = 1'b0;
        end
        S4:
        begin
            X = 1'b1;   // Dispense Product
            Y = 1'b1;   // Return Rs.1
        end
        default:
        begin
            X = 1'b0;
            Y = 1'b0;
        end
    endcase
end
endmodule
