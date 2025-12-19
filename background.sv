// background.sv file 

module background(
  input  logic       on,
  input  logic [9:0] colPos,
  input  logic [9:0] rowPos,
  output logic [5:0] color
); 
    parameter GREEN = 6'b010101;
    parameter BLACK = 6'b000000;
    parameter BLUE = 6'b000010;
    parameter WHITE = 6'b111111;
    parameter X_OFFSET_LEFT = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;
    parameter BLOCKSIZE = 10'd32;

    localparam [5:0] RED0 = 6'b010000;
    localparam [5:0] RED1 = 6'b010001;

    localparam [5:0] ENDAREA0 = 6'b001000;
    localparam [5:0] ENDAREA1 = 6'b001001;
    localparam [5:0] ENDAREA2 = 6'b011000;
    localparam [5:0] ENDAREA3 = 6'b011110;  

    localparam [5:0] BLACK = 6'b000000;
    localparam [5:0] BLUE0 = 6'b000010;
    localparam [5:0] BLUE1 = 6'b000011;

    localparam [9:0] X_OFFSET_LEFT = 10'd96;
    localparam [9:0] X_OFFSET_RIGHT = 10'd544;
    localparam [9:0] BLOCKSIZE = 10'd32;

    logic river;
    logic grass;
    logic endarea;

    // tiles for XOR patterns
    logic [7:0] x4tile_x;
    logic [7:0] x4tile_y;
    logic [2:0] x4pattern;

    always_comb begin
        color = BLACK;

        x4tile_x = 0;
        x4tile_y = 0;
        x4pattern = 0;

        // make 4x4 tiles
        x4tile_x = colPos[9:2];
        x4tile_y = rowPos[9:2];

        river = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                (rowPos >= 1 * BLOCKSIZE) && (rowPos <= 7 * BLOCKSIZE);

        grass = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                ((rowPos >= 7 * BLOCKSIZE   && rowPos <= 8 * BLOCKSIZE) ||
                (rowPos >= 14 * BLOCKSIZE  && rowPos <= 15 * BLOCKSIZE));
        endarea = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                  (rowPos >= 0 * BLOCKSIZE   && rowPos <= 1 * BLOCKSIZE);

        // psuedorandom patterns with xor trick
        x4pattern[0] = x4tile_x[2] ^ x4tile_y[1];
        x4pattern[1] = x4tile_x[1] ^ x4tile_y[2];
        x4pattern[2] = x4tile_x[0] ^ x4tile_y[0];

        if (river) begin
            color = BLUE1;
        end else if (grass) begin
            case (x4pattern[2:0])
                3'b001, 3'b011: color = RED1;
                3'b101, 3'b010: color = RED0;
                default: color = BLACK;
            endcase
        end else if (endarea) begin
            case (x4pattern[2:0])
                3'b000: color = ENDAREA0;
                3'b001: color = ENDAREA1;
                3'b010: color = ENDAREA2;
                3'b011: color = ENDAREA2;
                3'b100: color = ENDAREA3;
                3'b101, 3'b110: color = ENDAREA0;
                default: color = ENDAREA3;

            endcase
        end
    end

endmodule
