// background.sv file 

module background(
  input  logic       on,
  input  logic [9:0] colPos,
  input  logic [9:0] rowPos,
  output logic [5:0] color
);

    localparam [5:0] RED0 = 6'b010000;
    localparam [5:0] RED1 = 6'b100000;
    localparam [5:0] RED1 = 6'b010001;

    localparam [5:0] ENDAREA0 = 6'b001000;
    localparam [5:0] ENDAREA1 = 6'b001001;
    localparam [5:0] ENDAREA2 = 6'b011000;
    localparam [5:0] ENDAREA3 = 6'b110001;
    localparam [5:0] ENDAREA4 = 6'b011110;  

    localparam [5:0] BLACK = 6'b000000;
    localparam [5:0] BLUE = 6'b000011;
    
    localparam [9:0] X_OFFSET_LEFT = 10'd96;
    localparam [9:0] X_OFFSET_RIGHT = 10'd544;
    localparam [9:0] BLOCKSIZE = 10'd32;

    logic river;
    logic grass;
    logic endarea;

    // tiles for tile patterns
    logic [7:0] x4tile_x;
    logic [7:0] x4tile_y;
    logic [2:0] x4pattern;
    
    // TODO x8 is for water, still unsure if it looks good
    logic [7:0] x8tile_x;
    logic [7:0] x8tile_y;
    logic [2:0] x8pattern;

    always_comb begin
        color = BLACK;

        x4tile_x = 0;
        x4tile_y = 0;
        x4pattern = 0;

        x8tile_x = 0;
        x8tile_y = 0;
        x8pattern = 0;

        // make 8x8 and 4x4 tiles
        x4tile_x = colPos[9:2];
        x4tile_y = rowPos[9:2];
        x8tile_x = colPos[9:3];
        x8tile_y = rowPos[9:3];

        river = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                (rowPos >= 1 * BLOCKSIZE) && (rowPos <= 7 * BLOCKSIZE);

        grass = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                ((rowPos >= 7 * BLOCKSIZE   && rowPos <= 8 * BLOCKSIZE) ||
                (rowPos >= 14 * BLOCKSIZE  && rowPos <= 15 * BLOCKSIZE));
        endarea = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                  (rowPos >= 0 * BLOCKSIZE   && rowPos <= 1 * BLOCKSIZE);

        // make psuedorandom patterns with xor trick
        x4pattern[0] = x4tile_x[2] ^ x4tile_y[1];
        x4pattern[1] = x4tile_x[1] ^ x4tile_y[2];
        x4pattern[2] = x4tile_x[0] ^ x4tile_y[0];

        x8pattern[0] = x8tile_x[2] ^ x8tile_y[1];
        x8pattern[1] = x8tile_x[1] ^ x8tile_y[2];
        x8pattern[2] = x8tile_x[0] ^ x8tile_y[0];

        if (river) begin
            color = BLUE;
        end else if (grass) begin
            case (x4pattern[2:0])
                3'b000: color = RED2;
                3'b001, 3'b011: color = RED1;
                3'b101, 3'b010: color = RED0;
                default: color = RED2;
            endcase
        end else if (endarea) begin
            case (x4pattern[2:0])
                3'b000: color = ENDAREA0;
                3'b001: color = ENDAREA1;
                3'b010: color = ENDAREA2;
                3'b011: color = ENDAREA3;
                3'b100: color = ENDAREA4;
                3'b101, 3'b110: color = ENDAREA0;
                default: color = ENDAREA3;

            endcase
        end
    end

endmodule
