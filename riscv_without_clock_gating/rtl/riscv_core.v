module riscv_core (
    input wire clk,
    input wire reset
);

wire [31:0] pc;
wire [31:0] next_pc;

wire [31:0] instruction;

wire [31:0] read_data1;
wire [31:0] read_data2;

wire [31:0] alu_input_b;
wire [31:0] alu_result;

wire [31:0] immediate;

wire [31:0] memory_data;
wire [31:0] write_back_data;

wire        reg_write;
wire        alu_src;
wire        mem_read;
wire        mem_write;
wire        mem_to_reg;
wire        branch;
wire        jump;

wire [3:0]  alu_control;

wire        zero;


// --------------------------------------------------
// Instruction fields
// --------------------------------------------------

wire [6:0] opcode = instruction[6:0];

wire [4:0] rd = instruction[11:7];

wire [2:0] funct3 = instruction[14:12];

wire [4:0] rs1 = instruction[19:15];

wire [4:0] rs2 = instruction[24:20];

wire [6:0] funct7 = instruction[31:25];


// --------------------------------------------------
// Program Counter
// --------------------------------------------------

program_counter PC_UNIT (
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc)
);


// --------------------------------------------------
// Instruction Memory
// --------------------------------------------------

instruction_memory IMEM (
    .address(pc),
    .instruction(instruction)
);


// --------------------------------------------------
// Control Unit
// --------------------------------------------------

control_unit CONTROL (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),

    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch(branch),
    .jump(jump),

    .alu_control(alu_control)
);


// --------------------------------------------------
// Register File
// --------------------------------------------------

register_file REGFILE (
    .clk(clk),
    .reset(reset),

    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    .write_data(write_back_data),
    .reg_write(reg_write),

    .read_data1(read_data1),
    .read_data2(read_data2)
);


// --------------------------------------------------
// Immediate Generation
// --------------------------------------------------

assign immediate =
    (opcode == 7'b0010011 || opcode == 7'b0000011 ||
     opcode == 7'b1100111) ?
        {{20{instruction[31]}}, instruction[31:20]} :

    (opcode == 7'b0100011) ?
        {{20{instruction[31]}},
         instruction[31:25],
         instruction[11:7]} :

    (opcode == 7'b1100011) ?
        {{19{instruction[31]}},
         instruction[31],
         instruction[7],
         instruction[30:25],
         instruction[11:8],
         1'b0} :

    (opcode == 7'b1101111) ?
        {{11{instruction[31]}},
         instruction[31],
         instruction[19:12],
         instruction[20],
         instruction[30:21],
         1'b0} :

        32'b0;


// --------------------------------------------------
// ALU Input
// --------------------------------------------------

assign alu_input_b =
    alu_src ? immediate : read_data2;


// --------------------------------------------------
// ALU
// --------------------------------------------------

alu ALU_UNIT (
    .a(read_data1),
    .b(alu_input_b),
    .alu_control(alu_control),

    .result(alu_result),
    .zero(zero)
);


// --------------------------------------------------
// Data Memory
// --------------------------------------------------

data_memory DMEM (
    .clk(clk),

    .mem_read(mem_read),
    .mem_write(mem_write),

    .address(alu_result),
    .write_data(read_data2),

    .read_data(memory_data)
);


// --------------------------------------------------
// Write Back
// --------------------------------------------------

assign write_back_data =
    mem_to_reg ? memory_data : alu_result;


// --------------------------------------------------
// Next PC
// --------------------------------------------------

assign next_pc =
    jump ?
        (pc + immediate) :

    (branch && zero) ?
        (pc + immediate) :

        (pc + 32'd4);

endmodule
