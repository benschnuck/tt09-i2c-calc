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

  // All output pins must be assigned. If not used, assign to 0.

  wire [31:0] first_input_number = 32'd16;
  wire [31:0] second_input_number = 32'd4; 
  wire [1:0] operation = 2'b00;
  wire [63:0] result = 64'h0;

  calculator calculator_instance (
      .first_input_number (first_input_number),
      .second_input_number (second_input_number),
      .operation (operation),
      .result (result)
  );

  assign uo_out  = 0;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
