module log_rom (
    input logic clk,
    input logic [11:0] addr,
    output logic [5:0] data
);
    // three 32x32 sprites
    logic [5:0] rom [0:3071];

    initial begin
        $readmemh("rom/log.mem", rom);
    end
    always_ff @(posedge clk) begin 
        data = rom[addr];
    end
endmodule
