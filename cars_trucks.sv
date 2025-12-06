/*module cars(
  input logic clk, 
  input logic reset, 
  input logic [9:0] car_x, // left most pixel of the car 
  output logic [9:0] car_x_new, // updated car position 
  input logic [9:0] truck_x,
  input logic [9:0] truck_x_new
);


// shift register every clock cycle 
  // once it gets to the end you remove the object 
  // determine time between sequence with ounter and threshold for each flag, using ROM have counter generate a new sample between frame 
  // mkae sure it's not going too fast 

// constants for the logs
parameter blocksize = 10'd32;  // blocksize 
parameter truck_width = 3*10'd32; // each truck is 3 blocks wide 
parameter car_width = 2*10'd32; // each car is 2 blocks wide 
parameter speed = 10'd4;   // how fast cars and trucks are moving 
parameter screen_width = 10*10'd32; // screen is 10 blocks wide 

// cars and trucks are only moving to the right at the moment
always_ff @(posedge clk)begin
  if (reset) begin
    car_x_new <= -car_width; // resets it back to the initial position when we reset the game
    truck_x_new <= -truck_width;
  end else begin // log movement
  car_x_new <= car_x + speed; 
  truck_x_new <= truck_x + speed; 
    if (truck_x_new >= screen_width || car_x_new >= screen_width)begin   // gets the log at the starting point when it leaves the screen
    truck_x_new <= -truck_width; 
    car_x_new <= -car_width; 
    end 
  end 
  end 
end module


  

  
