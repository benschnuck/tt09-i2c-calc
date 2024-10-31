module calculator(
    input wire clk,
    input wire [31:0] first_input_number,
    input wire [31:0] second_input_number,
    input wire [1:0] operation,
    output reg [63:0] result
);
    parameter OPR_ADD = 2'b00;
    parameter OPR_SUB = 2'b01;
    parameter OPR_MUL = 2'b10;
    parameter OPR_DIV = 2'b11;

    always @(posedge clk) 
    begin
        case(operation)
            OPR_ADD:
            begin
                result[31:0] <= first_input_number + second_input_number;
                result[63:32] <= 32'h0;
            end
            OPR_SUB: 
            begin
                result[31:0] <= first_input_number - second_input_number;
                result[63:32] <= 32'h0;
            end
            OPR_MUL: 
            begin
                result[63:0] <= first_input_number * second_input_number;
            end
            OPR_DIV: 
            begin
                result[31:0] <= (second_input_number != 0) ? (first_input_number / second_input_number) : 32'b0;  
                result[63:32] <= 32'h0;
            end
            default: result[63:0] <= 64'h0;
        endcase
    end
endmodule
