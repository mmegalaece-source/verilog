module atm_tb;
reg clk;
reg reset;
reg card;
reg pin;
reg withdraw;
reg done;
reg remove;
wire cash;
atm uut(.clk(clk),.reset(reset),.card(card),.pin(pin),.withdraw(withdraw),.done(done),.remove(remove),.cash(cash));
always #5 clk=~clk;
initial begin
	clk=0;
	reset=1;
	card=0;
	pin=0;
	withdraw=0;
	done=0;
	remove=0;
	#10;
	reset=0;
	card=1;
	#10;
	card=0;
	#10;
	pin=1;
	#10
	pin=0;
	#10;
	withdraw=1;
	#10;
	withdraw=0;
	#10;
	done=1;
	#10;
	done=0;
	#10;
	remove=1;
	#10;
	remove=0;
	#20;
$finish;
end
initial begin
$monitor("time=%0t clk=%b reset=%b card=%b pin=%b withdraw=%b done=%b remove=%b cash=%b",$time,clk,reset,card,pin,withdraw,done,remove,cash);
end
endmodule


