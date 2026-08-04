module door_lock(input clk,reset,in,close,output unlock);
parameter LOCK=3'd0,
S1=3'd1,
S2=3'd2,
S3=3'd3,
UNLOCK=3'd4;
reg[2:0]state,next_state;
always@(posedge clk)begin
	if(reset)
		state<=LOCK;
	else
		state<=next_state;
end
always@(*)begin
case(state)
	LOCK:next_state=(in)?S1:LOCK;
	S1:next_state=(in)?S2:S1;
	S2:next_state=(in)?S3:LOCK;
	S3:next_state=(in)?UNLOCK:LOCK;
	UNLOCK:next_state=(close)?LOCK:UNLOCK;
default:next_state=LOCK;
endcase
end
assign unlock=(state==UNLOCK);
endmodule


