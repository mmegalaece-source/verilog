module fifo_memory #(
parameter data_width=8,
parameter addr_width=3)
(input wr_clk,
input rd_clk,
input rst_n,
input wr_en,
input rd_en,
input full,
input empty,
input [addr_width-1:0]wr_addr,
input [addr_width-1:0]rd_addr,
input [data_width-1:0]wr_data,
output reg [data_width-1:0]rd_data);

localparam depth=1<<addr_width;
reg [data_width-1:0] mem[0:depth-1];

//write operation
always@(posedge wr_clk)begin
if(rst_n && wr_en && !full)
mem[wr_addr] <= wr_data;
end

//read operation
always@(posedge rd_clk or negedge rst_n)begin
if(!rst_n)
rd_data<=0;
else if(rd_en && !empty)
rd_data <= mem[rd_addr];
end
endmodule


// write pointer handler

module write_pointer #(
parameter addr_width=3)(
input wr_clk,
input rst_n,
input wr_en,
input [addr_width:0] rd_gray_sync,

output reg [addr_width:0] wr_bin,
output reg [addr_width:0] wr_gray,
output reg full);

wire [addr_width:0]wr_bin_next;
wire [addr_width:0]wr_gray_next;
wire full_next;

assign wr_bin_next = wr_bin+(wr_en & !full);
assign wr_gray_next = (wr_bin_next>>1)^wr_bin_next;
assign full_next = (wr_gray_next == {~rd_gray_sync[addr_width:addr_width-1],rd_gray_sync[addr_width-2:0]});


always@(posedge wr_clk or negedge rst_n)begin
if(!rst_n)begin
wr_bin <= 0;
wr_gray <= 0;
full <= 0;
end
else begin
wr_bin <= wr_bin_next;
wr_gray <= wr_gray_next;
full <= full_next;
end
end
endmodule

//read pointer handler

module read_pointer #(
parameter addr_width=3)(
input rd_clk,
input rd_en,
input rst_n,
input [addr_width:0] wr_gray_sync,
output reg [addr_width:0] rd_bin,
output reg [addr_width:0] rd_gray,
output reg empty);

wire [addr_width:0] rd_gray_next;
wire [addr_width:0] rd_bin_next;
wire empty_next;

assign rd_bin_next = rd_bin + ( rd_en & !empty);
assign rd_gray_next = (rd_bin_next>>1) ^ rd_bin_next;
assign empty_next = (rd_gray_next == wr_gray_sync);

always@(posedge rd_clk or negedge rst_n)begin
if(!rst_n)begin
rd_bin <= 0;
rd_gray <= 0;
empty <= 1'b1;
end
else begin
rd_bin <= rd_bin_next;
rd_gray <= rd_gray_next;
empty <= empty_next;
end
end
endmodule


//synchronization

module synchronizer #(
parameter addr_width = 3)
(input clk,
input rst_n,
input [addr_width:0] d_in,
output reg[addr_width:0] d_out);

reg [addr_width:0] sync1;

always@(posedge clk or negedge rst_n)begin
if(!rst_n)begin
sync1 <= 0;
d_out <= 0;
end
else begin
sync1 <= d_in;
d_out <= sync1;
end
end
endmodule

//topmodule

module async_fifo #(
    parameter data_width = 8,
    parameter addr_width = 3)
    (input wr_clk,
    input rd_clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input [data_width-1:0] wr_data,

    output [data_width-1:0] rd_data,
    output full,
    output empty);

    wire [addr_width:0] wr_bin,wr_gray;
    wire [addr_width:0] rd_bin,rd_gray;
    wire [addr_width:0] rd_gray_sync;
    wire [addr_width:0] wr_gray_sync;

    // Write pointer
    write_pointer #(
        .addr_width(addr_width)
    ) wp (
        .wr_clk(wr_clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_gray_sync(rd_gray_sync),
        .wr_bin(wr_bin),
        .wr_gray(wr_gray),
        .full(full)
    );

    // Read pointer
    read_pointer #(
        .addr_width(addr_width)
    ) rp (
        .rd_clk(rd_clk),
        .rst_n(rst_n),
        .rd_en(rd_en),
        .wr_gray_sync(wr_gray_sync),
        .rd_bin(rd_bin),
        .rd_gray(rd_gray),
        .empty(empty)
    );

    // Synchronize read pointer into write clock domain
    synchronizer #(
        .addr_width(addr_width)
    ) sync_read_pointer (
        .clk(wr_clk),
        .rst_n(rst_n),
        .d_in(rd_gray),
        .d_out(rd_gray_sync)
    );

    // Synchronize write pointer into read clock domain
    synchronizer #(
        .addr_width(addr_width)
    ) sync_write_pointer (
        .clk(rd_clk),
        .rst_n(rst_n),
        .d_in(wr_gray),
        .d_out(wr_gray_sync)
    );

    // FIFO memory
    fifo_memory #(
        .data_width(data_width),
        .addr_width(addr_width)
    ) memory (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .full(full),
        .rd_en(rd_en),
        .empty(empty),
        .wr_addr(wr_bin[addr_width-1:0]),
        .rd_addr(rd_bin[addr_width-1:0]),
        .wr_data(wr_data),
        .rd_data(rd_data)
    );
endmodule
