module frog_river(
  input logic clk, 
  input logic reset, 
  input logic [9:0] frog_x,
  input logic [9:0] frog_y,
  input logic [9:0] log_x, 
  input logic [9:0] log_y, 
  input logic [9:0] log_length, 
  input logic log_speed, 
  ouput logic [9:0] frog_x_new, 
  ouput logic frog_in_water, 
  output logic frog_on_log
);


// check to see if the frog is on the log 

  always_ff@(posedge clk) begin // updates on every posedge of the clock and every moment of the game
    if (reset) begin // handles resetting the game after a death 
      frog_x_new <= frog_x; 
      frog_in_water <= 0; 
      frog_on_log <= 0; 
    end else begin 

    
