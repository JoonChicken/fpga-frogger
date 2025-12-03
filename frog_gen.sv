module frog_gen (
    input logic clk,
    input logic [9:0] colPos,
    input logic [9:0] rowPos,
    input logic [9:0] frog_x,
    input logic [9:0] frog_y,
    input logic [9:0] frog_size,
    output logic display_enable,
    output logic [5:0] color
);

    logic [10:0] offset = 11'b0;

    always_ff @(posedge clk) begin
        offset <= offset + 4;
    end

    logic lum;
    logic in_frog;

    always_comb begin
        // check if current pixel is within the frog
        in_frog = (colPos >= frog_x && colPos < frog_x + frog_size &&
                     rowPos >= frog_y && rowPos < frog_y + frog_size);

        lum = (colPos % 32 == 0) | (rowPos % 32 == 0);

        if (colPos >= 96 && colPos <= 544) begin
            if (in_frog) begin
                // draw frog (green = 0b001100 in 6-bit RGB format [RRGGBB])
                color = 6'b111111;
                display_enable = 1'b1;
            end else begin
                color = (lum << 4) | (lum << 2) | lum;
                display_enable = 1'b1;
            end
        end else begin
            color = 6'b000000;
            display_enable = 1'b0;
        end
    end

endmodule