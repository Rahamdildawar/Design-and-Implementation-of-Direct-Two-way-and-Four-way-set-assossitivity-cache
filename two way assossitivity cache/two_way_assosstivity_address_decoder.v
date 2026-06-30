`timescale 1ns / 1ps

module two_way_assosstivity_address_decoder(
    input [31:0] address,
    output [27:0] tag,
    output [1:0]  index,
    output [1:0]  offset
);

    assign tag    = address[31:4];
    assign index  = address[3:2];
    assign offset = address[1:0];

endmodule