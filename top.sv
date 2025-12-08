module top (
    input logic osc_12M,
    output logic osc_25_1M,
    
    input logic button_up,
    input logic button_down,
    input logic button_left,
    input logic button_right,

    input logic button_reset,
    
    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color,

    output logic sound
);

    parameter BLACK = 6'b000000;


    /*********************************************
     *
     *                  SETUP      
     *
     *********************************************/

    // VGA Instantiation =================================================
    mypll mypll_inst(
        .ref_clk_i(osc_12M),
        .rst_n_i(1'b1),
        .outglobal_o(osc_25_1M)
    );
    logic [3:0] reset_starter = 0;
    always_ff @(posedge osc_25_1M) begin
        if (!reset_starter[3]) begin
            reset_starter <= reset_starter + 1;
        end
    end
    assign reset = ~reset_starter[3];

    logic [9:0] colPos;
    logic [9:0] rowPos;

    vga vga (
        .clk(osc_25_1M),
        .HSYNC(HSYNC),
        .VSYNC(VSYNC),
        .colPos(colPos),
        .rowPos(rowPos)
    );

    topAudio topAudio (
        .clk(osc_25_1M),
        .jumpForward(button_up),
        .jumpBackward(button_down),
        .jumpRight(button_right),
        .jumpLeft(button_left),
    
        .win(win),
        .lose(lose),
        .sound(sound)
    );


    /*********************************************
     *
     *                GAME STATE
     *
     *********************************************/

    gamestate gamestate (
        .clk(osc_25_1M),
        .reset(reset),
        .dpad_input(dpad_input),
        .collision(collision),
        .reached_end(reached_end),
        .state(state),
        .level(level),
        .soundselector(soundselector),
        .playsound(playsound),
        .win(win),
        .lose(lose)
    );



    // Game logic and controls ===========================================
    enum logic [1:0] {MENU, PLAYING, DEAD, WIN} statetype;
    enum logic [1:0] {UI_PRESS, NEXTLEVEL, CRASH, CELEBRATION} soundtype;

    logic [1:0] state;
    logic [3:0] dpad_input;
    logic collision;
    logic reset;
    logic reached_end;
    logic [3:0] level;
    // The below are for playing sounds on level changes
    logic [1:0] soundselector;
    logic playsound;
    logic win;
    logic lose;

    assign reset = ~button_reset;
    assign dpad_input = {button_right, button_up, button_down, button_left};

    // Debouncing buttons ================================================
    logic btn_up_tick;
    logic btn_down_tick;
    logic btn_left_tick;
    logic btn_right_tick;

    // frog positioning parameters
    parameter init_x = 10'd320;
    parameter init_y = 10'd448;  // Start at the bottom (480 - frog_size = 448)
    parameter frog_size = 10'd32;

    debounce db_up (
        .clk(osc_25_1M),
        .reset(reset),
        .btn_in(button_up),
        .db_level(),
        .db_tick(btn_up_tick)
    );

    debounce db_down (
        .clk(osc_25_1M),
        .reset(reset),
        .btn_in(button_down),
        .db_level(),
        .db_tick(btn_down_tick)
    );
    
    debounce db_left (
        .clk(osc_25_1M),
        .reset(reset),
        .btn_in(button_left),
        .db_level(),
        .db_tick(btn_left_tick)
    );
    
    debounce db_right (
        .clk(osc_25_1M),
        .reset(reset),
        .btn_in(button_right),
        .db_level(),
        .db_tick(btn_right_tick)
    );    

    // frog positioning parameters ========================================
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
    logic [9:0] lane4_car1_x;
    logic [9:0] lane5_car0_x;
    // Car lengths for each lane
    logic [9:0] lane0_length, lane1_length, lane2_length, lane3_length, lane4_length, lane5_length;

    // instantiate logs
    logic [9:0] lane0_log0_x, lane0_log1_x, lane0_log2_x;
    logic [9:0] lane1_log0_x, lane1_log1_x;
    logic [9:0] lane2_log0_x, lane2_log1_x;
    logic [9:0] lane3_log0_x, lane3_log1_x;
    logic [9:0] lane4_log0_x, lane4_log1_x;
    logic [9:0] lane5_log0_x, lane5_log1_x;
    logic [9:0] lane0_loglength, lane1_loglength, lane2_loglength, lane3_loglength, lane4_loglength, lane5_loglength;
    logic [9:0] lane0_log_speed, lane1_log_speed, lane2_log_speed, lane3_log_speed, lane4_log_speed, lane5_log_speed;
    
    logic [3:0] reset_starter = 0;
    always_ff @(posedge osc_25_1M) begin
        if (!reset_starter[3]) begin
            reset_starter <= reset_starter + 1;
        end
    end
    assign reset = ~reset_starter[3];
    // turn the frog to the direction the user inputs
    logic [1:0] facing;

    logic in_lane0_log;
    logic in_lane1_log;
    logic in_lane2_log;
    logic in_lane3_log;
    logic in_lane4_log;
    logic in_lane5_log;

    frog frog (
        .clk(osc_25_1M),
        .state(state),
        .init_x(init_x),
        .init_y(init_y),
        .frog_size(frog_size),
        .btn_up_tick(btn_up_tick),
        .btn_down_tick(btn_down_tick),
        .btn_left_tick(btn_left_tick),
        .btn_right_tick(btn_right_tick),
        .collision(collision),
        .reset(reset),
        .lane0_log_speed(lane0_log_speed),
        .lane1_log_speed(lane1_log_speed),
        .lane2_log_speed(lane2_log_speed),
        .lane3_log_speed(lane3_log_speed),
        .lane4_log_speed(lane4_log_speed),
        .lane5_log_speed(lane5_log_speed),
        .in_lane0_log(in_lane0_log),
        .in_lane1_log(in_lane1_log),
        .in_lane2_log(in_lane2_log),
        .in_lane3_log(in_lane3_log),
        .in_lane4_log(in_lane4_log),
        .in_lane5_log(in_lane5_log),
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
        .lane2_log0_x(lane2_log0_x),
        .lane2_log1_x(lane2_log1_x),
        .lane3_log0_x(lane3_log0_x),
        .lane3_log1_x(lane3_log1_x),
        .lane4_log0_x(lane4_log0_x),
        .lane4_log1_x(lane4_log1_x),
        .lane5_log0_x(lane5_log0_x),
        .lane5_log1_x(lane5_log1_x),
        .lane0_log_speed(lane0_log_speed),
        .lane1_log_speed(lane1_log_speed),
        .lane2_log_speed(lane2_log_speed),
        .lane3_log_speed(lane3_log_speed),
        .lane4_log_speed(lane4_log_speed),
        .lane5_log_speed(lane5_log_speed),
        .lane0_loglength(lane0_loglength),
        .lane1_loglength(lane1_loglength),
        .lane2_loglength(lane2_loglength),
        .lane3_loglength(lane3_loglength),
        .lane4_loglength(lane4_loglength),
        .lane5_loglength(lane5_loglength)
    );

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
        .lane2_log0_x(lane2_log0_x),
        .lane2_log1_x(lane2_log1_x),
        .lane3_log0_x(lane3_log0_x),
        .lane3_log1_x(lane3_log1_x),
        .lane4_log0_x(lane4_log0_x),
        .lane4_log1_x(lane4_log1_x),
        .lane5_log0_x(lane5_log0_x),
        .lane5_log1_x(lane5_log1_x),
        .lane0_loglength(lane0_loglength),
        .lane1_loglength(lane1_loglength),
        .lane2_loglength(lane2_loglength),
        .lane3_loglength(lane3_loglength),
        .lane4_loglength(lane4_loglength),
        .lane5_loglength(lane5_loglength),
        .color(logcolor)
    );
    // Cars logic =========================================================
    cars cars_inst (
        .clk(osc_25_1M),
        .reset(reset),
        .lane0_car0_x(lane0_car0_x),
        .lane1_car0_x(lane1_car0_x),
        .lane2_car0_x(lane2_car0_x),
        .lane3_car0_x(lane3_car0_x),
        .lane4_car0_x(lane4_car0_x),
        .lane4_car1_x(lane4_car1_x),
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
        .lane4_car1_x(lane4_car1_x),
        .lane5_car0_x(lane5_car0_x),
        .lane0_length(lane0_length),
        .lane1_length(lane1_length),
        .lane2_length(lane2_length),
        .lane3_length(lane3_length),
        .lane4_length(lane4_length),
        .lane5_length(lane5_length),
        .color(carcolor)
    );
    //grid/window color
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
        .on(1'b1),
        .colPos(colPos),
        .rowPos(rowPos),
        .color(bgcolor)
    );
    // =====================================================================
    
    
    // collision detection between frog and cars ==========================
    parameter BLOCKSIZE = 10'd32;
    parameter CAR_LANE0_Y = 8 * BLOCKSIZE;   // 256
    parameter CAR_LANE1_Y = 9 * BLOCKSIZE;   // 288
    parameter CAR_LANE2_Y = 10 * BLOCKSIZE;  // 320
    parameter CAR_LANE3_Y = 11 * BLOCKSIZE;  // 352
    parameter CAR_LANE4_Y = 12 * BLOCKSIZE;  // 384
    parameter CAR_LANE5_Y = 13 * BLOCKSIZE;  // 416
    
    parameter LOG_LANE0_Y = BLOCKSIZE;
    parameter LOG_LANE1_Y = 2 * BLOCKSIZE;
    parameter LOG_LANE2_Y = 3 * BLOCKSIZE;
    parameter LOG_LANE3_Y = 4 * BLOCKSIZE;
    parameter LOG_LANE4_Y = 5 * BLOCKSIZE;
    parameter LOG_LANE5_Y = 6 * BLOCKSIZE;
    
    logic frog_collision;
    logic in_water;
    logic off_screen;
    logic reached_end;

    logic signed [3:0] log_dx; // for every one

    always_comb begin
        // Check if frog overlaps with any car using car lengths 
        in_water = 1'b0;
        log_dx = 1'b0;
        in_lane0_log = 1'b0;
        in_lane1_log = 1'b0;
        in_lane2_log = 1'b0;
        in_lane3_log = 1'b0;
        in_lane4_log = 1'b0;
        in_lane5_log = 1'b0;

        frog_collision =
        ((next_x < lane0_car0_x + lane0_length && next_x + frog_size > lane0_car0_x &&
            next_y < CAR_LANE0_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE0_Y)) ||

        ((next_x < lane1_car0_x + lane1_length && next_x + frog_size > lane1_car0_x &&
            next_y < CAR_LANE1_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE1_Y)) ||

        ((next_x < lane2_car0_x + lane2_length && next_x + frog_size > lane2_car0_x &&
            next_y < CAR_LANE2_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE2_Y)) ||

        ((next_x < lane3_car0_x + lane3_length && next_x + frog_size > lane3_car0_x &&
            next_y < CAR_LANE3_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE3_Y)) ||

        ((next_x < lane4_car0_x + lane4_length && next_x + frog_size > lane4_car0_x &&
            next_y < CAR_LANE4_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE4_Y) ||
            (next_x < lane4_car1_x + lane4_length && next_x + frog_size > lane4_car1_x &&
            next_y < CAR_LANE4_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE4_Y)) ||

        ((next_x < lane5_car0_x + lane5_length && next_x + frog_size > lane5_car0_x &&
            next_y < CAR_LANE5_Y + BLOCKSIZE && next_y + frog_size > CAR_LANE5_Y));

        in_lane0_log = 
            ((next_x < lane0_log0_x + lane0_loglength && next_x + frog_size > lane0_log0_x &&
            next_y < LOG_LANE0_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE0_Y) ||
            (next_x < lane0_log1_x + lane0_loglength && next_x + frog_size > lane0_log1_x &&
            next_y < LOG_LANE0_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE0_Y) || 
            (next_x < lane0_log2_x + lane0_loglength && next_x + frog_size > lane0_log2_x &&
            next_y < LOG_LANE0_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE0_Y));
        in_lane1_log =
            ((next_x < lane1_log0_x + lane1_loglength && next_x + frog_size > lane1_log0_x &&
            next_y < LOG_LANE1_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE1_Y) ||
            (next_x < lane1_log1_x + lane1_loglength && next_x + frog_size > lane1_log1_x &&
            next_y < LOG_LANE1_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE1_Y));
        in_lane2_log =
            ((next_x < lane2_log0_x + lane2_loglength && next_x + frog_size > lane2_log0_x &&
            next_y < LOG_LANE2_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE2_Y) ||
            (next_x < lane2_log1_x + lane2_loglength && next_x + frog_size > lane2_log1_x &&
            next_y < LOG_LANE2_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE2_Y));
        in_lane3_log =
            ((next_x < lane3_log0_x + lane3_loglength && next_x + frog_size > lane3_log0_x &&
            next_y < LOG_LANE3_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE3_Y) ||
            (next_x < lane3_log1_x + lane3_loglength && next_x + frog_size > lane3_log1_x &&
            next_y < LOG_LANE3_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE3_Y));
        in_lane4_log =
            ((next_x < lane4_log0_x + lane4_loglength && next_x + frog_size > lane4_log0_x &&
            next_y < LOG_LANE4_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE4_Y) ||
            (next_x < lane4_log1_x + lane4_loglength && next_x + frog_size > lane4_log1_x &&
            next_y < LOG_LANE4_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE4_Y));
        in_lane5_log =
            ((next_x < lane5_log0_x + lane5_loglength && next_x + frog_size > lane5_log0_x &&
            next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y) ||
            (next_x < lane5_log1_x + lane5_loglength && next_x + frog_size > lane5_log1_x &&
            next_y < LOG_LANE5_Y + BLOCKSIZE && next_y + frog_size > LOG_LANE5_Y));

        in_water = (next_y < 224 && next_y >= 32) && !(in_lane0_log || in_lane1_log || in_lane2_log || in_lane3_log || in_lane4_log || in_lane5_log);

        // check if off screen
        off_screen = next_x + 32 <= 96 || next_x >= 576;
        reached_end = next_y < 32;

    end
    
    // go back to starting position if collision
    assign collision = frog_collision || in_water || off_screen;
    


    // Text/UI rendering ==================================================
    logic [5:0] uicolor;
    ui_gen ui_gen (
        .clk(osc_25_1M),
        .state(state),
        .colPos(colPos),
        .rowPos(rowPos),
        .btn_up_tick(btn_up_tick),
        .btn_down_tick(btn_down_tick),
        .color(uicolor)
    );


    /*********************************************
     *
     *                  RENDERING   
     *           (in order of priority)
     *********************************************/
    // cars rendering =====================================================
    logic [5:0] carcolor;


    // grid/window color ==================================================
    logic [5:0] gridcolor;
    logic window_display_enable;

    // Background color ===================================================
    logic [5:0] bgcolor;

    // Full render: front to back =========================================
    // color priority: UI > frog > cars > background
    always_comb begin
        if (uicolor != BLACK) begin
            color = uicolor;
        end else if (frogcolor != BLACK) begin
            color = frogcolor;
        end else if (logcolor != BLACK) begin
            color = logcolor;
        end else if (carcolor != BLACK) begin
            color = carcolor;
        end else begin
            color = bgcolor;
        end
    end
    // ====================================================================



endmodule
