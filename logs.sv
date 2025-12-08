module logs (
    input  logic clk,
    input  logic reset,

    output logic [9:0] lane0_log0_x,
    output logic [9:0] lane0_log1_x,    
    output logic [9:0] lane0_log2_x,

    output logic [9:0] lane1_log0_x,
    output logic [9:0] lane1_log1_x,

    output logic [9:0] lane2_log0_x,
    output logic [9:0] lane2_log1_x,

    output logic [9:0] lane3_log0_x,
    output logic [9:0] lane3_log1_x,

    output logic [9:0] lane4_log0_x,
    output logic [9:0] lane4_log1_x,

    output logic [9:0] lane5_log0_x,
    output logic [9:0] lane5_log1_x,

    output logic signed [9:0] lane0_log_speed,
    output logic signed [9:0] lane1_log_speed,
    output logic signed [9:0] lane2_log_speed,
    output logic signed [9:0] lane3_log_speed,
    output logic signed [9:0] lane4_log_speed,
    output logic signed [9:0] lane5_log_speed,

    output logic [9:0] lane0_loglength,
    output logic [9:0] lane1_loglength,
    output logic [9:0] lane2_loglength,
    output logic [9:0] lane3_loglength,
    output logic [9:0] lane4_loglength,
    output logic [9:0] lane5_loglength
);

    parameter BLOCKSIZE = 10'd32;
    parameter X_OFFSET_LEFT  = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;
    parameter RIVER_WIDTH   = X_OFFSET_RIGHT - X_OFFSET_LEFT;
    parameter LOG_OFFSET    = 10'd150; // spacing between logs in a lane

    parameter LANE0_LENGTH = 10'd64;
    parameter LANE1_LENGTH = 10'd96;
    parameter LANE2_LENGTH = 10'd96;
    parameter LANE3_LENGTH = 10'd96;
    parameter LANE4_LENGTH = 10'd64;
    parameter LANE5_LENGTH = 10'd96;

    // speed dividers (higher = slower)
    parameter LANE0_SPEED_DIVIDER = 24'd200000;
    parameter LANE1_SPEED_DIVIDER = 24'd90000;
    parameter LANE2_SPEED_DIVIDER = 24'd275000;
    parameter LANE3_SPEED_DIVIDER = 24'd190000;
    parameter LANE4_SPEED_DIVIDER = 24'd350000;
    parameter LANE5_SPEED_DIVIDER = 24'd150000;

    logic [23:0] lane0_speed_counter;
    logic [23:0] lane1_speed_counter;
    logic [23:0] lane2_speed_counter;
    logic [23:0] lane3_speed_counter;
    logic [23:0] lane4_speed_counter;
    logic [23:0] lane5_speed_counter;

    assign lane0_loglength = LANE0_LENGTH;
    assign lane1_loglength = LANE1_LENGTH;
    assign lane2_loglength = LANE2_LENGTH;
    assign lane3_loglength = LANE3_LENGTH;
    assign lane4_loglength = LANE4_LENGTH;
    assign lane5_loglength = LANE5_LENGTH;

    always_ff @(posedge clk) begin
        if (reset) begin
            // Initialize log positions
            lane0_log0_x <= X_OFFSET_LEFT;
            lane0_log1_x <= X_OFFSET_LEFT + 1*LOG_OFFSET;
            lane0_log2_x <= X_OFFSET_LEFT + 2*LOG_OFFSET;

            lane1_log0_x <= X_OFFSET_LEFT;
            lane1_log1_x <= X_OFFSET_LEFT + 2*LOG_OFFSET;

            lane2_log0_x <= X_OFFSET_LEFT;
            lane2_log1_x <= X_OFFSET_LEFT + 2*LOG_OFFSET;

            lane3_log0_x <= X_OFFSET_LEFT;
            lane3_log1_x <= X_OFFSET_LEFT + 2*LOG_OFFSET;

            lane4_log0_x <= X_OFFSET_LEFT;
            lane4_log1_x <= X_OFFSET_LEFT + 2*LOG_OFFSET;

            lane5_log0_x <= X_OFFSET_LEFT;
            lane5_log1_x <= X_OFFSET_LEFT + 2*LOG_OFFSET;

            // reset speed counters
            lane0_speed_counter <= 24'd0;
            lane1_speed_counter <= 24'd0;
            lane2_speed_counter <= 24'd0;
            lane3_speed_counter <= 24'd0;
            lane4_speed_counter <= 24'd0;
            lane5_speed_counter <= 24'd0;

            lane0_log_speed <= 10'd0;
            lane1_log_speed <= 10'd0;
            lane2_log_speed <= 10'd0;
            lane3_log_speed <= 10'd0;
            lane4_log_speed <= 10'd0;
            lane5_log_speed <= 10'd0;

        end else begin 
          // increment counters
            lane0_speed_counter <= lane0_speed_counter + 1;
            lane1_speed_counter <= lane1_speed_counter + 1;
            lane2_speed_counter <= lane2_speed_counter + 1;
            lane3_speed_counter <= lane3_speed_counter + 1;
            lane4_speed_counter <= lane4_speed_counter + 1;
            lane5_speed_counter <= lane5_speed_counter + 1;
            
            lane0_log_speed <= 10'd0;
            lane1_log_speed <= 10'd0;
            lane2_log_speed <= 10'd0;
            lane3_log_speed <= 10'd0;
            lane4_log_speed <= 10'd0;
            lane5_log_speed <= 10'd0;

          // Lane 0 logs
            if (lane0_speed_counter >= LANE0_SPEED_DIVIDER) begin
                lane0_speed_counter <= 24'd0;

                if (lane0_log0_x <= X_OFFSET_LEFT - LANE0_LENGTH) lane0_log0_x <= X_OFFSET_RIGHT;
                else lane0_log0_x <= lane0_log0_x - 1;

                if (lane0_log1_x <= X_OFFSET_LEFT - LANE0_LENGTH) lane0_log1_x <= X_OFFSET_RIGHT;
                else lane0_log1_x <= lane0_log1_x - 1;

                if (lane0_log2_x <= X_OFFSET_LEFT - LANE0_LENGTH) lane0_log2_x <= X_OFFSET_RIGHT;
                else lane0_log2_x <= lane0_log2_x - 1;

                lane0_log_speed <= -10'sd1;
            end
          
          // Lane 1 logs
            if (lane1_speed_counter >= LANE1_SPEED_DIVIDER) begin
                lane1_speed_counter <= 24'd0;

                if (lane1_log0_x >= X_OFFSET_RIGHT) lane1_log0_x <= X_OFFSET_LEFT - LANE1_LENGTH;
                else lane1_log0_x <= lane1_log0_x + 1;

                if (lane1_log1_x >= X_OFFSET_RIGHT) lane1_log1_x <= X_OFFSET_LEFT - LANE1_LENGTH;
                else lane1_log1_x <= lane1_log1_x + 1;

                lane1_log_speed <= 10'd1;
            end

          // Lane 2 logs
            if (lane2_speed_counter >= LANE2_SPEED_DIVIDER) begin
                lane2_speed_counter <= 24'd0;

                if (lane2_log0_x >= X_OFFSET_RIGHT) lane2_log0_x <= X_OFFSET_LEFT - LANE2_LENGTH;
                else lane2_log0_x <= lane2_log0_x + 1;

                if (lane2_log1_x >= X_OFFSET_RIGHT) lane2_log1_x <= X_OFFSET_LEFT - LANE2_LENGTH;
                else lane2_log1_x <= lane2_log1_x + 1;

                lane2_log_speed <= 10'd1;
            end

          // Lane 3 logs
            if (lane3_speed_counter >= LANE3_SPEED_DIVIDER) begin
                lane3_speed_counter <= 24'd0;

                if (lane3_log0_x <= X_OFFSET_LEFT - LANE3_LENGTH) lane3_log0_x <= X_OFFSET_RIGHT;
                else lane3_log0_x <= lane3_log0_x - 1;

                if (lane3_log1_x <= X_OFFSET_LEFT - LANE3_LENGTH) lane3_log1_x <= X_OFFSET_RIGHT;
                else lane3_log1_x <= lane3_log1_x - 1;

                lane3_log_speed <= -10'sd1;
            end

          // Lane 4 logs
            if (lane4_speed_counter >= LANE4_SPEED_DIVIDER) begin
                lane4_speed_counter <= 24'd0;

                if (lane4_log0_x <= X_OFFSET_LEFT - LANE4_LENGTH) lane4_log0_x <= X_OFFSET_RIGHT;
                else lane4_log0_x <= lane4_log0_x - 1;

                if (lane4_log1_x <= X_OFFSET_LEFT - LANE4_LENGTH) lane4_log1_x <= X_OFFSET_RIGHT;
                else lane4_log1_x <= lane4_log1_x - 1;

                lane4_log_speed <= -10'sd1;
            end

          // Lane 5 logs
            if (lane5_speed_counter >= LANE5_SPEED_DIVIDER) begin
                lane5_speed_counter <= 24'd0;

                if (lane5_log0_x >= X_OFFSET_RIGHT) lane5_log0_x <= X_OFFSET_LEFT - LANE5_LENGTH;
                else lane5_log0_x <= lane5_log0_x + 1;

                if (lane5_log1_x >= X_OFFSET_RIGHT) lane5_log1_x <= X_OFFSET_LEFT - LANE5_LENGTH;
                else lane5_log1_x <= lane5_log1_x + 1;

                lane5_log_speed <= 10'd1;
            end
        end
    end

endmodule