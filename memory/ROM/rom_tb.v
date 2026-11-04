module rom_8x8_tb;

reg [2:0] addr;
wire [7:0] data;

rom uut (
    .addr(addr),
    .data(data)
);

initial begin
	  $monitor("Time=%0t | Address=%b | Data=%h",
              $time, addr, data);

    addr = 3'b000;
    #10;

    addr = 3'b001;
    #10;

    addr = 3'b010;
    #10;

    addr = 3'b011;
    #10;

    addr = 3'b100;
    #10;

    addr = 3'b101;
    #10;

    addr = 3'b110;
    #10;

    addr = 3'b111;
    #10;

    $finish;

end

endmodule
