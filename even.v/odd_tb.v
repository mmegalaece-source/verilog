module tb_odd_number;
reg [3:0] a;
wire odd;
odd_number uut (
    .a(a),
    .odd(odd)
);
initial begin
    $monitor("Time=%0t a=%d odd=%b", $time, a, odd);

    a = 4'd3;   #10;
    a = 4'd6;   #10;
    a = 4'd9;   #10;
    a = 4'd12;  #10;
    a = 4'd15;  #10;

    $finish;
end
endmodule
