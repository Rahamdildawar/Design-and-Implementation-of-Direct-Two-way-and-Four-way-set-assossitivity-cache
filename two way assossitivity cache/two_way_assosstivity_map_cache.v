`timescale 1ns / 1ps

module two_way_assosstivity_map_cache(
   input clk,
   input rst,
   input read_enable,
   input [31:0] address,
   output reg [31:0] data_out,
   output hit
);
    
// Cache storage arrays
reg mem_valid0 [3:0]; 
reg [27:0] mem_tag0 [3:0]; 
reg [31:0] mem_data0 [3:0];

reg mem_valid1 [3:0]; 
reg [27:0] mem_tag1 [3:0]; 
reg [31:0] mem_data1 [3:0];

// Interconnect Wires
wire [27:0] tag;
wire [1:0]  index;
wire [1:0]  offset;

wire hit0, hit1, cache_hit;
wire [31:0] mem_data_out;
reg [3:0] lru;


wire [27:0] current_cache_tag0 = mem_tag0[index];
wire [27:0] current_cache_tag1 = mem_tag1[index];
wire        current_valid0     = mem_valid0[index];
wire        current_valid1     = mem_valid1[index];

// Output Hit Assignment
assign hit = (rst || !read_enable) ? 1'b0 : (cache_hit === 1'b1 ? 1'b1 : 1'b0);

// memory
main_memory Main_mem(
    .address(address),
    .data_out(mem_data_out)
);

// address decoder
two_way_assosstivity_address_decoder two_way_decoder(
    .address(address),
    .tag(tag),
    .index(index),
    .offset(offset)
);

//tag comprator
two_way_assossitivity_tag_comparter two_way_tag_compartor(
    .cpu_tag_w0(tag),
    .cache_tag_w0(current_cache_tag0),
    .cpu_tag_w1(tag),
    .cache_tag_w1(current_cache_tag1),
    .valid0(current_valid0),
    .valid1(current_valid1),
    .hit0(hit0),
    .hit1(hit1),
    .hit(cache_hit)
);

integer i;

// Initial Power-On Safe State
initial begin
    lru = 4'b0000;
    for (i = 0 ; i < 4 ; i = i + 1) begin
        mem_valid0[i] = 1'b0; 
        mem_tag0[i] = 28'b0; 
        mem_data0[i] = 32'b0;
        
        mem_valid1[i] = 1'b0; 
        mem_tag1[i] = 28'b0; 
        mem_data1[i] = 32'b0;
    end
end

// Controller Logic Block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 32'b0;
        for (i = 0 ; i < 4 ; i = i + 1) begin
            mem_valid0[i] <= 1'b0; 
            mem_tag0[i] <= 28'b0; 
            mem_data0[i] <= 32'b0;
            
            mem_valid1[i] <= 1'b0; 
            mem_tag1[i] <= 28'b0; 
            mem_data1[i] <= 32'b0;
            
            lru[i]        <= 1'b0;
        end
    end 
    else if (read_enable) begin
        if (cache_hit) begin
            // cache hit
            if (hit0)      data_out <= mem_data0[index];
            else if (hit1) data_out <= mem_data1[index];
               
            lru[index] <= (hit0) ? 1'b1 : 1'b0;
        end
        else begin
            // cache miss
            data_out <= mem_data_out;
            
            if (lru[index] == 1'b0) begin
                mem_valid0[index] <= 1'b1;
                mem_tag0[index]   <= tag;
                mem_data0[index]  <= mem_data_out;
                lru[index]        <= 1'b1;
            end 
            else begin
                mem_valid1[index] <= 1'b1;
                mem_tag1[index]   <= tag;
                mem_data1[index]  <= mem_data_out;
                lru[index]        <= 1'b0;
            end
        end 
    end
end

endmodule