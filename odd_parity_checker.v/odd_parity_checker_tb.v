module odd_parity_checker_tb;
reg [3:0] data;
reg parity;
wire error;
odd_parity_checker uut(
    .data(data),
    .parity(parity),
    .error(error)
);
initial begin
$monitor("Time=%0t data=%b parity=%b error=%b",$time, data, parity, error);
data = 4'b0000;
parity = 1;#10;
data = 4'b1010;
parity = 1;#10;
data = 4'b1111;
parity = 1;#10;
data = 4'b1001;
parity = 1;#10;
data = 4'b1010;
parity = 0;#10;
$finish;
end
endmodule
