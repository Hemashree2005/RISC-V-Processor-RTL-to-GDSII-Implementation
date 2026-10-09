module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:255];
    integer i;

    initial begin
        // 1. Initialize ALL memory locations to NOP (addi x0, x0, 0)
        // This prevents reading uninitialized 'X' values beyond memory[7]
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'h00000013;
        end

        // 2. Sample RISC-V test program sequence
        memory[0] = 32'h00000013; // NOP
        memory[1] = 32'h00500093; // addi x1, x0, 5    (x1 = 5)
        memory[2] = 32'h00a00113; // addi x2, x0, 10   (x2 = 10)
        memory[3] = 32'h002081b3; // add  x3, x1, x2   (x3 = 15)
        memory[4] = 32'h00302023; // sw   x3, 0(x0)    (Mem[0] = 15)
        memory[5] = 32'h00002203; // lw   x4, 0(x0)    (x4 = 15)
        memory[6] = 32'h00000013; // NOP
        memory[7] = 32'h00000013; // NOP
    end

    // Word addressing: map byte address to 32-bit word indices
    assign instruction = memory[address[9:2]];

endmodule
