module car_rom (
    input logic [9:0] addr,
    output logic [5:0] data
);
    // just one square
    logic [5:0] rom [0:1023];

    initial begin
        $readmemh("rom/car.mem", rom);
    end
    always_comb begin 
        data = rom[addr];
    end
endmodule