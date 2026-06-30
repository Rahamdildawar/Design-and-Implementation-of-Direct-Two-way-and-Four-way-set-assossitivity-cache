`timescale 1ns / 1ps
module direct_map_cache(
   input clk,
   input rst,
   input read_enable,
   input [31:0] address,
   output reg [31:0] data_out,
   output reg hit
);
    
reg mem_valid [7:0];
reg [26:0] mem_tag [7:0];
reg [31:0] mem_data [7:0];

wire [26:0] tag;
wire [2:0]  index;
wire [1:0]  offset;

wire [31:0] memory_data_out;
wire cache_hit;

address_decoder Addr_dec(
   .address(address),
   .tag(tag),
   .index(index),
   .offset(offset)
);

main_memory Main_mem(
   .address(address),
   .data_out(memory_data_out)
);

tag_comparater comparater(
   .cpu_tag(tag),
   .cache_tag(mem_tag[index]),
   .valid(mem_valid[index]),
   .hit(cache_hit)
);

integer i;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        hit <= 1'b0;
        data_out <= 32'b0;
        for (i = 0; i < 8; i = i + 1) begin
            mem_valid[i] <= 1'b0;
            mem_tag[i]   <= 27'b0;
            mem_data[i]  <= 32'b0;
        end
    end 
    else if (read_enable) begin
        if (cache_hit) begin
            
            hit      <= 1'b1;
            data_out <= mem_data[index];
        end 
        else begin
            
            hit              <= 1'b0;
            data_out         <= memory_data_out;
            
            mem_valid[index] <= 1'b1; 
            mem_tag[index]   <= tag;
            mem_data[index]  <= memory_data_out;
        end
    end 
    else begin
    
        hit <= 1'b0;
    end
end

endmodule