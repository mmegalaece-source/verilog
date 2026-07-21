module odd_parity_generator_tb;
reg [3:0] data;
wire parity;
odd_parity_generator uut(
    .data(data),
    .parity(parity)
);
initial begin
$monitor("Time=%0t data=%b parity=%b",$time, data, parity);
data = 4'b0000;#10;
data = 4'b0001;#10;
data = 4'b1010;#10;
data = 4'b1111;#10;
data = 4'b1001;#10;
$finish;
end
endmodule
