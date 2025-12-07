module top (
    input logic osc_12M,
    output logic osc_25_1M,
    
    input logic button_up,
    input logic button_down,
    input logic button_left,
    input logic button_right,
    
    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color,
);

    mypll mypll_inst(
        .ref_clk_i(osc_12M),
        .rst_n_i(1'b1),
        .outglobal_o(osc_25_1M)
    );

    logic [9:0] colPos;
    logic [9:0] rowPos;

    vga vga (
        .clk(osc_25_1M),
        .HSYNC(HSYNC),
        .VSYNC(VSYNC),
        .colPos(colPos),
        .rowPos(rowPos)
    );

    logic [1:0] state = 2'b01;
    logic [3:0] dpad_input;
    logic collision;
    logic reset;
    logic reached_end;
    
    assign dpad_input = {button_right, button_up, button_down, button_left};
    
    // frog positioning parameters
    parameter init_x = 320;
    parameter init_y = 448;  // Start at the bottom (480 - frog_size = 448)
    parameter frog_size = 32;
    
    
    logic [9:0] next_x;
    logic [9:0] next_y;
    
    // instantiate cars
    logic [9:0] lane0_car0_x;
    logic [9:0] lane1_car0_x;
    logic [9:0] lane2_car0_x;
    logic [9:0] lane3_car0_x;
    logic [9:0] lane4_car0_x;
    logic [9:0] lane5_car0_x;
    // Car lengths for each lane
    logic [9:0] lane0_length, lane1_length, lane2_length, lane3_length, lane4_length, lane5_length;

    // instantiate logs
    logic [9:0] lane0_log0_x, lane0_log1_x, lane0_log2_x;
    logic [9:0] lane1_log0_x, lane1_log1_x, lane1_log2_x;
    logic [9:0] lane2_log0_x, lane2_log1_x, lane2_log2_x;
    logic [9:0] lane3_log0_x, lane3_log1_x, lane3_log2_x;
    logic [9:0] lane4_log0_x, lane4_log1_x, lane4_log2_x;
    logic [9:0] lane5_log0_x, lane5_log1_x, lane5_log2_x;
    // Log lengths for each lane
    logic [9:0] lane0_loglength, lane1_loglength, lane2_loglength, lane3_loglength, lane4_loglength, lane5_loglength;
    
    assign reset = 1'b0;
    
    // turn the frog to the direction the user inputs
    logic [1:0] facing;

    frog frog (
        .clk(osc_25_1M),
        .state(state),
        .init_x(init_x),
        .init_y(init_y),
        .frog_size(frog_size),
        .reached_end(reached_end),
        .dpad_input(dpad_input),
        .collision(collision),
        .reset(reset),
        .next_x(next_x),
        .next_y(next_y),
        .facing(facing)
    );

    logs logs_inst (   
        .clk(osc_25_1M),
        .reset(reset),
        .lane0_log0_x(lane0_log0_x),
        .lane0_log1_x(lane0_log1_x),
        .lane0_log2_x(lane0_log2_x),
        .lane1_log0_x(lane1_log0_x),
        .lane1_log1_x(lane1_log1_x),
        .lane1_log2_x(lane1_log2_x),
        .lane2_log0_x(lane2_log0_x),
        .lane2_log1_x(lane2_log1_x),
        .lane2_log2_x(lane2_log2_x),
        .lane3_log0_x(lane3_log0_x),
        .lane3_log1_x(lane3_log1_x),
        .lane3_log2_x(lane3_log2_x),
        .lane4_log0_x(lane4_log0_x),
        .lane4_log1_x(lane4_log1_x),
        .lane4_log2_x(lane4_log2_x),
        .lane5_log0_x(lane5_log0_x),
        .lane5_log1_x(lane5_log1_x),
        .lane5_log2_x(lane5_log2_x),
        .lane0_loglength(lane0_loglength),
        .lane1_loglength(lane1_loglength),
        .lane2_loglength(lane2_loglength),
        .lane3_loglength(lane3_loglength),
        .lane4_loglength(lane4_loglength),
        .lane5_loglength(lane5_loglength)
    );

    cars cars_inst (
        .clk(osc_25_1M),
        .reset(reset),
        .lane0_car0_x(lane0_car0_x),
        .lane1_car0_x(lane1_car0_x),
        .lane2_car0_x(lane2_car0_x),
        .lane3_car0_x(lane3_car0_x),
        .lane4_car0_x(lane4_car0_x),
        .lane5_car0_x(lane5_car0_x),
        .lane0_length(lane0_length),
        .lane1_length(lane1_length),
        .lane2_length(lane2_length),
        .lane3_length(lane3_length),
        .lane4_length(lane4_length),
        .lane5_length(lane5_length)
    );
    
    logic [5:0] frogcolor;  
    frog_gen frog_gen (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .frog_x(next_x),
        .frog_y(next_y),
        .frog_size(frog_size),
        .facing(facing),
        .color(frogcolor)
    );

    // logs rendering
    logic [5:0] logcolor;
    logs_gen logs_gen_inst (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .lane0_log0_x(lane0_log0_x),
        .lane0_log1_x(lane0_log1_x),
        .lane0_log2_x(lane0_log2_x),
        .lane1_log0_x(lane1_log0_x),
        .lane1_log1_x(lane1_log1_x),
        .lane1_log2_x(lane1_log2_x),
        .lane2_log0_x(lane2_log0_x),
        .lane2_log1_x(lane2_log1_x),
        .lane2_log2_x(lane2_log2_x),
        .lane3_log0_x(lane3_log0_x),
        .lane3_log1_x(lane3_log1_x),
        .lane3_log2_x(lane3_log2_x),
        .lane4_log0_x(lane4_log0_x),
        .lane4_log1_x(lane4_log1_x),
        .lane4_log2_x(lane4_log2_x),
        .lane5_log0_x(lane5_log0_x),
        .lane5_log1_x(lane5_log1_x),
        .lane5_log2_x(lane5_log2_x),
        .lane0_loglength(lane0_loglength),
        .lane1_loglength(lane1_loglength),
        .lane2_loglength(lane2_loglength),
        .lane3_loglength(lane3_loglength),
        .lane4_loglength(lane4_loglength),
        .lane5_loglength(lane5_loglength),
        .color(logcolor)
    );
    
    // cars rendering
    logic [5:0] carcolor;
    cars_gen cars_gen_inst (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .lane0_car0_x(lane0_car0_x),
        .lane1_car0_x(lane1_car0_x),
        .lane2_car0_x(lane2_car0_x),
        .lane3_car0_x(lane3_car0_x),
        .lane4_car0_x(lane4_car0_x),
        .lane5_car0_x(lane5_car0_x),
        .lane0_length(lane0_length),
        .lane1_length(lane1_length),
        .lane2_length(lane2_length),
        .lane3_length(lane3_length),
        .lane4_length(lane4_length),
        .lane5_length(lane5_length),
        .color(carcolor)
    );
    // grid/window color
    logic [5:0] gridcolor;
    logic window_display_enable;
    window window (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .display_enable(window_display_enable),
        .color(gridcolor)
    );

    // Background color
    logic [5:0] bgcolor;
    background bg (
        .on(1'b1),  // always enabled - background should always render
        .colPos(colPos),
        .rowPos(rowPos),
        .color(bgcolor)
    );

    // collision detection between frog and cars
    parameter BLOCKSIZE = 10'd32;
    parameter CAR_LANE0_Y = 8 * BLOCKSIZE;   // 256
    parameter CAR_LANE1_Y = 9 * BLOCKSIZE;   // 288
    parameter CAR_LANE2_Y = 10 * BLOCKSIZE;  // 320
    parameter CAR_LANE3_Y = 11 * BLOCKSIZE;  // 352
    parameter CAR_LANE4_Y = 12 * BLOCKSIZE;  // 384
    parameter CAR_LANE5_Y = 13 * BLOCKSIZE;  // 416
    
    parameter LOG_LANE0_Y = 1 * BLOCKSIZE;
    parameter LOG_LANE1_Y = 2 * BLOCKSIZE;
    parameter LOG_LANE2_Y = 3 * BLOCKSIZE;
    parameter LOG_LANE3_Y = 4 * BLOCKSIZE;
    parameter LOG_LANE4_Y = 5 * BLOCKSIZE;
    parameter LOG_LANE5_Y = 6 * BLOCKSIZE;
    
    logic frog_collision;
    logic log_collision;
    always_comb begin
        // Check if frog overlaps with any car using car lengths 
        log_collision = 1'b1;
        frog_collision =
            // Lane 0 cars (3 cars)
            ((next_x < lane0_car0_x + lane0_length && next_x + frog_size > lane0_car0_x &&
              next_y < CAR_LANE0_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE0_Y)) ||

            // Lane 1 cars (3 cars)
            ((next_x < lane1_car0_x + lane1_length && next_x + frog_size > lane1_car0_x &&
              next_y < CAR_LANE1_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE1_Y)) ||

            // Lane 2 cars (3 cars)
            ((next_x < lane2_car0_x + lane2_length && next_x + frog_size > lane2_car0_x &&
              next_y < CAR_LANE2_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE2_Y)) ||

            // Lane 3 cars (3 cars)
            ((next_x < lane3_car0_x + lane3_length && next_x + frog_size > lane3_car0_x &&
              next_y < CAR_LANE3_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE3_Y)) ||
  
            // Lane 4 cars (3 cars)
            ((next_x < lane4_car0_x + lane4_length && next_x + frog_size > lane4_car0_x &&
              next_y < CAR_LANE4_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE4_Y) ||

            // Lane 5 cars (3 cars)
            ((next_x < lane5_car0_x + lane5_length && next_x + frog_size > lane5_car0_x &&
              next_y < CAR_LANE5_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE5_Y)));
        if (next_y < 224 && next_y > 32) begin
            log_collision = 
                // Lane 0 logs (3 logs)
                ((next_x < lane0_log0_x + lane0_loglength && next_x + frog_size > lane0_log0_x &&
                next_y < LOG_LANE0_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE0_Y) ||
                (next_x < lane0_log1_x + lane0_loglength && next_x + frog_size > lane0_log1_x &&
                next_y < LOG_LANE0_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE0_Y) ||
                (next_x < lane0_log2_x + lane0_loglength && next_x + frog_size > lane0_log2_x &&
                next_y < LOG_LANE0_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE0_Y)) ||
                // Lane 1 logs (3 logs)
                ((next_x < lane1_log0_x + lane1_loglength && next_x + frog_size > lane1_log0_x &&
                next_y < LOG_LANE1_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE1_Y) ||
                (next_x < lane1_log1_x + lane1_loglength && next_x + frog_size > lane1_log1_x &&
                next_y < LOG_LANE1_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE1_Y) ||
                (next_x < lane1_log2_x + lane1_loglength && next_x + frog_size > lane1_log2_x &&
                next_y < LOG_LANE1_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE1_Y)) ||
                // Lane 2 logs (3 logs)
                ((next_x < lane2_log0_x + lane2_loglength && next_x + frog_size > lane2_log0_x &&
                next_y < LOG_LANE2_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE2_Y) ||
                (next_x < lane2_log1_x + lane2_loglength && next_x + frog_size > lane2_log1_x &&
                next_y < LOG_LANE2_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE2_Y) ||
                (next_x < lane2_log2_x + lane2_loglength && next_x + frog_size > lane2_log2_x &&
                next_y < LOG_LANE2_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE2_Y)) ||
                // Lane 3 logs (3 logs)
                ((next_x < lane3_log0_x + lane3_loglength && next_x + frog_size > lane3_log0_x &&
                next_y < LOG_LANE3_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE3_Y) ||
                (next_x < lane3_log1_x + lane3_loglength && next_x + frog_size > lane3_log1_x &&
                next_y < LOG_LANE3_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE3_Y) ||
                (next_x < lane3_log2_x + lane3_loglength && next_x + frog_size > lane3_log2_x &&
                next_y < LOG_LANE3_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE3_Y)) ||
                // Lane 4 logs (3 logs)
                ((next_x < lane4_log0_x + lane4_loglength && next_x + frog_size > lane4_log0_x &&
                next_y < LOG_LANE4_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE4_Y) ||
                (next_x < lane4_log1_x + lane4_loglength && next_x + frog_size > lane4_log1_x &&
                next_y < LOG_LANE4_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE4_Y) ||
                (next_x < lane4_log2_x + lane4_loglength && next_x + frog_size > lane4_log2_x &&
                next_y < LOG_LANE4_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE4_Y)) ||
                // Lane 5 logs (3 logs)
                ((next_x < lane5_log0_x + lane5_loglength && next_x + frog_size > lane5_log0_x &&
                next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y) ||
                (next_x < lane5_log1_x + lane5_loglength && next_x + frog_size > lane5_log1_x &&
                next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y) ||
                (next_x < lane5_log2_x + lane5_loglength && next_x + frog_size > lane5_log2_x &&
                next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y));
        end
    end
    
    // reset if collision or reached end
    logic off_screen;
    // assign off_screen = next_x > 544 || next_x < 96;
    assign collision = frog_collision || !log_collision;

    logic reached_end;

    // check if we've reached the end
    always_comb begin
        reached_end = next_y < 32;
    end

    always_ff @(posedge clk) begin
        if (!reset) begin
    
            // --- Frog rides lane 0 logs ---
            if (next_y >= lane0_Y && next_y < lane0_Y + BLOCKSIZE) begin
                if ((next_x + frog_size > lane0_log0_x && next_x < lane0_log0_x + lane0_loglength) ||
                    (next_x + frog_size > lane0_log1_x && next_x < lane0_log1_x + lane0_loglength) ||
                    (next_x + frog_size > lane0_log2_x && next_x < lane0_log2_x + lane0_loglength)) begin
                    // lane 0 logs move right (or left depending on your game)
                    frog_x <= frog_x + 1; 
                end
            end
            if (next_y >= lane1_Y && next_y < lane1_Y + BLOCKSIZE) begin
                if ((next_x + frog_size > lane1_log0_x && next_x < lane1_log0_x + lane1_loglength) ||
                    (next_x + frog_size > lane1_log1_x && next_x < lane1_log1_x + lane1_loglength) ||
                    (next_x + frog_size > lane1_log2_x && next_x < lane1_log2_x + lane1_loglength)) begin
                    frog_x <= frog_x + 1; 
                end
            end
            if (next_y >= lane2_Y && next_y < lane2_Y + BLOCKSIZE) begin
                if ((next_x + frog_size > lane2_log0_x && next_x < lane2_log0_x + lane2_loglength) ||
                    (next_x + frog_size > lane2_log1_x && next_x < lane2_log1_x + lane2_loglength) ||
                    (next_x + frog_size > lane2_log2_x && next_x < lane2_log2_x + lane2_loglength)) begin
                    // lane 0 logs move right (or left depending on your game)
                    frog_x <= frog_x + 1; 
                end
            end
            if (next_y >= lane3_Y && next_y < lane3_Y + BLOCKSIZE) begin
                if ((next_x + frog_size > lane3_log0_x && next_x < lane3_log0_x + lane3_loglength) ||
                    (next_x + frog_size > lane3_log1_x && next_x < lane3_log1_x + lane3_loglength) ||
                    (next_x + frog_size > lane3_log2_x && next_x < lane3_log2_x + lane3_loglength)) begin
                    // lane 0 logs move right (or left depending on your game)
                    frog_x <= frog_x + 1; 
                end
            end
            if (next_y >= lane4_Y && next_y < lane4_Y + BLOCKSIZE) begin
                if ((next_x + frog_size > lane4_log0_x && next_x < lane4_log0_x + lane4_loglength) ||
                    (next_x + frog_size > lane4_log1_x && next_x < lane4_log1_x + lane4_loglength) ||
                    (next_x + frog_size > lane4_log2_x && next_x < lane4_log2_x + lane4_loglength)) begin
                    // lane 0 logs move right (or left depending on your game)
                    frog_x <= frog_x + 1; 
                end
            end
            if (next_x < lane5_log0_x + lane5_loglength && next_x + frog_size > lane5_log0_x &&
                next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y) ||
                (next_x < lane5_log1_x + lane5_loglength && next_x + frog_size > lane5_log1_x &&
                next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y) ||
                (next_x < lane5_log2_x + lane5_loglength && next_x + frog_size > lane5_log2_x &&
                next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y) begin
                    frog_x <= frog_x + 1;
                end
            end
        end
    end

    // color priority: frog > cars > background
    always_comb begin
        if (frogcolor != 6'b000000) begin
            color = frogcolor;
        end else if (logcolor != 6'b000000) begin
            color = logcolor;
        end else if (carcolor != 6'b000000) begin
            color = carcolor;
        end else begin
            color = bgcolor;
        end
    end


endmodule
