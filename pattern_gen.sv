module pattern_gen (
    input logic clk,
    input logic [9:0] colPos,
    input logic [9:0] rowPos,
    input logic [9:0] square_x,
    input logic [9:0] square_y,
    input logic [9:0] square_size,
    output logic display_enable,
    output logic [5:0] color
);

    logic [10:0] offset = 11'b0;

    always_ff @(posedge clk) begin
        offset <= offset + 4;
    end

    logic lum;
    logic in_square;

    always_comb begin
        // Check if current pixel is within the green square
        in_square = (colPos >= square_x && colPos < square_x + square_size &&
                     rowPos >= square_y && rowPos < square_y + square_size);

        // Always assign lum to avoid latch inference
        lum = (colPos % 32 == 0) | (rowPos % 32 == 0);

        if (colPos >= 96 && colPos <= 544) begin
            if (in_square) begin
                // Draw green square (green = 0b001100 in 6-bit RGB format [RRGGBB])
                color = 6'b001100;
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