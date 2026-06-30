`timescale 1ns / 1ps
module four_way_assossitivity_tag_comprator(
   input [27:0]cpu_tag,
   input [27:0]cache_tag_w0,
   input [27:0]cache_tag_w1,
   input [27:0]cache_tag_w2,
   input [27:0]cache_tag_w3,
   input valid0,
   input valid1,
   input valid2,
   input valid3,
   output hit0,
   output hit1,
   output hit2,
   output hit3,
   output hit
    );
    
assign hit0 = (valid0 == 1'b1) && (cpu_tag == cache_tag_w0);
assign hit1 = (valid1 == 1'b1) && (cpu_tag == cache_tag_w1);
assign hit2 = (valid2 == 1'b1) && (cpu_tag == cache_tag_w2);
assign hit3 = (valid3 == 1'b1) && (cpu_tag == cache_tag_w3);

assign hit = hit0 || hit1 || hit2 || hit3;
endmodule
