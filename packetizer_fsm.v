`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 11:30:15 AM
// Design Name: 
// Module Name: packetizer_fsm
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


module packetizer_fsm (
    input clk,
    input rst,
    input fifo_empty,
    input tx_ready,
    input [7:0] fifo_data_out,
    output reg rd_en,
    output reg serial_out,
    output reg tx_busy
);

    reg [3:0] bit_cnt;
    reg [9:0] shift_reg; // 1 start bit + 8 data + 1 stop bit
    reg transmitting;

    // Define states as parameters (no typedef enum)
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam TRANSMIT = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            rd_en <= 0;
            tx_busy <= 0;
            serial_out <= 1; // Idle line is high
            bit_cnt <= 0;
            transmitting <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    serial_out <= 1;
                    tx_busy <= 0;
                    rd_en <= 0;
                    bit_cnt <= 0;
                end
                LOAD: begin
                    // Load start bit (0), data bits, stop bit (1)
                    shift_reg <= {1'b1, fifo_data_out, 1'b0}; // MSB=stop bit, LSB=start bit
                    rd_en <= 1;  // Read one byte from FIFO
                    tx_busy <= 1;
                    bit_cnt <= 0;
                end
                TRANSMIT: begin
                    rd_en <= 0;
                    serial_out <= shift_reg[bit_cnt];
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 9) begin
                        tx_busy <= 0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (!fifo_empty && tx_ready)
                    next_state = LOAD;
            end
            LOAD: begin
                next_state = TRANSMIT;
            end
            TRANSMIT: begin
                if (bit_cnt == 9)
                    next_state = IDLE;
            end
        endcase
    end

endmodule
