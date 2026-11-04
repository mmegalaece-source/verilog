module single_port_tb();
reg clk,wr;
reg [7:0] in;
reg [2:0] addr;
wire [7:0] out;

single_port uut ( .clk(clk),.wr(wr),.data_in(in),.addr(addr),.data_out(out));
initial begin
clk=0;
forever #10 clk=~clk;
end

initial begin
	  $dumpfile("single_port.vcd");
        $dumpvars(0, single_port_tb);
//write 0xA5 into address 2
addr=3'b010;
in=8'hA5;
wr=1;

#20;
wr=0;
#20;
$display("Read from address reg 2:%h",out);
#20;
 // write 0x3C into address 5,
addr = 3'b101;
in   = 8'h3C;
wr   = 1;
#20;
wr = 0;
#20;
$display("Read from address reg 5:%h", out);

$finish;
end
endmodule
