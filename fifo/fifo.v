/* module fifo(
input clk,
input rst,
input wr_ena,
input rd_ena,
output full,
output empty,
input [7:0]data_in,
output reg [7:0]data_out);
reg[7:0]mem[7:0];
reg [2:0]wr_pr;
reg [2:0]rd_pr;
reg [3:0]count;
always@(posedge clk or negedge rst)begin
	if(!rst)begin
wr_pr<=3'd0;
rd_pr<=3'd0;
data_out<=8'd0;
count<=4'd0;
end
else begin

	if(wr_ena && !full)begin
mem[wr_pr] <= data_in;
wr_pr <= wr_pr+3'd1;
end

if(rd_ena && !empty)begin
	data_out<=mem[rd_pr];
rd_pr<=rd_pr+3'd1;
end

if((wr_ena && !full) && !(rd_ena && !empty))begin
count<=count+4'd1;
end

else
	if((rd_ena && !empty) && !(wr_ena && !full))begin
count<=count-4'd1;
end

else if((wr_ena && !full)&&(rd_ena && !empty))begin
count<=count;
end

else begin
	count<=count;
end
end
end
assign full=(count==8);
assign empty=(count==0);
endmodule */ 


module fifo_sync (input clk,
	 input cs,
	 input rst_n,
	 input wr_en,
	 input rd_en,
	 input [7:0]data_in,
	 output reg[7:0]data_out,
	 output full,
	 output empty);
 reg [3:0]wr_p;
 reg [3:0]rd_p;
 reg [7:0]mem[7:0];
 always@(posedge clk or negedge rst_n)begin
	 if(!rst_n)begin
		 wr_p<=4'b0000;
	 end
	 else if(cs && wr_en && !full)begin
		 mem[wr_p[2:0]]<=data_in;
		 wr_p<=wr_p + 1'b1;
	 end
 end
 always@(posedge clk or negedge rst_n)begin
	 if(!rst_n)begin
		 rd_p<=4'b0000;
		data_out<=8'b00000000;
	end

	 else if(cs && rd_en && !empty)begin
			 data_out<=mem[rd_p[2:0]];
			 rd_p<=rd_p + 1'b1;
	 end
 end
	
	 assign empty=(wr_p == rd_p);
          assign full = (wr_p[2:0] == rd_p[2:0]) && (wr_p[3] != rd_p[3]);
	  endmodule
