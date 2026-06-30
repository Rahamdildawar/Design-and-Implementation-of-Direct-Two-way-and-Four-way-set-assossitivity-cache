`timescale 1ns / 1ps
module main_memory(
   input [31:0]address,
   output [31:0]data_out
    );
    
reg [31:0] memory [0:255];

integer i;

initial begin
   for(i = 0 ; i <= 255 ; i = i + 1)
       memory[i] = i;
end    
   assign data_out = memory[address[9:2]];

endmodule
