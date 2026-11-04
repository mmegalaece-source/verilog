module dual_port(
input clk,rst,
input we_a,
input [2:0] addr_a,
input [7:0] datain_a,
input we_b,
input [2:0] addr_b,
input [7:0] datain_b,
output reg [7:0]dataout_a,
output reg [7:0] dataout_b
);
reg [7:0]mem[7:0];
integer i;
always @(posedge clk) begin
if(rst) begin
for(i=0;i<8;i=i+1)
mem[i]<=0;
dataout_a<=8'b0;
end
else begin
if(we_a) 
mem[addr_a]<=datain_a;
else
dataout_a<=mem[addr_a];
end
end

always @(posedge clk) begin
if(rst) begin
for(i=0;i<8;i=i+1)
mem[i]<=0;
dataout_b<=8'b0;
end
else begin
if(we_b) 
mem[addr_b]<=datain_b;
else
dataout_b<=mem[addr_b];
end
end

endmodule
