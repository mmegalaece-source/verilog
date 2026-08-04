module atm(
input clk,
input reset,
input card,
input pin,
input withdraw,
input done,
input remove,
output cash);
reg[3:0]state,next_state;
parameter IDLE=4'd0,
CARD=4'd1,
PIN_OK=4'd2,
WITHDRAW=4'd3,
EXIT=4'D4;
always@(posedge clk)begin
if(reset)
state<=IDLE;
else
state<=next_state;
end
always@(*)begin
case(state)
IDLE:begin
if(card)
next_state=CARD;
else
next_state=IDLE;
end
CARD:begin
if(pin)
next_state=PIN_OK;
else
next_state=CARD;
end
PIN_OK:begin
if(withdraw)
next_state=WITHDRAW;
else
next_state=PIN_OK;
end
WITHDRAW:begin
if(done)
next_state=EXIT;
else
next_state=WITHDRAW;
end
EXIT:begin
if(remove)
next_state=IDLE;
else
next_state=EXIT;
end
default:next_state=IDLE;
endcase
end
assign cash=(state==WITHDRAW);
endmodule
