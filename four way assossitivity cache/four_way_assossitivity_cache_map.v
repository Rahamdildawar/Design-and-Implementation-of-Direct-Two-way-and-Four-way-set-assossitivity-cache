`timescale 1ns / 1ps

module four_way_assossitivity_cache_map(
   input clk,
   input rst,
   input read_enable,
   input [31:0] address,
   output reg [31:0] data_out,
   output hit
);
    

reg mem_valid0 [3:0];
reg mem_valid1 [3:0];
reg mem_valid2 [3:0];
reg mem_valid3 [3:0];

reg [27:0] mem_tag0 [3:0];
reg [27:0] mem_tag1 [3:0];
reg [27:0] mem_tag2 [3:0];
reg [27:0] mem_tag3 [3:0];

reg [31:0] mem_data0 [3:0];
reg [31:0] mem_data1 [3:0];
reg [31:0] mem_data2 [3:0];
reg [31:0] mem_data3 [3:0];

wire hit0, hit1, hit2, hit3;
wire [27:0] tag;
wire [1:0] index;
wire [1:0] offset;
wire cache_hit;
wire [31:0] mem_data;

// Replacement tracking
reg [1:0] alloc_counter [3:0]; 

assign hit = (rst || !read_enable) ? 1'b0 : (cache_hit === 1'b1 ? 1'b1 : 1'b0);

// Modules Sub-instantiations
main_memory Main_mem(
     .address(address),
     .data_out(mem_data)
);

four_way_assossitivity_address_decoder four_way_dec(
     .address(address),
     .tag(tag),
     .index(index),
     .offset(offset)
);

four_way_assossitivity_tag_comprator four_way_comprator(
     .cpu_tag(tag),
     .cache_tag_w0(mem_tag0[index]),
     .cache_tag_w1(mem_tag1[index]),
     .cache_tag_w2(mem_tag2[index]),
     .cache_tag_w3(mem_tag3[index]),
     .valid0(mem_valid0[index]),
     .valid1(mem_valid1[index]),
     .valid2(mem_valid2[index]),
     .valid3(mem_valid3[index]),
     .hit0(hit0),
     .hit1(hit1),
     .hit2(hit2),
     .hit3(hit3),
     .hit(cache_hit)
);

integer i;

// Initial block for simulation safety
initial begin
    data_out = 32'b0;
    for(i = 0 ; i < 4 ; i = i + 1) begin
        mem_valid0[i] = 1'b0; mem_valid1[i] = 1'b0; mem_valid2[i] = 1'b0; mem_valid3[i] = 1'b0;
        mem_tag0[i]   = 28'b0; mem_tag1[i]   = 28'b0; mem_tag2[i]   = 28'b0; mem_tag3[i]   = 28'b0;
        mem_data0[i]  = 32'b0; mem_data1[i]  = 32'b0; mem_data2[i]  = 32'b0; mem_data3[i]  = 32'b0;
        alloc_counter[i] = 2'b0;
    end
end

// Sequential Block
always @(posedge clk or posedge rst) begin
      if (rst) begin
          data_out <= 32'b0;
          //reset structures
          for(i = 0; i < 4; i = i + 1) begin
              mem_valid0[i] <= 1'b0; mem_valid1[i] <= 1'b0; mem_valid2[i] <= 1'b0; mem_valid3[i] <= 1'b0;
              mem_tag0[i]   <= 28'b0; mem_tag1[i]   <= 28'b0; mem_tag2[i]   <= 28'b0; mem_tag3[i]   <= 28'b0;
              mem_data0[i]  <= 32'b0; mem_data1[i]  <= 32'b0; mem_data2[i]  <= 32'b0; mem_data3[i]  <= 32'b0;
              alloc_counter[i] <= 2'b0;
          end
      end 
      else if (read_enable) begin
          if (cache_hit) begin
              
              data_out <= (hit0) ? mem_data0[index] :
                          (hit1) ? mem_data1[index] :
                          (hit2) ? mem_data2[index] :
                          (hit3) ? mem_data3[index] : 32'b0;
          end 
          else begin
              // Cache Miss
              data_out <= mem_data;
              
              case(alloc_counter[index])
                  2'b00: begin
                      mem_valid0[index] <= 1'b1;
                      mem_tag0[index]   <= tag;
                      mem_data0[index]  <= mem_data;
                  end
                  2'b01: begin
                      mem_valid1[index] <= 1'b1;
                      mem_tag1[index]   <= tag;
                      mem_data1[index]  <= mem_data;
                  end
                  2'b10: begin
                      mem_valid2[index] <= 1'b1;
                      mem_tag2[index]   <= tag;
                      mem_data2[index]  <= mem_data;
                  end
                  2'b11: begin
                      mem_valid3[index] <= 1'b1;
                      mem_tag3[index]   <= tag;
                      mem_data3[index]  <= mem_data;
                  end
              endcase
              
              // Increment index 
              alloc_counter[index] <= alloc_counter[index] + 1'b1;
          end
      end
end
 
endmodule