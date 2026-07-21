module tb_traffic;
reg [1:0] state;
wire red;
wire yellow;
wire green;
traffic uut(
    .state(state),
    .red(red),
    .yellow(yellow),
    .green(green)
);
initial begin
state = 2'b00;#10;
state = 2'b01;#10;
state = 2'b10;#10;
state = 2'b11;#10;
$finish;
end
initial begin
    $monitor("Time=%0t State=%b Red=%b Yellow=%b Green=%b",$time, state, red, yellow, green);
end
endmodule
