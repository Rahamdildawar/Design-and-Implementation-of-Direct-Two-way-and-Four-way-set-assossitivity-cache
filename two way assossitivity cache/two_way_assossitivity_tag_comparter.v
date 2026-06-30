`timescale 1ns / 1ps

module two_way_assossitivity_tag_comparter(
   input [27:0] cpu_tag_w0,
   input [27:0] cache_tag_w0,
   input [27:0] cpu_tag_w1,
   input [27:0] cache_tag_w1,
   input        valid0,
   input        valid1,
   output       hit0,
   output       hit1,
   output       hit
);
    
   // Using case-equality (===) to prevent X-state noise during boot/reset
   assign hit0 = (valid0 === 1'b1) && (cpu_tag_w0 == cache_tag_w0);
   assign hit1 = (valid1 === 1'b1) && (cpu_tag_w1 == cache_tag_w1);
   assign hit  = hit0 || hit1;

endmodule