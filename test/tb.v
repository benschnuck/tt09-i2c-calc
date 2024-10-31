`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

    // Clock and reset
    reg clk;
    reg rst_n;
    reg ena;

    // Inputs and outputs
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate the top-level module
    tt_um_bsrk_i2c_calc dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock

    // Reset and test sequences
    initial begin
        // Initialize inputs
        ena = 1;
        rst_n = 0;
        ui_in = 8'd0;
        uio_in = 8'd0;

        // Reset sequence
        #20;
        rst_n = 1;

        // Wait for a few clock cycles
        #20;

        // Test cases
        // Define your test cases here or use your cocotb testbench
    end

endmodule
