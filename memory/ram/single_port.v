module single_port(input clk,wr,input [2:0] addr,input [7:0] data_in,output reg [7:0] data_out);
reg [7:0]mem[7:0];
always @(posedge clk) begin
if(wr) 
mem[addr]<=data_in;
else
data_out<=mem[addr];
end
endmodule
