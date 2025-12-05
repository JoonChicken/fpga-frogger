module frog_gen (
    input  logic        clk,
    input  logic [9:0]  colPos,
    input  logic [9:0]  rowPos,
    input  logic [9:0]  frog_x,     // top-left of 32x32 frog block
    input  logic [9:0]  frog_y,
    input  logic [9:0]  frog_size,  // usually 32
    output logic [5:0]  color
);

    //TODO animations
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
    logic       in_frog;

    always_comb begin
        color   = 6'b000000; 
        in_frog = 1'b0;
        local_x = 10'd0;
        local_y = 10'd0;

        in_frog = (colPos >= frog_x && colPos < frog_x + frog_size &&
                   rowPos >= frog_y && rowPos < frog_y + frog_size);

        if (in_frog) begin
            local_x = colPos - frog_x;
            local_y = rowPos - frog_y;

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
                 (local_y == 9           && local_x >= 11 && local_x <= 12) ) begin
                color = EYE_WHITE;
            end
            // right eye white
            else if ( (local_y >= 6 && local_y <= 8 && local_x >= 18 && local_x <= 21) ||
                      (local_y == 9           && local_x >= 19 && local_x <= 20) ) begin
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
    end

endmodule
