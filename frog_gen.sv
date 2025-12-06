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
    logic [9:0] sprite_addr;
    logic [5:0] rom_color;

    frog_rom frog_sprite_rom (
        .addr (sprite_addr),
        .data (rom_color)
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
/*
            if (facing == 2'b00) begin
                // left pupil
                if (local_y >= 7 && local_y <= 8 &&
                        local_x >= 11 && local_x <= 12) begin
                    color = PUPIL;
                end
                // right pupil
                else if (local_y >= 7 && local_y <= 8 &&
                        local_x >= 19 && local_x <= 20) begin
                    color = PUPIL;
                end

                // left eye white
                else if ( (local_y >= 6 && local_y <= 8 && local_x >= 10 && local_x <= 13) ||
                    (local_y == 9       && local_x >= 11 && local_x <= 12) ) begin
                    color = EYE_WHITE;
                end
                
                // right eye white
                else if ( (local_y >= 6 && local_y <= 8 && local_x >= 18 && local_x <= 21) ||
                    (local_y == 9 && local_x >= 19 && local_x <= 20) ) begin
                    color = EYE_WHITE;
                end

                // head/body
                else if (
                    // head
                    (local_y >= 6 && local_y <= 10 && local_x >= 8  && local_x <= 23) ||
                    // sides
                    (local_y >= 10 && local_y <= 20 &&
                    (local_x == 8 || local_x == 23))
                ) begin
                    color = DARK_GREEN;
                end

                // upper body layer
                else if (local_y >= 10 && local_y <= 20 &&
                        local_x >= 9  && local_x <= 22) begin
                    color = LIGHT_GREEN;
                end

                // Left front leg
                else if (
                    // upper part near head
                    ((local_y >= 13 && local_y <= 14) && (local_x >= 7 && local_x <= 8)) ||
                    ((local_y >= 13 && local_y <= 14) && (local_x >= 23 && local_x <= 24)) ||

                    // lower part
                    ((local_y >= 15 && local_y <= 17) && (local_x >= 6 && local_x <= 9)) ||
                    ((local_y >= 15 && local_y <= 17) && (local_x >= 23 && local_x <= 25))
                ) begin
                    color = DARK_GREEN;
                end

                // inner back legs
                else if (local_y >= 19 && local_y <= 23 &&
                        ((local_x >= 9  && local_x <= 11) ||
                        (local_x >= 20 && local_x <= 22))) begin
                    color = DARK_GREEN;
                end

                // outer back legs
                else if (local_y >= 21 && local_y <= 25 &&
                        ((local_x >= 6  && local_x <= 8) ||
                        (local_x >= 23 && local_x <= 25))) begin
                    color = LIGHT_GREEN;
                end
            end
        else if (facing == 2'b01) begin
                // left pupil (near bottom)
                if (local_y >= 24 && local_y <= 25 &&
                    local_x >= 11 && local_x <= 12) begin
                    color = PUPIL;
                end
                // right pupil
                else if (local_y >= 24 && local_y <= 25 &&
                        local_x >= 19 && local_x <= 20) begin
                    color = PUPIL;
                end

                // left eye white
                else if ( (local_y >= 24 && local_y <= 25 && local_x >= 10 && local_x <= 13) ||
                        (local_y == 23 && local_x >= 11 && local_x <= 12) ) begin
                    color = EYE_WHITE;
                end
                // right eye white
                else if ( (local_y >= 24 && local_y <= 25 && local_x >= 18 && local_x <= 21) ||
                        (local_y == 23           && local_x >= 19 && local_x <= 20) ) begin
                    color = EYE_WHITE;
                end

                // head/body (same silhouette)
                else if (
                    (local_y >= 22 && local_y <= 26 && local_x >= 8  && local_x <= 23) ||
                    (local_y >= 12 && local_y <= 22 &&
                    (local_x == 8 || local_x == 23))
                ) begin
                    color = DARK_GREEN;
                end

                // upper body layer (same)
                else if (local_y >= 12 && local_y <= 22 &&
                        local_x >= 9  && local_x <= 22) begin
                    color = LIGHT_GREEN;
                end

                // front legs closer to bottom
                else if (
                    // upper part of legs (just below body)
                    ((local_y >= 18 && local_y <= 19) && (local_x >= 7 && local_x <= 8))  ||
                    ((local_y >= 18 && local_y <= 19) && (local_x >= 23 && local_x <= 24)) ||
                    // lower part of legs (toward very bottom)
                    ((local_y >= 15 && local_y <= 17) && (local_x >= 6 && local_x <= 9))  ||
                    ((local_y >= 15 && local_y <= 17) && (local_x >= 23 && local_x <= 25))
                ) begin
                    color = DARK_GREEN;
                end

                // inner back legs (same position)
                else if (local_y >= 9 && local_y <= 13 &&
                        ((local_x >= 9  && local_x <= 11) ||
                        (local_x >= 20 && local_x <= 22))) begin
                    color = DARK_GREEN;
                end

                // outer back legs (same)
                else if (local_y >= 7 && local_y <= 11 &&
                        ((local_x >= 6  && local_x <= 8) ||
                        (local_x >= 23 && local_x <= 25))) begin
                    color = LIGHT_GREEN;
                end
            end

        // FACING LEFT
        else if (facing == 2'b10) begin
            // top pupil (from forward right pupil)
            if (local_x >= 7 && local_x <= 8 &&
                local_y >= 11 && local_y <= 12) begin
                color = PUPIL;
            end
            // bottom pupil (from forward left pupil)
            else if (local_x >= 7 && local_x <= 8 &&
                    local_y >= 19 && local_y <= 20) begin
                color = PUPIL;
            end

            // upper eye white (from forward right eye)
            else if ( (local_x >= 6 && local_x <= 7 &&
                    local_y >= 10 && local_y <= 13) ||
                    (local_x == 8 &&
                    local_y >= 11 && local_y <= 12) ) begin
                color = EYE_WHITE;
            end

            // lower eye white (from forward left eye)
            else if ( (local_x >= 6 && local_x <= 7 &&
                    local_y >= 18 && local_y <= 21) ||
                    (local_x == 8 &&
                    local_y >= 19 && local_y <= 20) ) begin
                color = EYE_WHITE;
            end

            // head/body outline
            else if (
                // head (rotated)
                (local_x >= 6 && local_x <= 10 &&
                local_y >= 8 && local_y <= 23) ||

                // sides (rotated)
                (local_x >= 10 && local_x <= 20 &&
                (local_y == 8 || local_y == 23))
            ) begin
                color = DARK_GREEN;
            end

            // upper body layer (LIGHT_GREEN)
            else if (local_x >= 10 && local_x <= 19 &&
                    local_y >= 9  && local_y <= 22) begin
                color = LIGHT_GREEN;
            end

            // front legs (from forward front legs)
            else if (
                // top right front leg segment
                ((local_x >= 13 && local_x <= 14) &&
                (local_y >= 7 && local_y <= 8))   ||

                // top left front leg segment
                ((local_x >= 13 && local_x <= 14) &&
                (local_y >= 23 && local_y <= 24)) ||

                // lower right front leg segment
                ((local_x >= 15 && local_x <= 17) &&
                (local_y >= 6 && local_y <= 8))   ||

                // lower left front leg segment
                ((local_x >= 15 && local_x <= 17) &&
                (local_y >= 22 && local_y <= 25))
            ) begin
                color = DARK_GREEN;
            end

            // inner back legs
            else if (local_x >= 19 && local_x <= 23 &&
                    ((local_y >= 9  && local_y <= 11) ||
                    (local_y >= 20 && local_y <= 22))) begin
                color = DARK_GREEN;
            end

            // outer back legs
            else if (local_x >= 20 && local_x <= 23 &&
                    ((local_y >= 6  && local_y <= 8) ||
                    (local_y >= 23 && local_y <= 25))) begin
                color = LIGHT_GREEN;
            end
        end

        // FACING RIGHT
        else if (facing == 2'b11) begin
            // top pupil
            if (local_x >= 22 && local_x <= 23 &&
                local_y >= 11 && local_y <= 12) begin
                color = PUPIL;
            end

            // bottom pupil (original right pupil)
            else if (local_x >= 22 && local_x <= 23 &&
                    local_y >= 19 && local_y <= 20) begin
                color = PUPIL;
            end

            // left eye white
            else if (
                ((local_x >= 23 && local_x <= 24)  && (local_y >= 10 && local_y <= 13)) ||
                ((local_x == 22) && (local_y >= 11 && local_y <= 12))
            ) begin
                color = EYE_WHITE;
            end

            else if (
                ((local_x >= 23 && local_x <= 24)  && (local_y >= 18 && local_y <= 21)) ||
                ((local_x == 22) && (local_y >= 19 && local_y <= 20))
            ) begin
                color = EYE_WHITE;
            end

            // head/body
            else if (
                // head
                ((local_x >= 21 && local_x <= 25) && (local_y >= 8  && local_y <= 23)) ||
                // sides
                ((local_x >= 11 && local_x <= 21) && (local_y == 8 || local_y == 23))
            ) begin
                color = DARK_GREEN;
            end


            // upper body
            else if (local_x >= 12 && local_x <= 21 &&
                    local_y >= 9  && local_y <= 22) begin
                color = LIGHT_GREEN;
            end


            // Front legs
            else if (
                ((local_x >= 17 && local_x <= 18) && (local_y >= 7 && local_y <= 8)) ||
                ((local_x >= 17 && local_x <= 18) && (local_y >= 23  && local_y <= 24 )) ||
                ((local_x >= 14 && local_x <= 16) && (local_y >= 6 && local_y <= 8)) ||
                ((local_x >= 14 && local_x <= 16) && (local_y >= 22  && local_y <= 25 ))
            ) begin
                color = DARK_GREEN;
            end


            // inner back legs
            else if (local_x >= 8 && local_x <= 12 &&
                    ((local_y >= 20 && local_y <= 22) ||
                    (local_y >= 9  && local_y <= 11))) begin
                color = DARK_GREEN;
            end


            // outer back legs
            else if (local_x >= 7 && local_x <= 10 &&
                    ((local_y >= 23 && local_y <= 25) ||
                    (local_y >= 6  && local_y <= 8 ))) begin
                color = LIGHT_GREEN;
            end
        end

    end
end

endmodule
*/