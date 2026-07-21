module nonblocking_example(
    output reg a,
    output reg b,
    output reg c
);
initial begin
a <= 1'b0;
b <= 1'b1;#1;
c <= b;
b <= a;
a <= c;
end
endmodule
