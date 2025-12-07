module car_rom (
    input logic [9:0] addr,
    output logic [5:0] data
);
    logic [5:0] rom [0:1023];

    initial begin
        $readmemh("car.mem", rom);
    end
    always_comb begin 
        data = rom[addr];
    end
endmodule