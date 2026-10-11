`timescale 1ns/1ps

module tb_riscv_core;

    reg clk;
    reg reset;

    // DUT output wires
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] alu_result;
    wire [31:0] write_back_data;

    // DUT Instantiation
    riscv_core DUT (
        .clk(clk),
        .reset(reset),
        .pc_out(pc),
        .instruction_out(instruction),
        .alu_result_out(alu_result),
        .write_back_data_out(write_back_data)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin

        clk   = 1'b0;
        reset = 1'b1;

        // Hold reset for 20 ns
        #20;

        reset = 1'b0;

        // Run processor
        #200;

        $display("================================");
        $display("Simulation completed");
        $display("Final PC          = %h", pc);
        $display("Final Instruction = %h", instruction);
        $display("Final ALU Result  = %h", alu_result);
        $display("Final WB Data     = %h", write_back_data);
        $display("================================");

        $finish;
    end

    // Monitor processor at every rising clock edge
    always @(posedge clk) begin

        $display(
            "TIME=%0t | CLK=%b | RESET=%b | PC=%h | INSTRUCTION=%h | ALU_RESULT=%h | WB_DATA=%h",
            $time,
            clk,
            reset,
            pc,
            instruction,
            alu_result,
            write_back_data
        );

    end

endmodule
