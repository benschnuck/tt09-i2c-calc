/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
// `timescale 1ns / 1ps
`include "calculator_module.v"

module tt_um_bsrk_i2c_calc (
    input  wire [7:0] ui_in,    // ui_in[7:6]: operation code, ui_in[5:0]: operand A lower bits
    output wire [7:0] uo_out,   // Output: result lower 8 bits
    input  wire [7:0] uio_in,   // Operand B
    output wire [7:0] uio_out,  // Output: result higher 8 bits
    output wire [7:0] uio_oe,   // Output enable
    input  wire       ena,      // Enable
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset (active low)
);
    // Declare internal registers
    reg [31:0] first_input_number;
    reg [31:0] second_input_number;
    reg [1:0]  operation;
    wire [63:0] result;

    // Map inputs from ui_in and uio_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_input_number <= 32'd0;
            second_input_number <= 32'd0;
            operation <= 2'd0;
        end else if (ena) begin
            operation <= ui_in[7:6];           // Use ui_in[7:6] for operation
            first_input_number <= {24'd0, ui_in[5:0], 2'd0}; // Extend ui_in[5:0] to 32 bits
            second_input_number <= {24'd0, uio_in};  // Extend uio_in[7:0] to 32 bits
        end
    end

    // Instantiate the calculator module
    calculator calculator_instance (
        .clk(clk),
        .first_input_number (first_input_number),
        .second_input_number (second_input_number),
        .operation (operation),
        .result (result)
    );

    // Assign result to outputs
    assign uo_out = result[7:0];        // Lower 8 bits of result
    assign uio_out = result[15:8];      // Next 8 bits of result
    assign uio_oe = 8'hFF;              // Enable uio_out as outputs

    // Use other inputs to prevent warnings
    wire _unused = &{ui_in[5:0], uio_in, ena};

endmodule
