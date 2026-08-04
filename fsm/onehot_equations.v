module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
parameter A=6'd1,
    B=6'd2,
    C=6'd3,
    D=6'd4,
    E=6'd5,
    F=6'd6;
    
    assign Y1=w&(y[0]);
    assign Y3=~w&(y[1] | y[2] | y[4] | y[5]);
endmodule
