module cars_gen (
    input  logic       clk,
    input  logic [9:0] colPos,
    input  logic [9:0] rowPos,
    
    input  logic [9:0] lane0_car0_x,
    input  logic [9:0] lane1_car0_x,
    input  logic [9:0] lane2_car0_x,
    input  logic [9:0] lane3_car0_x,
    input  logic [9:0] lane4_car0_x,
    input  logic [9:0] lane4_car1_x,
    input  logic [9:0] lane5_car0_x,

    // car/truck lengths
    input  logic [9:0] lane0_length,
    input  logic [9:0] lane1_length,
    input  logic [9:0] lane2_length,
    input  logic [9:0] lane3_length,
    input  logic [9:0] lane4_length,
    input  logic [9:0] lane5_length,

    output logic [5:0] color
);

    parameter BLOCKSIZE      = 10'd32;
    parameter X_OFFSET_LEFT  = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;
    
    // Lane Y coordinates
    parameter LANE0_Y = 8  * BLOCKSIZE;   // 256
    parameter LANE1_Y = 9  * BLOCKSIZE;   // 288
    parameter LANE2_Y = 10 * BLOCKSIZE;   // 320
    parameter LANE3_Y = 11 * BLOCKSIZE;   // 352
    parameter LANE4_Y = 12 * BLOCKSIZE;   // 384
    parameter LANE5_Y = 13 * BLOCKSIZE;   // 416

    localparam [5:0] CAR_BODY    = 6'b110000; // red
    localparam [5:0] CAR_ROOF    = 6'b000000; // empty
    localparam [5:0] TRUCK_BODY  = 6'b001110; // cyan
    localparam [5:0] TRUCK_CAB   = 6'b001011; // darker cab

    localparam [5:0] RV_BODY     = 6'b101011; // light grey/white
    localparam [5:0] RV_ROOF     = 6'b111111; // bright white
    localparam [5:0] STRIPE_1    = 6'b111000; // bright green/teal
    localparam [5:0] STRIPE_2    = 6'b000101; // darker green

    localparam [5:0] WINDOW_COL  = 6'b111111; // white window
    localparam [5:0] WHEEL_COL   = 6'b000001; // black wheel

    localparam [9:0] RV_THRESHOLD = BLOCKSIZE * 2;

    logic       in_car;
    logic [9:0] local_x;
    logic [9:0] local_y;
    logic [9:0] curr_length;

    logic [4:0] sprite_x;
    logic [4:0] sprite_y;
    logic [9:0] car_addr;  
    logic [5:0] car_pixel;

    car_rom car_rom (
        .addr(car_addr),
        .data(car_pixel)
    );

    always_comb begin
        color       = 6'b000000;
        in_car      = 1'b0;
        local_x     = 10'd0;
        local_y     = 10'd0;
        curr_length = 10'd0;

        sprite_x    = 5'd0;
        sprite_y    = 5'd0;
        car_addr    = 5'd0;

        // Lane 0
        if (!in_car &&
            rowPos >= LANE0_Y && rowPos < LANE0_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane0_car0_x && colPos < lane0_car0_x + lane0_length) begin
                in_car      = 1'b1;
                local_x     = colPos - lane0_car0_x;
                local_y     = rowPos - LANE0_Y;
                curr_length = lane0_length;
            end 
        end

        // Lane 1
        if (!in_car &&
            rowPos >= LANE1_Y && rowPos < LANE1_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane1_car0_x && colPos < lane1_car0_x + lane1_length) begin
                in_car      = 1'b1;
                local_x     = colPos - lane1_car0_x;
                local_y     = rowPos - LANE1_Y;
                curr_length = lane1_length;
            end 
        end

        // Lane 2
        if (!in_car &&
            rowPos >= LANE2_Y && rowPos < LANE2_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane2_car0_x && colPos < lane2_car0_x + lane2_length) begin
                in_car      = 1'b1;
                local_x     = colPos - lane2_car0_x;
                local_y     = rowPos - LANE2_Y;
                curr_length = lane2_length;
            end 
        end

        // Lane 3
        if (!in_car &&
            rowPos >= LANE3_Y && rowPos < LANE3_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane3_car0_x && colPos < lane3_car0_x + lane3_length) begin
                in_car      = 1'b1;
                local_x     = colPos - lane3_car0_x;
                local_y     = rowPos - LANE3_Y;
                curr_length = lane3_length;
            end 
        end

        // Lane 4
        if (!in_car &&
            rowPos >= LANE4_Y && rowPos < LANE4_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane4_car0_x && colPos < lane4_car0_x + lane4_length) begin
                in_car      = 1'b1;
                local_x     = colPos - lane4_car0_x;
                local_y     = rowPos - LANE4_Y;
                curr_length = lane4_length;
            end else if (colPos >= lane4_car1_x && colPos < lane4_car1_x + lane4_length) begin
                in_car      = 1'b1;
                local_x     = colPos - lane4_car1_x;
                local_y     = rowPos - LANE4_Y;
                curr_length = lane4_length; 
            end
        end

        // Lane 5
        if (!in_car &&
            rowPos >= LANE5_Y && rowPos < LANE5_Y + BLOCKSIZE &&
            colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT) begin

            if (colPos >= lane5_car0_x && colPos < lane5_car0_x + lane5_length) begin
                in_car      = 1'b1;
                local_x     = colPos - lane5_car0_x;
                local_y     = rowPos - LANE5_Y;
                curr_length = lane5_length;
            end 
        end

        // draw the current car we are in 
        if (in_car) begin
            // TRUCK
            if (curr_length > RV_THRESHOLD) begin
                // wheels & lower body
                if (local_y >= 24 && local_y < 32) begin
                    color = TRUCK_BODY;
                    if ((local_x >= 4 && local_x <= 8) ||
                        (local_x >= curr_length - 9 && local_x <= curr_length - 5)) begin
                        color = WHEEL_COL;
                    end
                end
                // trailer/cab with windows
                else if (local_y >= 10 && local_y < 24) begin
                    // cab is last BLOCKSIZE pixels
                    if (local_x >= curr_length - BLOCKSIZE) begin
                        color = TRUCK_CAB;
                        // cab window
                        if (local_y >= 12 && local_y <= 16 &&
                            local_x >= curr_length - BLOCKSIZE + 4 &&
                            local_x <= curr_length - BLOCKSIZE + 12) begin
                            color = WINDOW_COL;
                        end
                    end else begin
                        color = TRUCK_BODY;
                    end
                end
                // roof
                else begin
                    color = TRUCK_BODY;
                end
            end

            // RV
            else if (curr_length == RV_THRESHOLD) begin
                // start with RV body
                color = RV_BODY;

                // roof highlight
                if (local_y < 4 &&
                    local_x >= 4 && local_x < curr_length - 4) begin
                    color = RV_ROOF;
                end

                // main stripe around mid-height
                if (local_y >= 14 && local_y <= 17 &&
                    local_x >= 4 && local_x < curr_length - 4) begin
                    color = STRIPE_1;
                end

                // second darker stripe slightly below
                if (local_y == 18 &&
                    local_x >= 8 && local_x < curr_length - 8) begin
                    color = STRIPE_2;
                end

                // side windows (left / middle)
                if (local_y >= 8 && local_y <= 13 &&
                    local_x >= 8 && local_x <= 20) begin
                    color = WINDOW_COL;
                end
                if (local_y >= 8 && local_y <= 13 &&
                    local_x >= 24 && local_x <= 36) begin
                    color = WINDOW_COL;
                end

                // big front windshield on the right
                if (local_y >= 6 && local_y <= 14 &&
                    local_x >= curr_length - 16 && local_x <= curr_length - 4) begin
                    color = WINDOW_COL;
                end
                // headlights
                if (local_y >= 18 && local_y <=22 &&
                    (local_x >= curr_length - 5 && local_x <= curr_length - 1) ) begin
                    color = WINDOW_COL;
                end
                // wheels at bottom
                if (local_y >= 24 && local_y < 32 &&
                   ((local_x >= 9 && local_x <= 14) ||
                    (local_x >= curr_length - 18 && local_x <= curr_length - 12))) begin
                    color = WHEEL_COL;
                end
            end

            // CAR
            else begin
                sprite_x = local_x[4:0];
                sprite_y = local_y[4:0];
                car_addr = {sprite_y, sprite_x};
                color = car_pixel;
            end
        end
    end

endmodule
