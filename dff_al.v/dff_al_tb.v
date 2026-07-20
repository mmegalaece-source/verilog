module dff_al_tb;
reg clk,reset,d;
wire q;
dff_al uut(.clk(clk),.reset(reset),.d(d),.q(q));
always #5 clk=~clk;
initial begin
    clk = 0;
    reset = 0;
    d = 0;
    #10;
    reset = 1;
    #10 d = 1;
    #10 d = 0;
    #10 d = 1;
    #10 reset = 0;
    #10 reset = 1;
    #20 $finish;
end
initial begin
$monitor("clk=%b reset=%b d=%b q=%b",clk,reset,d,q);
end
endmodule
