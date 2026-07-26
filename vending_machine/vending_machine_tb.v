module vending_machine_tb;
reg clk;
reg rst;
reg I;
reg J;
wire X;
wire Y;
vending_machine dut (
    .clk(clk),
    .rst(rst),
    .I(I),
    .J(J),
    .X(X),
    .Y(Y)
);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial begin
    // Initial values
    rst = 1;
    I = 0;
    J = 0;

    // Reset
    #10;
    rst = 0;
    // Insert Rs.1 coin (I=0,J=1)
    #10;
    I = 0;
    J = 1;
    // Insert Rs.2 coin (I=1,J=0)
    #10;
    I = 1;
    J = 0;
    // No coin
    #10;
    I = 0;
    J = 0;
    #10;
    I = 1;
    J = 0;
    // Insert Rs.2 coin
    #10;
    I = 1;
    J = 0;
    // No coin
    #10;
    I = 0;
    J = 0;
    #10;
    I = 0;
    J = 1;
    #10;
    I = 0;
    J = 1;
    #10;
    I = 0;
    J = 1;
    #20;
    $finish;
end
initial begin
    $monitor("Time=%0t | clk=%b | rst=%b | I=%b | J=%b | X=%b | Y=%b | State=%b",
              $time, clk, rst, I, J, X, Y, dut.present_state);
end
endmodule
