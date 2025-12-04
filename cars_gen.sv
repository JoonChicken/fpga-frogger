module cars_gen (
    input logic clk,
    input logic [9:0] colPos,
    input logic [9:0] rowPos,
    
    input logic [9:0] lane0_car0_x,
    input logic [9:0] lane0_car1_x,
    input logic [9:0] lane0_car2_x,
    
    input logic [9:0] lane1_car0_x,
    input logic [9:0] lane1_car1_x,
    input logic [9:0] lane1_car2_x,

    input logic [9:0] lane2_car0_x,
    input logic [9:0] lane2_car1_x,
    input logic [9:0] lane2_car2_x,

    input logic [9:0] lane3_car0_x,
    input logic [9:0] lane3_car1_x,
    input logic [9:0] lane3_car2_x,

    input logic [9:0] lane4_car0_x,
    input logic [9:0] lane4_car1_x,
    input logic [9:0] lane4_car2_x,

    input logic [9:0] lane5_car0_x,
    input logic [9:0] lane5_car1_x,
    input logic [9:0] lane5_car2_x,

    // car lengths
    input logic [9:0] lane0_length,
    input logic [9:0] lane1_length,
    input logic [9:0] lane2_length,
    input logic [9:0] lane3_length,
    input logic [9:0] lane4_length,
    input logic [9:0] lane5_length,
    output logic [5:0] color
);

    parameter BLOCKSIZE = 10'd32;
    parameter X_OFFSET_LEFT = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;
    
    // Lane Y coordinate
    parameter LANE0_Y = 8 * BLOCKSIZE;   // 256
    parameter LANE1_Y = 9 * BLOCKSIZE;   // 288
    parameter LANE2_Y = 10 * BLOCKSIZE;  // 320
    parameter LANE3_Y = 11 * BLOCKSIZE;  // 352
    parameter LANE4_Y = 12 * BLOCKSIZE;  // 384
    parameter LANE5_Y = 13 * BLOCKSIZE;  // 416
    
    logic in_any_car;
    
    always_comb begin
        // Check if current pixel is within any car and within road bounds
        in_any_car = 
            
            ((colPos >= lane0_car0_x && colPos < lane0_car0_x + lane0_length &&      
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE0_Y && rowPos < LANE0_Y + BLOCKSIZE) ||
             (colPos >= lane0_car1_x && colPos < lane0_car1_x + lane0_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE0_Y && rowPos < LANE0_Y + BLOCKSIZE) ||
             (colPos >= lane0_car2_x && colPos < lane0_car2_x + lane0_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE0_Y && rowPos < LANE0_Y + BLOCKSIZE)) ||
            
            ((colPos >= lane1_car0_x && colPos < lane1_car0_x + lane1_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE1_Y && rowPos < LANE1_Y + BLOCKSIZE) ||
             (colPos >= lane1_car1_x && colPos < lane1_car1_x + lane1_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE1_Y && rowPos < LANE1_Y + BLOCKSIZE) ||
             (colPos >= lane1_car2_x && colPos < lane1_car2_x + lane1_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE1_Y && rowPos < LANE1_Y + BLOCKSIZE)) ||
            
            ((colPos >= lane2_car0_x && colPos < lane2_car0_x + lane2_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE2_Y && rowPos < LANE2_Y + BLOCKSIZE) ||
             (colPos >= lane2_car1_x && colPos < lane2_car1_x + lane2_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE2_Y && rowPos < LANE2_Y + BLOCKSIZE) ||
             (colPos >= lane2_car2_x && colPos < lane2_car2_x + lane2_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE2_Y && rowPos < LANE2_Y + BLOCKSIZE)) ||
            
            ((colPos >= lane3_car0_x && colPos < lane3_car0_x + lane3_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE3_Y && rowPos < LANE3_Y + BLOCKSIZE) ||
             (colPos >= lane3_car1_x && colPos < lane3_car1_x + lane3_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE3_Y && rowPos < LANE3_Y + BLOCKSIZE) ||
             (colPos >= lane3_car2_x && colPos < lane3_car2_x + lane3_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE3_Y && rowPos < LANE3_Y + BLOCKSIZE)) ||
            
            ((colPos >= lane4_car0_x && colPos < lane4_car0_x + lane4_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE4_Y && rowPos < LANE4_Y + BLOCKSIZE) ||
             (colPos >= lane4_car1_x && colPos < lane4_car1_x + lane4_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE4_Y && rowPos < LANE4_Y + BLOCKSIZE) ||
             (colPos >= lane4_car2_x && colPos < lane4_car2_x + lane4_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE4_Y && rowPos < LANE4_Y + BLOCKSIZE)) ||
            
            ((colPos >= lane5_car0_x && colPos < lane5_car0_x + lane5_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE5_Y && rowPos < LANE5_Y + BLOCKSIZE) ||
             (colPos >= lane5_car1_x && colPos < lane5_car1_x + lane5_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE5_Y && rowPos < LANE5_Y + BLOCKSIZE) ||
             (colPos >= lane5_car2_x && colPos < lane5_car2_x + lane5_length &&
              colPos >= X_OFFSET_LEFT && colPos < X_OFFSET_RIGHT &&
              rowPos >= LANE5_Y && rowPos < LANE5_Y + BLOCKSIZE));
        
        if (in_any_car) begin
            // car color
            color = 6'b101010;
        end else begin
            color = 6'b000000;
        end
    end

endmodule
