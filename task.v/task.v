module alu(
input [2:0]a,
input [2:0]b,
output reg [3:0]add,
output reg [3:0]sub,
output reg [3:0]multi,
output reg [3:0]div);
task add1;
input [2:0]x,y;
output [3:0]z;
begin
z=x+y;
end
endtask
task sub1;
input [2:0]x,y;
output [3:0]z;
begin
z=x-y;
end
endtask
task multi1;
input [2:0]x,y;
output [3:0]z;
begin
z=x*y;
end
endtask
task div1;
input [2:0]x,y;
output [3:0]z;
begin
z=x/y;
end 
endtask
always@(*)begin
add1(a,b,add);
sub1(a,b,sub);
multi1(a,b,multi);
div1(a,b,div);
end
endmodule
