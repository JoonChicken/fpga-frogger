module car_rom (
    input logic clk,
    input logic [9:0] addr,
    output logic [5:0] data
);
    // 32x32
    logic [5:0] rom [0:1023];

    initial begin
        $readmemh("rom/car.mem", rom);
    end
    always_ff @(posedge clk) begin 
        data <= rom[addr];
    end
endmodule
