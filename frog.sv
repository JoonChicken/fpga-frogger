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
    input logic reset,
    output logic reached_end,
    output logic [9:0] next_x,
    output logic [9:0] next_y
);
    parameter blocksize = 32;
    parameter endarea = 15;
    enum logic [1:0] {MENU=0, PLAYING=1, DEAD=2, WIN=3} statetype;


    logic initialized = 1'b0;
    always_ff @(posedge clk) begin
        if (reset || collision || !initialized) begin
            next_x <= init_x;
            next_y <= init_y;
            reached_end <= 1'b0;
            initialized <= 1'b1;
        // playing state
        end else if (state == PLAYING) begin 
            if (btn_up_tick) begin
                // move up by decreasing the y coordinate
                if (next_y >= blocksize) begin
                    next_y <= next_y - blocksize;
                end
            end else if (btn_down_tick) begin
                if (next_y + frog_size < 480) begin
                    next_y <= next_y + blocksize;
                end
            end else if (btn_left_tick) begin
                if (next_x >= blocksize) begin
                    next_x <= next_x - blocksize;
                end
            end else if (btn_right_tick) begin
                if (next_x + frog_size < 640) begin
                    next_x <= next_x + blocksize;
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
