module tff_tb;
reg clk;
reg reset;
reg t;
wire q;
tff uut(
    .clk(clk),
    .reset(reset),
    .t(t),
    .q(q)
);
initial begin
    clk = 0;
    forever #2 clk = ~clk;
end
initial begin
    reset = 1;
    t = 0;
    #4;
    reset = 0;
    #4;
    t = 1;
    #8;
    t = 0;
    #8;
    t = 1;
    #10;
    $finish;
end
initial begin
    $monitor("time=%0t clk=%b reset=%b t=%b q=%b",
              $time,clk,reset,t,q);
end
endmodule
