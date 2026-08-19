module moore_10110(
input clk,
input reset,
input din,
output reg y);
reg [2:0]state,next_state;
parameter s0=3'b000,
s1=3'b001,
s2=3'b010,
s3=3'b011,
s4=3'b100,
s5=3'b101,
s6=3'b110,
s7=3'b111;
always@(posedge clk or posedge reset)begin
if(reset)
state<=s0;
else
state<=next_state;
end
always@(*)begin
case (state)
s0:begin
if(din)
next_state=s1;
else
next_state=s0;
end
s1:begin
if(din)
next_state = s1;
else
next_state=s2;
end
s2: begin
            if (din)
                next_state = s3;
            else
                next_state = s0;end
s3: begin
            if (din)
                next_state = s4;
            else
                next_state = s0;
end
s4: begin
            if (din)
                next_state = s1;
            else
                next_state = s5;
end
s5: begin
            if (din)
                next_state = s0;
            else
                next_state = s3;
end
default:next_state=s0;
endcase
end
always @(*) begin
    if (state == s5)
        y = 1'b1;
    else
        y = 1'b0;
end
endmodule

