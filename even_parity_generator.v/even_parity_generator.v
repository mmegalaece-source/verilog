module even_parity_generator(
    input [3:0] data,
    output parity
);
assign parity = data[3] ^ data[2] ^ data[1] ^ data[0];
endmodule
