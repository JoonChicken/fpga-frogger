module frog (
    input logic clk,
    input logic [1:0] state,
    input logic [9:0] init_x,
    input logic [9:0] init_y,
    input logic [9:0] frog_size,
    input logic btn_up_tick,
    input logic btn_down_tick,
    input logic btn_left_tick,
    input logic btn_right_tick,
    input logic collision,
    input logic reached_end,
    input logic reset,
    input logic signed [9:0] lane0_log_speed,
    input logic signed [9:0] lane1_log_speed,
    input logic signed [9:0] lane2_log_speed,
    input logic signed [9:0] lane3_log_speed,
    input logic signed [9:0] lane4_log_speed,
    input logic signed [9:0] lane5_log_speed,
    input logic in_lane0_log,
    input logic in_lane1_log,
    input logic in_lane2_log,
    input logic in_lane3_log,
    input logic in_lane4_log,
    input logic in_lane5_log,
    output logic [9:0] next_x,
    output logic [9:0] next_y,
    output logic [1:0] facing
);
    
    parameter blocksize = 32;
    enum logic [1:0] {MENU=0, PLAYING=1, DEAD=2, WIN=3} statetype;
    typedef enum logic [1:0] {UP=2'b00, DOWN=2'b01, LEFT=2'b10, RIGHT=2'b11} face_dir;
    face_dir facing;


    logic initialized = 1'b0;
    logic signed [10:0] new_x;
    logic [9:0] new_y;
    logic signed [9:0] dx;


    always_ff @(posedge clk) begin
        if (reset || collision || !initialized) begin
            next_x <= init_x;
            next_y <= init_y;
            initialized <= 1'b1;
            facing <= UP;

        // playing state
        end else if (state == PLAYING) begin 
            new_x = $signed(next_x);
            new_y = next_y;
            dx = 0;

            if (btn_up_tick) begin
                // move up by decreasing the y coordinate
                if (next_y >= blocksize) begin
                    new_y = next_y - blocksize;
                    facing <= UP;
                end
            end else if (btn_down_tick) begin
                if (next_y + frog_size < 480) begin
                    new_y = next_y + blocksize;
                    facing <= DOWN;
                end
            end else if (btn_left_tick) begin
                if (next_x >= blocksize) begin
                    new_x = next_x - blocksize;
                    facing <= LEFT;
                end
            end else if (btn_right_tick) begin
                if (next_x + frog_size < 640) begin
                    new_x = next_x + blocksize;
                    facing <= RIGHT;
                end
            end
            
            dx = '0;
            if (in_lane0_log)      dx = lane0_log_speed;
            else if (in_lane1_log) dx = lane1_log_speed;
            else if (in_lane2_log) dx = lane2_log_speed;
            else if (in_lane3_log) dx = lane3_log_speed;
            else if (in_lane4_log) dx = lane4_log_speed;
            else if (in_lane5_log) dx = lane5_log_speed;

            new_x = new_x + dx;

            if (new_x < 0) begin
                new_x = 0;
            end else if (new_x + frog_size > 640) begin
                new_x = 640 - frog_size;
            end
            next_x <= new_x[9:0];
            next_y <= new_y;
        end
    end

endmodule
