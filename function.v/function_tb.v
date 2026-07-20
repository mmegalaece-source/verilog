module tb_function_example;

reg [3:0] a;
reg [3:0] b;
wire [3:0] max;

function_example uut (
    .a(a),
    .b(b),
    .max(max)
);

initial
begin
    a = 4'd5;
    b = 4'd3;
    #10;

    a = 4'd2;
    b = 4'd9;
    #10;

    a = 4'd7;
    b = 4'd7;
    #10;

    $finish;
end

initial
begin
    $monitor("Time=%0t a=%d b=%d max=%d",
              $time,a,b,max);
end

endmodule
