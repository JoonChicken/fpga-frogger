module frog_river(
  input logic clk, 
  input logic reset, 
  input logic [9:0] frog_x,
  input logic [9:0] frog_y,
  input logic [9:0] log_x [0:NUM_ROWS-1][0:NUM_LOGS-1],  
  input logic [9:0] log_width [0:NUM_ROWS-1][0:NUM_LOGS-1],
  input logic [9:0] log_length, 
  input logic log_speed, 
  input logic [9:0] river_rows [0:NUM_ROWS-1],
  output logic [9:0] frog_x_new, 
  output logic frog_in_water, 
  output logic frog_on_log
);

parameter NUM_LOGS = 1; 
parameter NUM_ROWS = 4; 
parameter screen_width = 10*10'd32;
parameter screen_height = 10*10'd32;

  // signal when the frog has found a log or is in the water
logic found_log; 
logic hit_water; 

// check to see if the frog is on the log 

  always_ff@(posedge clk) begin // updates on every posedge of the clock and every moment of the game
    if (reset) begin // handles resetting the game after a death 
      frog_x_new <= frog_x; 
      frog_in_water <= 0; 
      frog_on_log <= 0; 
    end else begin 
      found_log = 0; 
      hit_water = 0; 
      for (int row = 0; row < NUM_ROWS; row++)begin 
        if (frog_y == river_row[lane])begin
          hit_water = 1; 
          for (int i = 0; i < NUM_LOGS; i++) begin
            if(frog_x >= logx[i] && frog_x <= log_x[i] + log_width[i]) begin 
              found_log = 1; 
              hit_water = 0; 
              frog_x_new = frog_x + log_speed; // frog moves with log
            end
          end 
        end 
      end 

      if (hit_water) begin
        frog_x_new <= frog_x;
      end 

    end 
  end 

    endmodule 
      

    
