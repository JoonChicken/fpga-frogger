module logs(
  input logic clk, 
  input logic reset, 
  output logic [9:0] log_x_new[0:MAX_LOGS-1] // updated log position array
);


// shift register every clock cycle 
  // once it gets to the end you remove the object 
  // determine time between sequence with ounter and threshold for each flag, using ROM have counter generate a new sample between frame 
  // mkae sure it's not going too fast 

// constants for the logs
parameter blocksize = 10'd32;  // blocksize 
parameter log_width = 3*10'd32; // each log is 3 blocks wide 
parameter log_height = blocksize; // heigh of the log 
parameter log_speed = 10'd4;   // how fast log is moving 
parameter screen_width = 10*10'd32; // screen is 10 blocks wide 
parameter screen_height = 10*10'd32; // screen height 
parameter MAX_LOGS = 1; // number of logs per lane 

logic [18:0] counter; 
logic enable; 
logic [9:0] log_x[0:MAX_LOGS-1];  // 0 represents the last log, MAX_LOGS-1 is the first log 

// logs are only moving to the right at the moment
always_ff @(posedge clk)begin
  counter = counter + 1; 
  if (enable == 1) begin
    if (reset) begin
      counter <= 0; // counter goes back to zero once we reset 
      for (int i = 0; i < MAX_LOGS; i++) begin 
        log_x[i] <= -log_width; 
      end 
    end else begin // log movement
      for (int i = 0; i < MAX_LOGS; i++) begin
        log_x[i] <= log_x[i] + log_speed; 
        if (log_x[i] >= screen_width) begin 
          // gets the log at the starting point when it leaves the screen
          log_x[i] <= -log_width; 
        end 
      end 
    end 
  end
end 

always_comb begin
  if (counter == 19'b0111111111111111111) begin 
    enable = 1; 
  end else begin 
    enable = 0; 
  end 
  log_x_new = log_x; 
end 
    
end module


  
