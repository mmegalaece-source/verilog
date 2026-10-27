
`timescale 1ns/1ps

module tb_dual_clock_fifo_gray;

  reg rd_clk, wr_clk;
  reg rst, clr;
  reg [7:0] din;
  reg we, re;

  wire [7:0] dout;
  wire full, empty;
  wire [1:0] wr_level, rd_level;

  integer i;
  reg [7:0] expected [0:7];

  generic_fifo_dc_gray #(
    .dw(8),
    .aw(3)
  ) dut (
    .rd_clk(rd_clk),
    .wr_clk(wr_clk),
    .rst(rst),
    .clr(clr),
    .din(din),
    .we(we),
    .dout(dout),
    .re(re),
    .full(full),
    .empty(empty),
    .wr_level(wr_level),
    .rd_level(rd_level)
  );

  initial begin
    wr_clk = 0;
    forever #5 wr_clk = ~wr_clk;
  end

  initial begin
    rd_clk = 0;
    forever #7 rd_clk = ~rd_clk;
  end

  initial begin
    rst = 0;
    clr = 0;
    din = 0;
    we = 0;
    re = 0;

    for (i = 0; i < 8; i = i + 1)
      expected[i] = 8'h30 + i;

    // Release active-low reset
    repeat (4) @(negedge wr_clk);
    rst = 1;

    repeat (4) @(negedge rd_clk);

    $display("Starting Gray FIFO test");

    // Write 8 values
    for (i = 0; i < 8; i = i + 1) begin
      @(negedge wr_clk);
      while (full)
        @(negedge wr_clk);

      din = expected[i];
      we = 1;

      @(negedge wr_clk);
      we = 0;

      $display("WRITE: %h", expected[i]);
    end

    // Wait for pointer synchronization
    repeat (6) @(negedge rd_clk);

    // Read 8 values
    for (i = 0; i < 8; i = i + 1) begin
      @(negedge rd_clk);
      while (empty)
        @(negedge rd_clk);

      re = 1;

      @(posedge rd_clk);
      #1;

      if (dout === expected[i])
        $display("PASS: expected=%h received=%h",
                 expected[i], dout);
      else
        $display("FAIL: expected=%h received=%h",
                 expected[i], dout);

      @(negedge rd_clk);
      re = 0;
    end

    $display("Test completed");
    #30;
    $finish;
  end

  initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, tb_dual_clock_fifo_gray);

    #10000;
    $display("TIMEOUT");
    $finish;
  end

endmodule


