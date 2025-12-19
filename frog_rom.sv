module frog_rom (
    input logic clk,
    input logic [11:0] addr,
    output logic [5:0] data
);
    // four 32x32 sprites
    logic [5:0] rom [0:4095];

    initial begin
        $readmemh("rom/frog.mem", rom);
    end
    always_ff @(posedge clk) begin 
        data = rom[addr];
    end
endmodule
