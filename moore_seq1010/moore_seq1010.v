module moore_seq(input clk,rst,x,output reg y);
parameter
s0=3'b000,
s1=3'b001,
s2=3'b010,
s3=3'b011,
s4=3'b100;
reg[2:0] present_state,next_state;
always@(posedge clk or posedge rst)
begin
if(rst)
present_state <= s0;
else
present_state <= next_state;
end
always@(*)
begin
case(present_state)
s0:
if(x)
next_state=s1;
else
next_state=s0;
s1:
if(x)
next_state=s1;
else
next_state=s2;
s2:
if(x)
next_state=s3;
else
next_state=s0;
s3:
if(x)
next_state=s1;
else
next_state=s4;
s4:
if(x)
next_state=s3;
else
next_state=s0;
endcase
end
always@(*)
begin
case(present_state)
s4:y=1'b1;
default:y=1'b0;
endcase
end
endmodule
