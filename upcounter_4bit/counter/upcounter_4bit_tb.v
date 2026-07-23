module counter_4bit_tb;
reg clk;
reg rst;
wire [3:0] count;
counter_4bit dut (
    .clk(clk),
    .rst(rst),
    .count(count)
);
always #2 clk = ~clk;
initial begin
    clk = 0;
    rst = 0;      
    #5;
    rst = 1;      
    #7;
    rst = 0;      
    #8;
    rst = 1;      
    #3;
    $finish;
end
initial
begin
    $monitor("Time=%0t clk=%b rst=%b count=%b",
              $time, clk, rst, count);
end
endmodule
