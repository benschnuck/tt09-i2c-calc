import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_calculator_operations(dut):
    dut._log.info("Start calculator operations test")

    # Set up the clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
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
        dut._log.info(f"Testing operation {test['op']} with inputs {test['first']} and {test['second']}")

        # Set inputs
        dut.user_project.first_input_number.value = test['first']
        dut.user_project.second_input_number.value = test['second']
        dut.user_project.operation.value = test['op']

        # Wait for a clock edge
        await ClockCycles(dut.clk, 2)

        result_value = int(dut.user_project.calculator_instance.result.value)
        expected_value = test['expected']

        if test['op'] == 2:
            # Multiplication result may be in upper 64 bits
            expected_result = test['expected']
            assert result_value == expected_result, f"Multiplication result mismatch: expected {expected_result}, got {result_value}"
        else:
            # For other operations, result is in lower 32 bits
            result_32 = result_value & 0xFFFFFFFF
            assert result_32 == expected_value, f"Operation {test['op']} result mismatch: expected {expected_value}, got {result_32}"
    # await ClockCycles(dut.clk, 20)  # Adjust the number as needed