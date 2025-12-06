module frog (
    input logic clk,
    input logic [1:0] state,
    input logic [9:0] init_x,
    input logic [9:0] init_y,
    input logic [9:0] frog_size,
    input logic [3:0] dpad_input,  // ordered left, down, up, right
    input logic collision,
    input logic reset,
    output logic reached_end,
    output logic [9:0] next_x,
    output logic [9:0] next_y,
    output logic [1:0] facing
);
    
    parameter blocksize = 32;
    parameter endarea = 15;
    enum logic [1:0] {MENU=0, PLAYING=1, DEAD=2, WIN=3} statetype;
    typedef enum logic [1:0] {UP=2'b00, DOWN=2'b01, LEFT=2'b10, RIGHT=2'b11} face_dir;
    face_dir facing;

    // Debounced button signals
    logic btn_up_tick;
    logic btn_down_tick;
    logic btn_left_tick;
    logic btn_right_tick;

    debounce db_up (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[2]),
        .db_level(),
        .db_tick(btn_up_tick)
    );

    debounce db_down (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[1]),
        .db_level(),
        .db_tick(btn_down_tick)
    );
    
    debounce db_left (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[0]),
        .db_level(),
        .db_tick(btn_left_tick)
    );
    
    debounce db_right (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[3]),
        .db_level(),
        .db_tick(btn_right_tick)
    );

    logic initialized = 1'b0;
    logic new_turn = 1'b0;
    always_ff @(posedge clk) begin
        if (reset || collision || !initialized) begin
            next_x <= init_x;
            next_y <= init_y;
            reached_end <= 1'b0;
            initialized <= 1'b1;
            facing <= UP;
        // playing state
        end else if (state == 2'b01) begin 
            if (btn_up_tick) begin
                // move up by decreasing the y coordinate
                if (next_y >= blocksize) begin
                    next_y <= next_y - blocksize;
                    facing <= UP;
                end
            end else if (btn_down_tick) begin
                if (next_y + frog_size < 480) begin
                    next_y <= next_y + blocksize;
                    facing <= DOWN;
                end
            end else if (btn_left_tick) begin
                if (next_x >= blocksize) begin
                    next_x <= next_x - blocksize;
                    facing <= LEFT;
                end
            end else if (btn_right_tick) begin
                if (next_x + frog_size < 640) begin
                    next_x <= next_x + blocksize;
                    facing <= RIGHT;
                end
            end
            
            // check if we reached the end
            if (next_y <= endarea) begin
                reached_end <= 1'b1;
            end else begin
                reached_end <= 1'b0;
            end
        end
    end

endmodule
