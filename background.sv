// background.sv file 

module background(){
  input on, 
  input [9:0] x, 
  input [9:0] y, 
  output reg [11:0] rgb
}; 

// set the RBG color values for the game 
parameter GREEN = 12'
parameter BLUE = 12'
parameter YELLOW = 12'
parameter RED = 12'
parameter BLACK = 12'
parameter BROWN = 12'
parameter BLUE = 12'
parameter WHITE = 12'

// pixel locations 
wire road; 
wire river;  
wire grass; 


// drivers 
  assign road = ((x <= 10) && (y <=6) && (y > 2) && (y =1);
  assign river = ((x <= 10) && (y <=9) && (y > 6));
  assign grass = ((x <= 10) && (y = 1) && (y = 10);  

// setting RGB value signals 
always_comb begin 
  if (~on) begin
    rgb = BLACK; 
 end else begin  
    if (road) begin  
      rgb = BLACK 
    end else if (river) begin 
      rgb = BLUE 
    end else if (grass) begin 
      rgb = GREEN 
    end 
  end 

endmodule 



