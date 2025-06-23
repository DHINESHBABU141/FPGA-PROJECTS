`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 11:33:14 AM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx #(
    parameter CLK_FREQ = 50000000,  // 50 MHz
    parameter BAUD_RATE = 9600
)(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output reg tx_serial,
    output reg tx_busy
);

    localparam integer BAUD_DIV = CLK_FREQ / BAUD_RATE;
    reg [15:0] baud_cnt;
    reg [3:0] bit_cnt;
    reg [9:0] shift_reg; // start bit + 8 data bits + stop bit

    reg sending;

    always @(posedge clk) begin
        if (rst) begin
            tx_serial <= 1'b1;  // Idle state is high
            tx_busy <= 0;
            baud_cnt <= 0;
            bit_cnt <= 0;
            sending <= 0;
            shift_reg <= 10'b1111111111;
        end else begin
            if (!sending) begin
                if (tx_start) begin
                    // Load shift register with start bit, data, stop bit
                    shift_reg <= {1'b1, tx_data, 1'b0}; 
                    sending <= 1;
                    tx_busy <= 1;
                    baud_cnt <= 0;
                    bit_cnt <= 0;
                    tx_serial <= 0; // start bit
                end else begin
                    tx_serial <= 1;
                    tx_busy <= 0;
                end
            end else begin
                if (baud_cnt == BAUD_DIV - 1) begin
                    baud_cnt <= 0;
                    tx_serial <= shift_reg[bit_cnt];
                    bit_cnt <= bit_cnt + 1;

                    if (bit_cnt == 9) begin
                        sending <= 0;
                        tx_busy <= 0;
                    end
                end else begin
                    baud_cnt <= baud_cnt + 1;
                end
            end
        end
    end

endmodule


