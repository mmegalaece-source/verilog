module traffic(
input [1:0] state,
output reg red,
output reg yellow,
output reg green
);
always @(*)
begin
red=0;
yellow=0;
green=0;
if(state==2'b00)
    red=1;

else if(state==2'b01)
    green=1;

else if(state==2'b10)
    yellow=1;
end
endmodule
