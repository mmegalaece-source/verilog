module tb_even_number;
reg [3:0] a;
wire even;
even_number uut (.a(a),.even(even));
initial begin
    $monitor("Time=%0t a=%d even=%b", $time, a, even);
a = 4'd2;   #10;
a = 4'd5;   #10;
a = 4'd8;   #10;
a = 4'd11;  #10;
a = 4'd14;  #10;
$finish;
end
endmodule
