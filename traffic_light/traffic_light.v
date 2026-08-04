module traffic_light(input clk,reset,output reg [1:0]light);
parameter RED=2'd0,
GREEN=2'd1,
YELLOW=2'd2;
reg[1:0]state,next_state;
always@(posedge clk)begin
if(reset)
state<=RED;
else
state<=next_state;
end
always@(*)begin
case(state)
RED:
	next_state=GREEN;
GREEN:
	next_state=YELLOW;
YELLOW:
	next_state=RED;
default:next_state=RED;
endcase
end
always@(*)begin
	light=state;
end
endmodule
