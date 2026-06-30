`timescale 1ns / 1ps
module tag_comparater(
  input [31:5]cpu_tag,
  input [31:5]cache_tag,
  input valid,
  output hit
    );

assign hit = valid && (cpu_tag == cache_tag);
endmodule
