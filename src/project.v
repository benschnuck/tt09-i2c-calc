/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 1ps
`include "calculator_module.v"

module tt_um_bsrk_i2c_calc (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Declare internal registers
    reg [31:0] first_input_number;
    reg [31:0] second_input_number;
    reg [1:0]  operation;
    wire [63:0] result;

    // Instantiate the calculator module with the clock
    calculator calculator_instance (
        .clk(clk),
        .first_input_number (first_input_number),
        .second_input_number (second_input_number),
        .operation (operation),
        .result (result)
    );

    assign uo_out  = 0;
    assign uio_out = 0;
    assign uio_oe  = 0;

    // Unused inputs
    wire _unused = &{ena, rst_n, ui_in, uio_in};

    // Assign values for simulation purposes
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_input_number <= 0;
            second_input_number <= 0;
            operation <= 0;
        end else begin
            // These values will remain constant unless changed
            // For dynamic testing, we can update them via tasks or DPI calls
            first_input_number <= 32'd28;
            second_input_number <= 32'd4;
            operation <= 2'b00; // Change as needed for testing
        end
    end

endmodule
