`timescale 1ns / 1ps

module four_way_assossitivity_cache_map_tb();

    // Inputs
    reg clk;
    reg rst;
    reg read_enable;
    reg [31:0] address;

    // Outputs
    wire [31:0] data_out;
    wire hit;

   
    four_way_assossitivity_cache_map uut (
        .clk(clk),
        .rst(rst),
        .read_enable(read_enable),
        .address(address),
        .data_out(data_out),
        .hit(hit)
    );

   // clock generation
    always #10 clk = ~clk;

    initial begin
     
        clk = 0;
        rst = 1;
        read_enable = 0;
        address = 32'b0;
        #40;
        
        // Release reset
        rst = 0;
        #20;

        $display("=== Starting Cache Simulation ===");
       
        read_address(32'h00000010);       
        read_address(32'h00000020);       
        read_address(32'h00000030); 
        read_address(32'h00000040); 

        $display("\n--- Testing Hits on Stored Ways ---");
        read_address(32'h00000010);
        read_address(32'h00000030);
        read_address(32'h00000040);
        read_address(32'h00000020);

       
        $display("\n--- Testing Way Eviction (5th access to Index 0) ---");
        read_address(32'h00000050); 

        $display("\n--- Checking if Way 0 was successfully evicted ---");
        read_address(32'h00000010); 

        
        #40;
        $display("=== Simulation Finished ===");
        $finish;
    end

   
    task read_address(input [31:0] addr);
        begin
            @(posedge clk);
            address = addr;
            read_enable = 1;
            
            @(posedge clk);
            #1; 
            $display("Address: 0x%h | Hit: %b | Data Out: 0x%h", address, hit, data_out);
            
            
            read_enable = 0;
        end
    endtask

endmodule



