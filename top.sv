module top (
    input logic osc_12M,
    output logic osc_25_1M,
    
    input logic button_up,
    input logic button_down,
    input logic button_left,
    input logic button_right,

    input logic win_button,
    
    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color,

    output logic sound
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
    logic [9:0] lane0_car0_x, lane0_car1_x, lane0_car2_x;
    logic [9:0] lane1_car0_x, lane1_car1_x, lane1_car2_x;
    logic [9:0] lane2_car0_x, lane2_car1_x, lane2_car2_x;
    logic [9:0] lane3_car0_x, lane3_car1_x, lane3_car2_x;
    logic [9:0] lane4_car0_x, lane4_car1_x, lane4_car2_x;
    logic [9:0] lane5_car0_x, lane5_car1_x, lane5_car2_x;
    // Car lengths for each lane
    logic [9:0] lane0_length, lane1_length, lane2_length, lane3_length, lane4_length, lane5_length;
    
    assign reset = 1'b0;
    
    frog frog (
        .clk(osc_25_1M),
        .state(state),
        .init_x(init_x),
        .init_y(init_y),
        .frog_size(frog_size),
        .dpad_input(dpad_input),
        .collision(collision),
        .reset(reset),
        .reached_end(reached_end),
        .next_x(next_x),
        .next_y(next_y)
    );

    cars cars_inst (
        .clk(osc_25_1M),
        .reset(reset),
        .lane0_car0_x(lane0_car0_x),
        .lane0_car1_x(lane0_car1_x),
        .lane0_car2_x(lane0_car2_x),
        .lane1_car0_x(lane1_car0_x),
        .lane1_car1_x(lane1_car1_x),
        .lane1_car2_x(lane1_car2_x),
        .lane2_car0_x(lane2_car0_x),
        .lane2_car1_x(lane2_car1_x),
        .lane2_car2_x(lane2_car2_x),
        .lane3_car0_x(lane3_car0_x),
        .lane3_car1_x(lane3_car1_x),
        .lane3_car2_x(lane3_car2_x),
        .lane4_car0_x(lane4_car0_x),
        .lane4_car1_x(lane4_car1_x),
        .lane4_car2_x(lane4_car2_x),
        .lane5_car0_x(lane5_car0_x),
        .lane5_car1_x(lane5_car1_x),
        .lane5_car2_x(lane5_car2_x),
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
        .color(frogcolor)
    );
    
    // cars rendering
    logic [5:0] carcolor;
    cars_gen cars_gen_inst (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .lane0_car0_x(lane0_car0_x),
        .lane0_car1_x(lane0_car1_x),
        .lane0_car2_x(lane0_car2_x),
        .lane1_car0_x(lane1_car0_x),
        .lane1_car1_x(lane1_car1_x),
        .lane1_car2_x(lane1_car2_x),
        .lane2_car0_x(lane2_car0_x),
        .lane2_car1_x(lane2_car1_x),
        .lane2_car2_x(lane2_car2_x),
        .lane3_car0_x(lane3_car0_x),
        .lane3_car1_x(lane3_car1_x),
        .lane3_car2_x(lane3_car2_x),
        .lane4_car0_x(lane4_car0_x),
        .lane4_car1_x(lane4_car1_x),
        .lane4_car2_x(lane4_car2_x),
        .lane5_car0_x(lane5_car0_x),
        .lane5_car1_x(lane5_car1_x),
        .lane5_car2_x(lane5_car2_x),
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
    parameter LANE0_Y = 8 * BLOCKSIZE;   // 256
    parameter LANE1_Y = 9 * BLOCKSIZE;   // 288
    parameter LANE2_Y = 10 * BLOCKSIZE;  // 320
    parameter LANE3_Y = 11 * BLOCKSIZE;  // 352
    parameter LANE4_Y = 12 * BLOCKSIZE;  // 384
    parameter LANE5_Y = 13 * BLOCKSIZE;  // 416
    
    logic frog_collision;
    always_comb begin
        // Check if frog overlaps with any car using car lengths 
        frog_collision = 
            // Lane 0 cars (3 cars)
            ((next_x < lane0_car0_x + lane0_length && next_x + frog_size > lane0_car0_x &&
              next_y < LANE0_Y + BLOCKSIZE && next_y + frog_size > LANE0_Y) ||
             (next_x < lane0_car1_x + lane0_length && next_x + frog_size > lane0_car1_x &&
              next_y < LANE0_Y + BLOCKSIZE && next_y + frog_size > LANE0_Y) ||
             (next_x < lane0_car2_x + lane0_length && next_x + frog_size > lane0_car2_x &&
              next_y < LANE0_Y + BLOCKSIZE && next_y + frog_size > LANE0_Y)) ||
            // Lane 1 cars (3 cars)
            ((next_x < lane1_car0_x + lane1_length && next_x + frog_size > lane1_car0_x &&
              next_y < LANE1_Y + BLOCKSIZE && next_y + frog_size > LANE1_Y) ||
             (next_x < lane1_car1_x + lane1_length && next_x + frog_size > lane1_car1_x &&
              next_y < LANE1_Y + BLOCKSIZE && next_y + frog_size > LANE1_Y) ||
             (next_x < lane1_car2_x + lane1_length && next_x + frog_size > lane1_car2_x &&
              next_y < LANE1_Y + BLOCKSIZE && next_y + frog_size > LANE1_Y)) ||
            // Lane 2 cars (3 cars)
            ((next_x < lane2_car0_x + lane2_length && next_x + frog_size > lane2_car0_x &&
              next_y < LANE2_Y + BLOCKSIZE && next_y + frog_size > LANE2_Y) ||
             (next_x < lane2_car1_x + lane2_length && next_x + frog_size > lane2_car1_x &&
              next_y < LANE2_Y + BLOCKSIZE && next_y + frog_size > LANE2_Y) ||
             (next_x < lane2_car2_x + lane2_length && next_x + frog_size > lane2_car2_x &&
              next_y < LANE2_Y + BLOCKSIZE && next_y + frog_size > LANE2_Y)) ||
            // Lane 3 cars (3 cars)
            ((next_x < lane3_car0_x + lane3_length && next_x + frog_size > lane3_car0_x &&
              next_y < LANE3_Y + BLOCKSIZE && next_y + frog_size > LANE3_Y) ||
             (next_x < lane3_car1_x + lane3_length && next_x + frog_size > lane3_car1_x &&
              next_y < LANE3_Y + BLOCKSIZE && next_y + frog_size > LANE3_Y) ||
             (next_x < lane3_car2_x + lane3_length && next_x + frog_size > lane3_car2_x &&
              next_y < LANE3_Y + BLOCKSIZE && next_y + frog_size > LANE3_Y)) ||
            // Lane 4 cars (3 cars)
            ((next_x < lane4_car0_x + lane4_length && next_x + frog_size > lane4_car0_x &&
              next_y < LANE4_Y + BLOCKSIZE && next_y + frog_size > LANE4_Y) ||
             (next_x < lane4_car1_x + lane4_length && next_x + frog_size > lane4_car1_x &&
              next_y < LANE4_Y + BLOCKSIZE && next_y + frog_size > LANE4_Y) ||
             (next_x < lane4_car2_x + lane4_length && next_x + frog_size > lane4_car2_x &&
              next_y < LANE4_Y + BLOCKSIZE && next_y + frog_size > LANE4_Y)) ||
            // Lane 5 cars (3 cars)
            ((next_x < lane5_car0_x + lane5_length && next_x + frog_size > lane5_car0_x &&
              next_y < LANE5_Y + BLOCKSIZE && next_y + frog_size > LANE5_Y) ||
             (next_x < lane5_car1_x + lane5_length && next_x + frog_size > lane5_car1_x &&
              next_y < LANE5_Y + BLOCKSIZE && next_y + frog_size > LANE5_Y) ||
             (next_x < lane5_car2_x + lane5_length && next_x + frog_size > lane5_car2_x &&
              next_y < LANE5_Y + BLOCKSIZE && next_y + frog_size > LANE5_Y));
    end
    
    assign collision = frog_collision;

    // color priority: frog > cars > background
    always_comb begin
        if (frogcolor != 6'b000000) begin
            color = frogcolor;
        end else if (carcolor != 6'b000000) begin
            color = carcolor;
        end else begin
            color = bgcolor;
        end
    end



    topAudio topAudio (
        .clk(osc_25_1M),
        .jumpForward(button_up),
        .jumpBackward(button_down),
        .jumpRight(button_right),
        .jumpLeft(button_left),
    
        .win(win_button),
        // .lose,
        .sound(sound)
    );


endmodule
