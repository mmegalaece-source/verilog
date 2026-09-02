/* module fifo_tb;
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
    .full(full),
    .empty(empty),
    .data_in(data_in),
    .data_out(data_out)
);
always #5 clk = ~clk;
initial begin
    clk     = 0;
    rst     = 0;
    wr_ena  = 0;
    rd_ena  = 0;
    data_in = 8'd0;
    #10;
    rst = 1;
    wr_ena = 1;
    data_in = 8'd10; #10;
    data_in = 8'd20; #10;
    data_in = 8'd30; #10;
    data_in = 8'd40; #10;
    data_in = 8'd50; #10;
    data_in = 8'd60; #10;
    data_in = 8'd70; #10;
    data_in = 8'd80; #10;
    wr_ena = 0;
    #10;
    rd_ena = 1;
    #10;   
    #10;   
    #10;   
    #10;   
    #10;   
    #10;   
    #10;   
    #10;   
    rd_ena = 0;
    #10;
    $finish;
end
initial begin
    $monitor(
        "TIME=%0t  CLK=%b  RST=%b  WR=%b  RD=%b  DATA_IN=%d  DATA_OUT=%d  FULL=%b  EMPTY=%b",
        $time,
        clk,
        rst,
        wr_ena,
        rd_ena,
        data_in,
        data_out,
        full,
        empty
    );
end
endmodule */


`timescale 1ns/1ps

module fifo_sync_tb;
    reg clk;
    reg cs;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;

    fifo_sync uut (
        .clk(clk),
        .cs(cs),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("TIME=%0t | CLK=%b | CS=%b | WR_EN=%b | RD_EN=%b | DATA_IN=%h | DATA_OUT=%h | WR_P=%b | RD_P=%b | FULL=%b | EMPTY=%b",
                  $time, clk, cs, wr_en, rd_en,
                  data_in, data_out,
                  uut.wr_p, uut.rd_p,
                  full, empty);
    end
    initial begin

        clk     = 0;
        cs      = 0;
        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 8'h00;
        #10;

        rst_n = 1;
        cs    = 1;
        #10;

        wr_en   = 1;
        data_in = 8'hC1;
        #10;
        data_in = 8'h35;
        #10;
        data_in = 8'h40;
        #10;
        data_in = 8'h50;
        #10;
        data_in = 8'h13;
        #10;
        data_in = 8'hA5;
        #10;
        data_in = 8'h6B;
        #10;
        data_in = 8'hF3;
        #10;
        wr_en = 0;
        #10;
        rd_en = 1;
        #80;
        rd_en = 0;
        #20;
        $finish;
    end
    initial begin
        $dumpfile("fifo_sync.vcd");
        $dumpvars(0, fifo_sync_tb);
    end

endmodule
