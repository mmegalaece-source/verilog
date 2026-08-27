module fifo_tb;
reg clk;
reg rst;
reg wr_ena;
reg rd_ena;
reg [7:0] data_in;
wire full;
wire empty;
wire [7:0] data_out;
fifo uut (
    .clk(clk),
    .rst(rst),
    .wr_ena(wr_ena),
    .rd_ena(rd_ena),
    .data_in(data_in),
    .full(full),
    .empty(empty),
    .data_out(data_out)
);
always #5 clk = ~clk;
initial begin
    clk = 0;
    rst = 0;
    wr_ena = 0;
    rd_ena = 0;
    data_in = 8'd0;
    #10;
    rst = 1;
    wr_ena = 1;
    data_in = 8'h11;
    #10;
    data_in = 8'h22;
    #10;
    data_in = 8'h33;
    #10;
    data_in = 8'h44;
    #10;
    data_in = 8'h55;
    #10;
    data_in = 8'h66;
    #10;
    data_in = 8'h77;
    #10;
    data_in = 8'h88;
    #10;
    wr_ena = 0;
    #10;
    rd_ena = 1;
  #10; 
    rd_ena = 0;
    #10;
    $finish;
end
initial begin
    $monitor("TIME=%0t CLK=%b RST=%b WR=%b RD=%b DATA_IN=%h DATA_OUT=%h FULL=%b EMPTY=%b",
             $time, clk, rst, wr_ena, rd_ena,
             data_in, data_out, full, empty);
end
endmodule
