module cars (
    input logic clk,
    input logic reset,
    // Lane 0 cars (3 cars)
    output logic [9:0] lane0_car0_x,
    output logic [9:0] lane0_car1_x,
    output logic [9:0] lane0_car2_x,
    // Lane 1 cars (3 cars)
    output logic [9:0] lane1_car0_x,
    output logic [9:0] lane1_car1_x,
    output logic [9:0] lane1_car2_x,
    // Lane 2 cars (3 cars)
    output logic [9:0] lane2_car0_x,
    output logic [9:0] lane2_car1_x,
    output logic [9:0] lane2_car2_x,
    // Lane 3 cars (3 cars)
    output logic [9:0] lane3_car0_x,
    output logic [9:0] lane3_car1_x,
    output logic [9:0] lane3_car2_x,
    // Lane 4 cars (3 cars)
    output logic [9:0] lane4_car0_x,
    output logic [9:0] lane4_car1_x,
    output logic [9:0] lane4_car2_x,
    // Lane 5 cars (3 cars)
    output logic [9:0] lane5_car0_x,
    output logic [9:0] lane5_car1_x,
    output logic [9:0] lane5_car2_x,
    // Car lengths for each lane
    output logic [9:0] lane0_length,
    output logic [9:0] lane1_length,
    output logic [9:0] lane2_length,
    output logic [9:0] lane3_length,
    output logic [9:0] lane4_length,
    output logic [9:0] lane5_length
);

    parameter BLOCKSIZE = 10'd32;
    parameter X_OFFSET_LEFT = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;
    parameter ROAD_WIDTH = X_OFFSET_RIGHT - X_OFFSET_LEFT;  // 448 pixels
    parameter CAR_OFFSET = 10'd150;  // Constant offset between cars in same lane
    
    // Different car types per lane - each with unique length and speed
    // Lane 0: Small car, fast
    parameter LANE0_LENGTH = 10'd32;  // 1 block
    parameter LANE0_SPEED_DIVIDER = 24'd50000;
    
    // Lane 1: Medium car, medium speed
    parameter LANE1_LENGTH = 10'd64;  // 2 blocks
    parameter LANE1_SPEED_DIVIDER = 24'd100000;
    
    // Lane 2: Large car, slow
    parameter LANE2_LENGTH = 10'd96;  // 3 blocks
    parameter LANE2_SPEED_DIVIDER = 24'd150000;
    
    // Lane 3: Small car, very fast
    parameter LANE3_LENGTH = 10'd32;  // 1 block
    parameter LANE3_SPEED_DIVIDER = 24'd100000;
    
    // Lane 4: Medium car, slow
    parameter LANE4_LENGTH = 10'd64;  // 2 blocks
    parameter LANE4_SPEED_DIVIDER = 24'd200000;
    
    // Lane 5: Large car, medium speed
    parameter LANE5_LENGTH = 10'd96;  // 3 blocks
    parameter LANE5_SPEED_DIVIDER = 24'd120000;
    
    // Speed counters for each lane (different speeds)
    logic [23:0] lane0_speed_counter;
    logic [23:0] lane1_speed_counter;
    logic [23:0] lane2_speed_counter;
    logic [23:0] lane3_speed_counter;
    logic [23:0] lane4_speed_counter;
    logic [23:0] lane5_speed_counter;
    
    // Assign car lengths
    assign lane0_length = LANE0_LENGTH;
    assign lane1_length = LANE1_LENGTH;
    assign lane2_length = LANE2_LENGTH;
    assign lane3_length = LANE3_LENGTH;
    assign lane4_length = LANE4_LENGTH;
    assign lane5_length = LANE5_LENGTH;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            // Initialize lane 0 cars (small, fast)
            lane0_car0_x <= X_OFFSET_LEFT;
            lane0_car1_x <= X_OFFSET_LEFT + CAR_OFFSET;
            lane0_car2_x <= X_OFFSET_LEFT + 2 * CAR_OFFSET;
            
            // Initialize lane 1 cars (medium, medium speed)
            lane1_car0_x <= X_OFFSET_LEFT + CAR_OFFSET / 2;
            lane1_car1_x <= X_OFFSET_LEFT + CAR_OFFSET / 2 + CAR_OFFSET;
            lane1_car2_x <= X_OFFSET_LEFT + CAR_OFFSET / 2 + 2 * CAR_OFFSET;
            
            // Initialize lane 2 cars (large, slow)
            lane2_car0_x <= X_OFFSET_LEFT;
            lane2_car1_x <= X_OFFSET_LEFT + CAR_OFFSET;
            lane2_car2_x <= X_OFFSET_LEFT + 2 * CAR_OFFSET;
            
            // Initialize lane 3 cars (small, very fast)
            lane3_car0_x <= X_OFFSET_LEFT + CAR_OFFSET / 3;
            lane3_car1_x <= X_OFFSET_LEFT + CAR_OFFSET / 3 + CAR_OFFSET;
            lane3_car2_x <= X_OFFSET_LEFT + CAR_OFFSET / 3 + 2 * CAR_OFFSET;
            
            // Initialize lane 4 cars (medium, slow)
            lane4_car0_x <= X_OFFSET_LEFT + CAR_OFFSET / 4;
            lane4_car1_x <= X_OFFSET_LEFT + CAR_OFFSET / 4 + CAR_OFFSET;
            lane4_car2_x <= X_OFFSET_LEFT + CAR_OFFSET / 4 + 2 * CAR_OFFSET;
            
            // Initialize lane 5 cars (large, medium speed)
            lane5_car0_x <= X_OFFSET_LEFT + CAR_OFFSET / 2;
            lane5_car1_x <= X_OFFSET_LEFT + CAR_OFFSET / 2 + CAR_OFFSET;
            lane5_car2_x <= X_OFFSET_LEFT + CAR_OFFSET / 2 + 2 * CAR_OFFSET;
            
            // Reset speed counters
            lane0_speed_counter <= 24'd0;
            lane1_speed_counter <= 24'd0;
            lane2_speed_counter <= 24'd0;
            lane3_speed_counter <= 24'd0;
            lane4_speed_counter <= 24'd0;
            lane5_speed_counter <= 24'd0;
        end else begin
            // Update speed counters
            lane0_speed_counter <= lane0_speed_counter + 1;
            lane1_speed_counter <= lane1_speed_counter + 1;
            lane2_speed_counter <= lane2_speed_counter + 1;
            lane3_speed_counter <= lane3_speed_counter + 1;
            lane4_speed_counter <= lane4_speed_counter + 1;
            lane5_speed_counter <= lane5_speed_counter + 1;
            
            // Move lane 0 cars (fast)
            if (lane0_speed_counter >= LANE0_SPEED_DIVIDER) begin
                lane0_speed_counter <= 24'd0;
                
                if (lane0_car0_x >= X_OFFSET_RIGHT) begin
                    lane0_car0_x <= X_OFFSET_LEFT - LANE0_LENGTH;
                end else begin
                    lane0_car0_x <= lane0_car0_x + 1;
                end
                
                if (lane0_car1_x >= X_OFFSET_RIGHT) begin
                    lane0_car1_x <= X_OFFSET_LEFT - LANE0_LENGTH;
                end else begin
                    lane0_car1_x <= lane0_car1_x + 1;
                end
                
                if (lane0_car2_x >= X_OFFSET_RIGHT) begin
                    lane0_car2_x <= X_OFFSET_LEFT - LANE0_LENGTH;
                end else begin
                    lane0_car2_x <= lane0_car2_x + 1;
                end
            end
            
            // Move lane 1 cars (medium speed)
            if (lane1_speed_counter >= LANE1_SPEED_DIVIDER) begin
                lane1_speed_counter <= 24'd0;
                
                if (lane1_car0_x >= X_OFFSET_RIGHT) begin
                    lane1_car0_x <= X_OFFSET_LEFT - LANE1_LENGTH;
                end else begin
                    lane1_car0_x <= lane1_car0_x + 1;
                end
                
                if (lane1_car1_x >= X_OFFSET_RIGHT) begin
                    lane1_car1_x <= X_OFFSET_LEFT - LANE1_LENGTH;
                end else begin
                    lane1_car1_x <= lane1_car1_x + 1;
                end
                
                if (lane1_car2_x >= X_OFFSET_RIGHT) begin
                    lane1_car2_x <= X_OFFSET_LEFT - LANE1_LENGTH;
                end else begin
                    lane1_car2_x <= lane1_car2_x + 1;
                end
            end
            
            // Move lane 2 cars (slow)
            if (lane2_speed_counter >= LANE2_SPEED_DIVIDER) begin
                lane2_speed_counter <= 24'd0;
                
                if (lane2_car0_x >= X_OFFSET_RIGHT) begin
                    lane2_car0_x <= X_OFFSET_LEFT - LANE2_LENGTH;
                end else begin
                    lane2_car0_x <= lane2_car0_x + 1;
                end
                
                if (lane2_car1_x >= X_OFFSET_RIGHT) begin
                    lane2_car1_x <= X_OFFSET_LEFT - LANE2_LENGTH;
                end else begin
                    lane2_car1_x <= lane2_car1_x + 1;
                end
                
                if (lane2_car2_x >= X_OFFSET_RIGHT) begin
                    lane2_car2_x <= X_OFFSET_LEFT - LANE2_LENGTH;
                end else begin
                    lane2_car2_x <= lane2_car2_x + 1;
                end
            end
            
            // Move lane 3 cars (very fast)
            if (lane3_speed_counter >= LANE3_SPEED_DIVIDER) begin
                lane3_speed_counter <= 24'd0;
                
                if (lane3_car0_x >= X_OFFSET_RIGHT) begin
                    lane3_car0_x <= X_OFFSET_LEFT - LANE3_LENGTH;
                end else begin
                    lane3_car0_x <= lane3_car0_x + 1;
                end
                
                if (lane3_car1_x >= X_OFFSET_RIGHT) begin
                    lane3_car1_x <= X_OFFSET_LEFT - LANE3_LENGTH;
                end else begin
                    lane3_car1_x <= lane3_car1_x + 1;
                end
                
                if (lane3_car2_x >= X_OFFSET_RIGHT) begin
                    lane3_car2_x <= X_OFFSET_LEFT - LANE3_LENGTH;
                end else begin
                    lane3_car2_x <= lane3_car2_x + 1;
                end
            end
            
            // Move lane 4 cars (slow)
            if (lane4_speed_counter >= LANE4_SPEED_DIVIDER) begin
                lane4_speed_counter <= 24'd0;
                
                if (lane4_car0_x >= X_OFFSET_RIGHT) begin
                    lane4_car0_x <= X_OFFSET_LEFT - LANE4_LENGTH;
                end else begin
                    lane4_car0_x <= lane4_car0_x + 1;
                end
                
                if (lane4_car1_x >= X_OFFSET_RIGHT) begin
                    lane4_car1_x <= X_OFFSET_LEFT - LANE4_LENGTH;
                end else begin
                    lane4_car1_x <= lane4_car1_x + 1;
                end
                
                if (lane4_car2_x >= X_OFFSET_RIGHT) begin
                    lane4_car2_x <= X_OFFSET_LEFT - LANE4_LENGTH;
                end else begin
                    lane4_car2_x <= lane4_car2_x + 1;
                end
            end
            
            // Move lane 5 cars (medium speed)
            if (lane5_speed_counter >= LANE5_SPEED_DIVIDER) begin
                lane5_speed_counter <= 24'd0;
                
                if (lane5_car0_x >= X_OFFSET_RIGHT) begin
                    lane5_car0_x <= X_OFFSET_LEFT - LANE5_LENGTH;
                end else begin
                    lane5_car0_x <= lane5_car0_x + 1;
                end
                
                if (lane5_car1_x >= X_OFFSET_RIGHT) begin
                    lane5_car1_x <= X_OFFSET_LEFT - LANE5_LENGTH;
                end else begin
                    lane5_car1_x <= lane5_car1_x + 1;
                end
                
                if (lane5_car2_x >= X_OFFSET_RIGHT) begin
                    lane5_car2_x <= X_OFFSET_LEFT - LANE5_LENGTH;
                end else begin
                    lane5_car2_x <= lane5_car2_x + 1;
                end
            end
        end
    end

endmodule
