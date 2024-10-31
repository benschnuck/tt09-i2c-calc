
module calculator(
    input wire [31:0] first_input_number,
    input wire [31:0] second_input_number,
    input wire [1:0] operation,
    output reg [63:0] result
);
    parameter OPR_ADD = 2'b00;
    parameter OPR_SUB = 2'b01;
    parameter OPR_MUL = 2'b10;
    parameter OPR_DIV = 2'b11;

    always @(*) 
    begin
        
        case(operation)
            OPR_ADD: result[32:0] = first_input_number + second_input_number;
            OPR_SUB: result[32:0] = first_input_number - second_input_number;
            OPR_MUL: result[63:0] = first_input_number * second_input_number;
            OPR_DIV: result[31:0] = (second_input_number != 0) ? (first_input_number / second_input_number) : 32'b0;  
            default: result[63:0] = 64'h0;
        endcase
    end
endmodule