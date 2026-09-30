module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

reg [31:0] memory [0:255];

initial begin

    // NOP
    memory[0] = 32'h00000013;

    // Remaining memory initialized to NOP
    memory[1] = 32'h00000013;
    memory[2] = 32'h00000013;
    memory[3] = 32'h00000013;
    memory[4] = 32'h00000013;
    memory[5] = 32'h00000013;
    memory[6] = 32'h00000013;
    memory[7] = 32'h00000013;

end

assign instruction = memory[address[9:2]];

endmodule
