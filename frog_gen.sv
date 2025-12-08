module frog_gen (
    input  logic        clk,
    input  logic [9:0]  colPos,
    input  logic [9:0]  rowPos,
    input  logic [9:0]  frog_x,
    input  logic [9:0]  frog_y,
    input  logic [9:0]  frog_size,
    input logic [1:0] facing,
    output logic [5:0]  color
);

    // TODO animations
    logic [10:0] offset = 11'b0;
    always_ff @(posedge clk) begin
        offset <= offset + 4;
    end

    localparam [5:0] LIGHT_GREEN = 6'b001100;
    localparam [5:0] DARK_GREEN  = 6'b000101;
    localparam [5:0] ORANGE      = 6'b110100;
    localparam [5:0] EYE_WHITE   = 6'b111111;
    localparam [5:0] PUPIL       = 6'b000001;

    logic [9:0] local_x;
    logic [9:0] local_y;
    logic in_frog;
    logic [11:0] sprite_addr;
    logic [5:0] rom_color;

    frog_rom frog_sprite_rom (
        .addr(sprite_addr),
        .data(rom_color)
    );
    always_comb begin
        color   = 6'b000000; 
        in_frog = 1'b0;
        local_x = 10'd0;
        local_y = 10'd0;
        sprite_addr = 0;

        in_frog = (colPos >= frog_x && colPos < frog_x + frog_size &&
                   rowPos >= frog_y && rowPos < frog_y + frog_size);

        if (in_frog) begin
            local_x = colPos - frog_x;
            local_y = rowPos - frog_y;
            sprite_addr = {facing, local_y[4:0], local_x[4:0]};
            color = rom_color;
        end else begin
            color = 6'b000000;
        end
    end
endmodule
