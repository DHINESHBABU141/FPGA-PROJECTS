`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 11:26:53 AM
// Design Name: 
// Module Name: fifo_sync
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


module fifo_sync (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output fifo_full,
    output fifo_empty,
    output reg data_out_valid
);

    parameter DEPTH = 16;
    parameter ADDR_WIDTH = 4; // log2(16)=4

    reg [7:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] wr_ptr = 0, rd_ptr = 0;
    reg [ADDR_WIDTH:0] count = 0;

    assign fifo_full = (count == DEPTH);
    assign fifo_empty = (count == 0);

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            data_out_valid <= 0;
            data_out <= 0;
        end else begin
            // Write operation
            if (wr_en && !fifo_full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            // Read operation
            if (rd_en && !fifo_empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
                data_out_valid <= 1;
            end else begin
                data_out_valid <= 0;
            end
        end
    end

endmodule
