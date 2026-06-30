`timescale 1ns / 1ps

module two_way_assosstivity_casch_map_tb;

    reg clk;
    reg rst;
    reg read_enable;
    reg [31:0] address;

    wire [31:0] data_out;
    wire hit;

    two_way_assosstivity_map_cache uut (
        .clk(clk), 
        .rst(rst), 
        .read_enable(read_enable), 
        .address(address), 
        .data_out(data_out), 
        .hit(hit)
    );

    always #5 clk = ~clk; 

    initial begin
        clk = 0;
        rst = 1;
        read_enable = 0;
        address = 32'h0;
        #15; 
        
        rst = 0;
        #5;
        read_enable = 1;

        address = 32'h0000_0000; #20; 
        address = 32'h0000_0000; #20; 
        address = 32'h0000_0004; #20; 
        address = 32'h0000_0004; #20;

        read_enable = 0;
        #20;
        $finish;
    end
      
endmodule