import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_calculator_operations(dut):
    # Start the clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # Define test cases
    test_cases = [
        {'op': 0, 'first': 28, 'second': 4, 'expected': 32},   # Addition
        {'op': 1, 'first': 28, 'second': 4, 'expected': 24},   # Subtraction
        {'op': 2, 'first': 28, 'second': 4, 'expected': 112},  # Multiplication
        {'op': 3, 'first': 28, 'second': 4, 'expected': 7},    # Division
    ]

    for test in test_cases:
        # Prepare inputs
        operation = test['op'] & 0x3      # 2 bits for operation
        first_input = test['first'] & 0x3F  # 6 bits for first input
        second_input = test['second'] & 0xFF  # 8 bits for second input

        # Set inputs
        dut.ui_in.value = (operation << 6) | first_input
        dut.uio_in.value = second_input

        # Wait for processing
        await ClockCycles(dut.clk, 1)

        # Read outputs
        result_low = dut.uo_out.value.integer
        result_high = dut.uio_out.value.integer
        result = (result_high << 8) | result_low

        expected_result = test['expected'] & 0xFFFF

        # Check result
        assert result == expected_result, f"Test failed: Operation {operation}, first input: {first_input}, second input: {second_input}, clock cycles: {dut.clk.value},        expected {expected_result}, got {result}"

        dut._log.info(f"Test passed for operation {operation}")

    # Wait a few clock cycles
    await ClockCycles(dut.clk, 5)
