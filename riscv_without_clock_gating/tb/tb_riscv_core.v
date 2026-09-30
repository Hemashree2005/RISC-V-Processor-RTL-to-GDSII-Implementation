`timescale 1ns/1ps

module tb_riscv_core;

reg clk;
reg reset;

riscv_core DUT (
    .clk(clk),
    .reset(reset)
);


// Clock
always #5 clk = ~clk;


// Test
initial begin

    clk = 1'b0;
    reset = 1'b1;

    #20;

    reset = 1'b0;

    #500;

    $finish;

end


// Monitor
always @(posedge clk) begin

    $display(
        "TIME=%0t PC=%h INSTRUCTION=%h",
        $time,
        DUT.pc,
        DUT.instruction
    );

end

endmodule
