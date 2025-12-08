module logs_gen(
    input logic clk, 
    
    input logic [9:0] colPos,
    input logic [9:0] rowPos,

// three logs for each of the six lanes
    input logic [9:0] lane0_log0_x,
    input logic [9:0] lane0_log1_x,
    input logic [9:0] lane0_log2_x,
    
    input logic [9:0] lane1_log0_x,
    input logic [9:0] lane1_log1_x,

    input logic [9:0] lane2_log0_x,
    input logic [9:0] lane2_log1_x,

    input logic [9:0] lane3_log0_x,
    input logic [9:0] lane3_log1_x,

    input logic [9:0] lane4_log0_x,
    input logic [9:0] lane4_log1_x,

    input logic [9:0] lane5_log0_x,
    input logic [9:0] lane5_log1_x,

    // log lengths and color 
    input logic [9:0] lane0_loglength,
    input logic [9:0] lane1_loglength,
    input logic [9:0] lane2_loglength,
    input logic [9:0] lane3_loglength,
    input logic [9:0] lane4_loglength,
    input logic [9:0] lane5_loglength,
    output logic [5:0] color
); 

    parameter BLOCKSIZE = 10'd32;
    parameter X_OFFSET_LEFT  = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;


    // coordinates for the river lanes 
    parameter LANE0_Y = 1  * BLOCKSIZE;   // 256
    parameter LANE1_Y = 2  * BLOCKSIZE;   // 288
    parameter LANE2_Y = 3 * BLOCKSIZE;   // 320
    parameter LANE3_Y = 4 * BLOCKSIZE;   // 352
    parameter LANE4_Y = 5 * BLOCKSIZE;   // 384
    parameter LANE5_Y = 6 * BLOCKSIZE;   // 416

    // wood colors 
    localparam [5:0] LOG_BODY = 6'b100101; 

    logic in_log; 
    logic [9:0] local_x;
    logic [9:0] local_y;
    logic [9:0] curr_length;
    logic [11:0] sprite_addr;
    logic [5:0] sprite_color; 

    logic [4:0] tile_x, tile_y; 
    logic [4:0] seg_index;
    logic [4:0] num_segments;
    logic [1:0] part_sel;     

    log_rom log_sprite_rom (
        .addr(sprite_addr),
        .data(sprite_color),
    );


    always_comb begin 
        color       = 6'b000000;
        in_log      = 1'b0;
        local_x     = 10'd0;
        local_y     = 10'd0;
        curr_length = 10'd0;
        
        sprite_addr = 6'd0;
        tile_x       = 5'd0;
        tile_y       = 5'd0;
        seg_index    = 5'd0;
        num_segments = 5'd0;
        part_sel     = 2'd1;

        // lane 0
        if (!in_log &&
            rowPos >= LANE0_Y && rowPos < LANE0_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane0_log0_x && colPos < lane0_log0_x + lane0_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane0_log0_x;
                local_y     = rowPos - LANE0_Y;
                curr_length = lane0_loglength;
            end else if (colPos >= lane0_log1_x && colPos < lane0_log1_x + lane0_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane0_log1_x;
                local_y     = rowPos - LANE0_Y;
                curr_length = lane0_loglength;
            end
            if (colPos >= lane0_log2_x && colPos < lane0_log2_x + lane0_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane0_log2_x;
                local_y     = rowPos - LANE0_Y;
                curr_length = lane0_loglength;
            end
        end

        // lane 1
        if (!in_log &&
            rowPos >= LANE1_Y && rowPos < LANE1_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane1_log0_x && colPos < lane1_log0_x + lane1_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane1_log0_x;
                local_y     = rowPos - LANE1_Y;
                curr_length = lane1_loglength;
            end else if (colPos >= lane1_log1_x && colPos < lane1_log1_x + lane1_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane1_log1_x;
                local_y     = rowPos - LANE1_Y;
                curr_length = lane1_loglength;
            end
        end

        // lane 2

        if (!in_log &&
            rowPos >= LANE2_Y && rowPos < LANE2_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane2_log0_x && colPos < lane2_log0_x + lane2_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane2_log0_x;
                local_y     = rowPos - LANE2_Y;
                curr_length = lane2_loglength;
            end else if (colPos >= lane2_log1_x && colPos < lane2_log1_x + lane2_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane2_log1_x;
                local_y     = rowPos - LANE2_Y;
                curr_length = lane2_loglength;
            end
        end

        // lane 3

        if (!in_log &&
            rowPos >= LANE3_Y && rowPos < LANE3_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane3_log0_x && colPos < lane3_log0_x + lane3_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane3_log0_x;
                local_y     = rowPos - LANE3_Y;
                curr_length = lane3_loglength;
            end else if (colPos >= lane3_log1_x && colPos < lane3_log1_x + lane3_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane3_log1_x;
                local_y     = rowPos - LANE3_Y;
                curr_length = lane3_loglength;
            end
        end

        // lane 4
        if (!in_log &&
            rowPos >= LANE4_Y && rowPos < LANE4_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane4_log0_x && colPos < lane4_log0_x + lane4_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane4_log0_x;
                local_y     = rowPos - LANE4_Y;
                curr_length = lane4_loglength;
            end else if (colPos >= lane4_log1_x && colPos < lane4_log1_x + lane4_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane4_log1_x;
                local_y     = rowPos - LANE4_Y;
                curr_length = lane4_loglength;
            end
        end

        // lane 5
        if (!in_log &&
            rowPos >= LANE5_Y && rowPos < LANE5_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane5_log0_x && colPos < lane5_log0_x + lane5_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane5_log0_x;
                local_y     = rowPos - LANE5_Y;
                curr_length = lane5_loglength;
            end else if (colPos >= lane5_log1_x && colPos < lane5_log1_x + lane5_loglength) begin
                in_log      = 1'b1;
                local_x     = colPos - lane5_log1_x;
                local_y     = rowPos - LANE5_Y;
                curr_length = lane5_loglength;
            end
        end

        if (in_log) begin
            seg_index = local_x[9:5];
            tile_x    = local_x[4:0];
            tile_y    = local_y[4:0];
            num_segments = curr_length[9:5];

            // choose which part of the log to use
            if (seg_index == 5'd0) begin
                // back
                part_sel = 2'd0;
            end else if (seg_index == (num_segments - 1)) begin
                // front
                part_sel = 2'd2;
            end else begin
                // middle
                part_sel = 2'd1;
            end
            sprite_addr = {part_sel, tile_y, tile_x};
            color = sprite_color;
        end else begin 
            color = 6'b000000; 
        end 
    end

endmodule 