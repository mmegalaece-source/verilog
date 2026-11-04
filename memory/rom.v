module rom(input [2:0] addr,output [7:0] data);
reg [7:0] mem[7:0];
initial begin
mem[0]=8'h10;
mem[1]=8'h15;
mem[2]=8'h20;
mem[3]=8'h25;
mem[4]=8'h30;
mem[5]=8'h35;
mem[6]=8'h40;
mem[7]=8'h45;
end
assign data=mem[addr];
endmodule
