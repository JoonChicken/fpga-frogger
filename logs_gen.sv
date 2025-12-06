/*logs_gen(
  input logic clk,
  input logic reset, 
  input logic [9:0] river_rows [0:NUM_ROWS-1],
  input logic [9:0] colPos, 
  input logic [9:0] rowPos, 
  input logic [9:0] log_x[0:MAX_LOGS-1]; 
  input logic [9:0] log_y, 
  input logic log_width,
  input logic log_height, 
  output logic [9:0] log_x_new[0:MAX_LOGS-1], 
  output logic [9:0] log_y_new
); 

parameter NUM_ROWS = 6; 
local param [5:0] LOG_COLOR = 6'b110100; 
logic log_passed; 
logic [9:0] log_x[0:MAX_LOGS-1]; 

always_comb begin 
        color      = 6'b000000;
        log_passed = 1'b0;
        local_x    = 10'd0;
        local_y    = 10'd0;
        log width = 3*10'd32;

  for (int row = 0; row < NUM_ROWS; row++) begin 
    if (rowPos >= NUM_ROWS[0] && rowPos <= NUM_ROWS[NUM_ROWS-1]) begin 
      log_passed = 1'b1; 
    end 
    if (log_passed) begin
      color = LOG_COLOR; 
    end    
  end 
    
