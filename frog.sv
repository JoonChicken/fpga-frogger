module frog (
    input logic clk,
    input logic [1:0] state,
    input logic [9:0] INIT_X,
    input logic [9:0] INIT_Y,
    input logic [9:0] SQUARE_SIZE,
    input logic [3:0] dpad_input,  // ordered left[0] down[1] up[2] right[3]
    input logic collision,
    input logic reset,
    output logic [1:0] direction,
    output logic reached_end,
    output logic [9:0] next_x,
    output logic [9:0] next_y
);
    parameter blocksize = 32;
    parameter endarea = 15; // y coord where ending area starts;

    enum logic [1:0] {MENU=0, PLAYING=1, DEAD=2, WIN=3} statetype;
    enum logic [1:0] {UP=0, DOWN=1, LEFT=2, RIGHT=3} directiontype;

    // Debounced button signals
    logic btn_up_tick;
    logic btn_down_tick;
    logic btn_left_tick;
    logic btn_right_tick;

    debounce db_up (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[2]),  // up is index 2
        .db_level(),
        .db_tick(btn_up_tick)
    );

    debounce db_down (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[1]),  // down is index 1
        .db_level(),
        .db_tick(btn_down_tick)
    );
    
    debounce db_left (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[0]),  // left is index 0
        .db_level(),
        .db_tick(btn_left_tick)
    );
    
    debounce db_right (
        .clk(clk),
        .reset(reset),
        .btn_in(dpad_input[3]),  // right is index 3
        .db_level(),
        .db_tick(btn_right_tick)
    );

    // Initialize position outputs - use reset or first clock cycle
    logic initialized = 1'b0;

    always_ff @(posedge clk) begin
        if (reset || !initialized) begin
            next_x <= INIT_X;
            next_y <= INIT_Y;
            direction <= 2'b00;  // UP
            reached_end <= 1'b0;
            initialized <= 1'b1;
        end else if (state == 2'b01) begin  // PLAYING state = 1
            if (btn_up_tick) begin
                // move up by decreasing the y coordinate
                if (next_y >= blocksize) begin
                    next_y <= next_y - blocksize;
                    direction <= 2'b00;  // UP
                end
            end else if (btn_down_tick) begin
                if (next_y + SQUARE_SIZE < 480) begin
                    next_y <= next_y + blocksize;
                    direction <= 2'b01;  // DOWN
                end
            end else if (btn_left_tick) begin
                if (next_x >= blocksize) begin
                    next_x <= next_x - blocksize;
                    direction <= 2'b10;  // LEFT
                end
            end else if (btn_right_tick) begin
                if (next_x + SQUARE_SIZE < 640) begin
                    next_x <= next_x + blocksize;
                    direction <= 2'b11;  // RIGHT
                end
            end
            
            // Check if reached end (top of screen)
            if (next_y <= endarea) begin
                reached_end <= 1'b1;
            end else begin
                reached_end <= 1'b0;
            end
        end
    end

endmodule
