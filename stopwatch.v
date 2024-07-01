`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2024 10:58:33
// Design Name: 
// Module Name: alarm_clk
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

module stopwatch (
    input clock,
    input reset,
    input start,
    output a, b, c, d, e, f, g, dp,
    output [3:0] an,
    output reg led
);

reg [3:0] reg_d0, reg_d1, reg_d2, reg_d3;
reg [3:0] prev_start_state;
reg [27:0] ticker;
wire click;

// Generating custom clock of time period = 0.1sec.
always @(posedge clock or posedge reset) begin
    if (reset) begin
        ticker <= 0;
        prev_start_state <= 0;
    end
    else if (ticker == 12_499_999) // Choose ticker <= 12_499_999 since PYNQ z2 operates at 125MHz
        ticker <= 0;
    else if (start && !prev_start_state) // If start transitions from low to high
        ticker <= ticker + 1;
    else if (start && ticker < 12_499_999) // If start is high and ticker hasn't reached its maximum value
        ticker <= ticker + 1;
    prev_start_state <= start;
end


assign click = (ticker == 12_499_999); 


// Counters for seconds and minutes
always @(posedge click or posedge reset) begin
    if (reset) begin
        reg_d0 <= 0;
        reg_d1 <= 0;
        reg_d2 <= 0;
        reg_d3 <= 0;
    end
    else if (click) begin
        if (reg_d0 == 9) begin
            reg_d0 <= 0;
            if (reg_d1 == 9) begin
                reg_d1 <= 0;
                if (reg_d2 == 5) begin
                    reg_d2 <= 0;
                    if (reg_d3 == 9)
                        reg_d3 <= 0;
                    else
                        reg_d3 <= reg_d3 + 1;
                end
                else
                    reg_d2 <= reg_d2 + 1;
            end
            else
                reg_d1 <= reg_d1 + 1;
        end
        else
            reg_d0 <= reg_d0 + 1;
    end
end

// Multiplexing for SSD display
localparam N = 18;
reg [N-1:0] count;

always @(posedge clock or posedge reset) begin
    if (reset)
        count <= 0;
    else
        count <= count + 1;
end

reg [6:0] sseg;
reg [3:0] an_temp;
reg reg_dp;

always @(*) begin
    case (count[N-1:N-2])
        2'b00: begin
            sseg = reg_d0;
            an_temp = 4'b1110;
            reg_dp = 1'b1;
        end
        2'b01: begin
            sseg = reg_d1;
            an_temp = 4'b1101;
            reg_dp = 1'b0;
        end
        2'b10: begin
            sseg = reg_d2;
            an_temp = 4'b1011;
            reg_dp = 1'b1;
        end
        2'b11: begin
            sseg = reg_d3;
            an_temp = 4'b0111;
            reg_dp = 1'b0;
        end
    endcase
end

assign an = an_temp;

reg [6:0] sseg_temp; 
always @ (*) begin
    case (sseg)
        4'd0 : sseg_temp = 7'b1000000;
        4'd1 : sseg_temp = 7'b1111001;
        4'd2 : sseg_temp = 7'b0100100;
        4'd3 : sseg_temp = 7'b0110000;
        4'd4 : sseg_temp = 7'b0011001;
        4'd5 : sseg_temp = 7'b0010010;
        4'd6 : sseg_temp = 7'b0000010;
        4'd7 : sseg_temp = 7'b1111000;
        4'd8 : sseg_temp = 7'b0000000;
        4'd9 : sseg_temp = 7'b0010000;
        default : sseg_temp = 7'b0111111; //dash
    endcase
end

assign {g, f, e, d, c, b, a} = sseg_temp; 
assign dp = reg_dp;

// LED Blinking using the ticker itself
always @(posedge clock) begin
    if (click)
        led <= ~led;
end

endmodule