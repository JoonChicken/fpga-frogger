module logs(
  input logic clk, 
  input logic reset, 
  input logic [9:0] log_x, // this is the incoming log position 
  input logic enter_screen, // gets a new log 
  input logic exit_screen, // removes a log 
  output logic [9:0] log_x_new // updated log position 
);


// shift register every clock cycle 
  // once it gets to the end you remove the object 
  // determine time between sequence with ounter and threshold for each flag, using ROM have counter generate a new sample between frame 
  // mkae sure it's not going too fast 

// constants for the logs
parameter blocksize = 10'd32; 
parameter log_width = 3*10'd32; 
parameter log_speed = 10'd4; 
parameter screen_width = 10*10'd32; 

// logs are only moving to the right at the moment
always_ff @(posedge clk)begin
  if (reset) begin
    log_x_new <= -log_x_width; // resets it back to the initial position when we reset the game
end else begin // log movement
  log_x_new <= log_x + log_speed; 
  if (log_x_new >= screen_width)begin   // gets the log at the starting point when it leaves the screen
    log_x_new <= -log_x_width; 
  end 
end 
end 
end module


  
