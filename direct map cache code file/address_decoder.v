`timescale 1ns / 1ps
module address_decoder(
   input [31:0]address,
   output [31:5]tag,
   output [4:2]index,
   output [1:0]offset
    );
    
assign tag = address[31:5];
assign index = address[4:2];
assign offset = address[1:0];
endmodule
