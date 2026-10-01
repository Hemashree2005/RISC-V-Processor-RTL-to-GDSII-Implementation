`timescale 1ns/1ps

module tb_riscv_core;

    reg clk;
    reg reset;

    // DUT
    riscv_core DUT (
        .clk(clk),
        .reset(reset)
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
        $display("Final PC          = %h", DUT.pc);
        $display("Final Instruction = %h", DUT.instruction);
        $display("================================");

        $finish;
    end

    // Monitor processor at every rising clock edge
    always @(posedge clk) begin

        $display(
            "TIME=%0t | CLK=%b | RESET=%b | PC=%h | INSTRUCTION=%h",
            $time,
            clk,
            reset,
            DUT.pc,
            DUT.instruction
        );

    end

endmodule
