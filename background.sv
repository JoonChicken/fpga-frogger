// background.sv file 

module background(
  input logic on, 
  input logic [9:0] colPos, 
  input logic [9:0] rowPos, 
  output logic [5:0] color
); 
    // set the RBG color values for the game 
    parameter GREEN = 6'b001101;
    parameter BLACK = 6'b000000;
    parameter BLUE = 6'b000011;
    parameter WHITE = 6'b111111;
    parameter X_OFFSET_LEFT = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;
    parameter BLOCKSIZE = 10'd32;

    // pixel locations 
    logic river;  
    logic grass; 

    // setting RGB value signals 
    always_comb begin 
        river = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                ((rowPos >= 1  * BLOCKSIZE) && (rowPos <= 7 * BLOCKSIZE));
        grass = (colPos >= X_OFFSET_LEFT) && (colPos <= X_OFFSET_RIGHT) &&
                ((rowPos >= 0 * BLOCKSIZE   && rowPos <= 1 * BLOCKSIZE) ||
                 (rowPos >= 7 * BLOCKSIZE   && rowPos <= 8 * BLOCKSIZE) ||
                 (rowPos >= 14 * BLOCKSIZE  && rowPos <= 15 * BLOCKSIZE));  

        if (river) begin 
            color = BLUE; 
        end else if (grass) begin 
            color = GREEN;
        end else  begin
            color = BLACK;
        end
    end 

endmodule 
