module tb_blocking_example;
wire a;
wire b;
wire c;
blocking_example dut(
    .a(a),
    .b(b),
    .c(c)
);
initial begin
$monitor("Time=%0t a=%b b=%b c=%b", $time, a, b, c);
#5;
$finish;
end
endmodule
