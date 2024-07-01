
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2024 09:16:56
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module stopwatch_tb;

    // Parameters
    parameter CLOCK_PERIOD = 10; // Clock period in ns
    
    // Inputs
    reg clock;
    reg reset;
    reg start;
    
    // Outputs
    wire a, b, c, d, e, f, g, dp;
    wire [3:0] an;
    wire led;
    
    // Instantiate the stopwatch module
    stopwatch uut (
        .clock(clock),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .dp(dp),
        .an(an),
        .led(led)
    );
    
    // Clock generation
    always #((CLOCK_PERIOD)/2) clock = ~clock;
    
    // Initial values
    initial begin
        clock = 0;
        reset = 1;
        start = 0;
        
        // Reset sequence
        #20000;
        reset = 0;
        #10000;
        
        // Start stopwatch
        start = 1;
        
        
        #300000000; 
        
        // Test case 2: Verify reset functionality
        reset = 1;
        #50000;
        reset = 0;
        #100000;
        
        // Test case 3: Verify start-stop functionality
        start = 0;
        #50000; 
        start = 1;
        #200000000; 
        start = 0;
        #200000000;
        reset = 1;
        #50000000; 
        // End simulation
        $finish;
    end
    
endmodule



