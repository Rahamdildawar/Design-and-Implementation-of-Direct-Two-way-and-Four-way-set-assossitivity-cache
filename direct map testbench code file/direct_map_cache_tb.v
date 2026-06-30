`timescale 1ns / 1ps
module direct_map_cache_tb();
reg clk;
reg rst;
reg read_enable;
reg [31:0]address;
wire [31:0]data_out;
wire hit;

direct_map_cache uut(
    .clk(clk),
    .rst(rst),
    .read_enable(read_enable),
    .address(address),
    .data_out(data_out),
    .hit(hit)
);

always #5 clk = ~clk;

initial 
begin
  clk = 0;
  rst = 1;
  read_enable = 0;
#10;
  rst = 0;
  
  address = 32'h00000010;
  read_enable = 1'b1;
  #10;
  address = 32'h00000010;
  #10;
  address = 32'h00000020;
  #10;
$finish;
end
endmodule
