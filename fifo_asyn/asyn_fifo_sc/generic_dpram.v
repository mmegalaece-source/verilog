
module generic_dpram #(
  parameter aw = 8,
  parameter dw = 16
)(
  input             rclk,
  input             rrst,
  input             rce,
  input             oe,
  input  [aw-1:0]   raddr,
  output reg [dw-1:0] dout,

  input             wclk,
  input             wrst,
  input             wce,
  input             we,
  input  [aw-1:0]   waddr,
  input  [dw-1:0]   din
);

  localparam DEPTH = (1 << aw);

  reg [dw-1:0] mem [0:DEPTH-1];

  // Write port
  always @(posedge wclk) begin
    if (wrst)
      ;
    else if (wce && we)
      mem[waddr] <= din;
  end

  // Read port
  always @(posedge rclk) begin
    if (rrst)
      dout <= {dw{1'b0}};
    else if (rce && oe)
      dout <= mem[raddr];
  end

endmodule

