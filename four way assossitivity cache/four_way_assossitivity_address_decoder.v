`timescale 1ns / 1ps
module four_way_assossitivity_address_decoder(
   input [31:0]address,
   output [31:4]tag,
   output [3:2]index,
   output [1:0]offset
    );
    
assign tag = address[31:4];
assign index = address[3:2];
assign offset = address[1:0];
endmodule
