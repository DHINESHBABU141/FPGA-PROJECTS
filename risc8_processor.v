`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2025 11:59:46 PM
// Design Name: 
// Module Name: risc8_processor
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


// risc8_processor.v
module risc8_processor (
    input clk,
    input reset
);
    reg [7:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset)
            counter <= 8'd0;
        else
            counter <= counter + 1;
    end
endmodule

