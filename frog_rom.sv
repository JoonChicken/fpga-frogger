module frog_rom (
    input logic [9:0] addr,
    output logic [5:0] data
);
    logic [5:0] rom [1024];

    initial begin
        $readmemh("frog.mem", rom);
    end
    always_comb begin 
        data = rom[addr];
    end
endmodule