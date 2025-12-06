module log_rom (
    input logic [11:0] addr,
    output logic [5:0] data
);
    logic [5:0] rom [3072];

    initial begin
        $readmemh("log.mem", rom);
    end
    always_comb begin 
        data = rom[addr];
    end
endmodule
