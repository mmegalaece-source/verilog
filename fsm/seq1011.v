module seq1011(input clk,reset,x,output y);
parameter s1=3'd1,
s2=3'd2,
s3=3'd3,
s4=3'd4,
s5=3'd5;
reg[2:0]state,next_state;
always@(posedge clk)begin
if(reset)
state<=s1;
else
state<=next_state;
end
always@(*)begin
case(state)
s1:next_state=(x)?s2:s1;
s2:next_state=(x)?s2:s3;
s3:next_state=(x)?s4:s1;
s4:next_state=(x)?s5:s3;
s5:next_state=(x)?s2:s3;
default:next_state=s1;
endcase
end
assign y=(state==s5);
endmodule
