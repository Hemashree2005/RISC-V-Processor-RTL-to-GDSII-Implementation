module instruction_memory (
    input  wire [31:0] address,
    output reg  [31:0] instruction
);

    wire [7:0] word_addr = address[9:2];

    always @(*) begin
        case (word_addr)
            8'd0: instruction = 32'h00000013; // NOP
            8'd1: instruction = 32'h00500093; // addi x1, x0, 5
            8'd2: instruction = 32'h00a00113; // addi x2, x0, 10
            8'd3: instruction = 32'h002081b3; // add  x3, x1, x2
            8'd4: instruction = 32'h00302023; // sw   x3, 0(x0)
            8'd5: instruction = 32'h00002203; // lw   x4, 0(x0)
            default: instruction = 32'h00000013; // NOP default
        endcase
    end

endmodule
