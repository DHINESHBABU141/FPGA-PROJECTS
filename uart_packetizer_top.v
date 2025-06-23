`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 11:35:28 AM
// Design Name: 
// Module Name: uart_packetizer_top
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


module uart_packetizer_top (
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    input tx_ready,
    output serial_out,
    output fifo_full,
    output tx_busy
);

    wire fifo_empty;
    wire fifo_data_valid;
    wire [7:0] fifo_data_out;
    wire fifo_rd_en;  // Changed from reg to wire

    // Instantiate FIFO
    fifo_sync fifo_inst (
        .clk(clk),
        .rst(rst),
        .wr_en(data_valid && !fifo_full),
        .rd_en(fifo_rd_en),
        .data_in(data_in),
        .data_out(fifo_data_out),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .data_out_valid(fifo_data_valid)
    );

    // Instantiate FSM
    packetizer_fsm fsm_inst (
        .clk(clk),
        .rst(rst),
        .fifo_empty(fifo_empty),
        .tx_ready(tx_ready),
        .fifo_data_out(fifo_data_out),
        .rd_en(fifo_rd_en),  // Driven by FSM, so wire here
        .serial_out(serial_out),
        .tx_busy(tx_busy)
    );

endmodule

