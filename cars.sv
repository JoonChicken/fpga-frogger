module cars (
    input logic clk,
    input logic reset,
    input logic [3:0] level,

    output logic [9:0] lane0_car0_x, 
    output logic [9:0] lane1_car0_x, 
    output logic [9:0] lane2_car0_x,
    output logic [9:0] lane3_car0_x,
    output logic [9:0] lane4_car0_x,
    output logic [9:0] lane4_car1_x,
    output logic [9:0] lane5_car0_x,
    
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
    parameter ROAD_WIDTH = X_OFFSET_RIGHT - X_OFFSET_LEFT;
    // constant car offset for all lanes
    parameter CAR_OFFSET = 10'd150;

    
    // different cars per lane
    // lane 0 is at the top
    // higher lane speed divider = slower car
    // laneX length = car length for that lane
    parameter LANE0_LENGTH = 10'd32;  // 1 block
    parameter LANE0_SPEED_DIVIDER = 24'd50000;
    
    parameter LANE1_LENGTH = 10'd64;  // 2 blocks
    parameter LANE1_SPEED_DIVIDER = 24'd100000;
    
    parameter LANE2_LENGTH = 10'd96;  // 3 blocks
    parameter LANE2_SPEED_DIVIDER = 24'd150000;
    
    parameter LANE3_LENGTH = 10'd32;  // 1 block
    parameter LANE3_SPEED_DIVIDER = 24'd100000;
    
    parameter LANE4_LENGTH = 10'd64;  // 2 blocks
    parameter LANE4_SPEED_DIVIDER = 24'd200000;
    
    parameter LANE5_LENGTH = 10'd96;  // 3 blocks
    parameter LANE5_SPEED_DIVIDER = 24'd120000;
    
    logic [23:0] lane0_speed_counter;
    logic [23:0] lane1_speed_counter;
    logic [23:0] lane2_speed_counter;
    logic [23:0] lane3_speed_counter;
    logic [23:0] lane4_speed_counter;
    logic [23:0] lane5_speed_counter;
    
    // assign car lengths
    assign lane0_length = LANE0_LENGTH;
    assign lane1_length = LANE1_LENGTH;
    assign lane2_length = LANE2_LENGTH;
    assign lane3_length = LANE3_LENGTH;
    assign lane4_length = LANE4_LENGTH;
    assign lane5_length = LANE5_LENGTH;


    // LEVEL INCREMENTER
    logic [8:0] lanedivmult = 32 / ( 16 * level);

    
    // counter initializes for each lane
    // once counter reaches laneX_speed_divider, the car in laneX moves 1 pixel
    
    always_ff @(posedge clk) begin
        if (reset) begin
            lane0_car0_x <= X_OFFSET_LEFT;
            lane1_car0_x <= X_OFFSET_LEFT;
            lane2_car0_x <= X_OFFSET_LEFT;
            lane3_car0_x <= X_OFFSET_LEFT;
            lane4_car0_x <= X_OFFSET_LEFT;
            lane4_car1_x <= X_OFFSET_LEFT + 2*CAR_OFFSET;
            lane5_car0_x <= X_OFFSET_LEFT;
            
            // reset speed counters
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
            
            if (lane0_speed_counter >= LANE0_SPEED_DIVIDER) begin
                lane0_speed_counter <= 24'd0;
                
                if (lane0_car0_x >= X_OFFSET_RIGHT) begin
                    lane0_car0_x <= X_OFFSET_LEFT - LANE0_LENGTH;
                end else begin
                    lane0_car0_x <= lane0_car0_x + 1;
                end
                
                
            end
            
            if (lane1_speed_counter >= LANE1_SPEED_DIVIDER * lanedivmult) begin
                lane1_speed_counter <= 24'd0;
                
                if (lane1_car0_x >= X_OFFSET_RIGHT) begin
                    lane1_car0_x <= X_OFFSET_LEFT - LANE1_LENGTH;
                end else begin
                    lane1_car0_x <= lane1_car0_x + 1;
                end
                
                
            end
            
            if (lane2_speed_counter >= LANE2_SPEED_DIVIDER * lanedivmult) begin
                lane2_speed_counter <= 24'd0;
                
                if (lane2_car0_x >= X_OFFSET_RIGHT) begin
                    lane2_car0_x <= X_OFFSET_LEFT - LANE2_LENGTH;
                end else begin
                    lane2_car0_x <= lane2_car0_x + 1;
                end
                
                
            end
            
            if (lane3_speed_counter >= LANE3_SPEED_DIVIDER * lanedivmult) begin
                lane3_speed_counter <= 24'd0;
                
                if (lane3_car0_x >= X_OFFSET_RIGHT) begin
                    lane3_car0_x <= X_OFFSET_LEFT - LANE3_LENGTH;
                end else begin
                    lane3_car0_x <= lane3_car0_x + 1;
                end
                
               
            end
            
            if (lane4_speed_counter >= LANE4_SPEED_DIVIDER * lanedivmult) begin
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
                
                
            end
            
            if (lane5_speed_counter >= LANE5_SPEED_DIVIDER * lanedivmult) begin
                lane5_speed_counter <= 24'd0;
                
                if (lane5_car0_x >= X_OFFSET_RIGHT) begin
                    lane5_car0_x <= X_OFFSET_LEFT - LANE5_LENGTH;
                end else begin
                    lane5_car0_x <= lane5_car0_x + 1;
                end
                 
            end
        end
    end

endmodule
