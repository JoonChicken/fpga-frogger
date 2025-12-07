module truck_rom (
    input logic [11:0] addr,
    output logic [5:0] data
);
    logic [5:0] rom [0:4095];

    initial begin
        $readmemh("truck.mem", rom);
    end
    always_comb begin 
        data = rom[addr];
    end
endmodule