module top (
    input logic osc_12M,
    output logic osc_25_1M,
    
    // Button inputs
    input logic button_up,
    input logic button_down,
    input logic button_left,
    input logic button_right,
    
    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color
);

    parameter BLACK = 6'b0;

    logic clk; // 25.1 MHz

    mypll mypll_inst(
        .ref_clk_i(osc_12M),
        .rst_n_i(1'b1),
        .outglobal_o(clk)
    );

    logic [9:0] colPos;
    logic [9:0] rowPos;

    vga vga (
        .clk(clk),
        .HSYNC(HSYNC),
        .VSYNC(VSYNC),
        .colPos(colPos),
        .rowPos(rowPos)
    );

    // Game state and control signals
    logic [1:0] state = 2'b01;  // Initialize to PLAYING state (1)
    logic [3:0] dpad_input;
    logic collision;
    logic reset;
    logic [1:0] direction;
    logic reached_end;
    
    // Connect buttons to dpad_input: [left[0], down[1], up[2], right[3]]
    assign dpad_input = {button_right, button_up, button_down, button_left};
    
    // Initialize reset (can be connected to a button if needed)
    assign reset = 1'b0;
    assign collision = 1'b0;  // TODO: implement collision detection
    
    // Frog positioning parameters
    parameter SQUARE_SIZE = 32;
    parameter INIT_X = 300;
    parameter INIT_Y = 400;
    
    // Frog position outputs
    logic [9:0] next_x;
    logic [9:0] next_y;
    
    frog frog_inst (
        .clk(osc_25_1M),
        .state(state),
        .INIT_X(INIT_X),
        .INIT_Y(INIT_Y),
        .SQUARE_SIZE(SQUARE_SIZE),
        .dpad_input(dpad_input),
        .collision(collision),
        .reset(reset),
        .direction(direction),
        .reached_end(reached_end),
        .next_x(next_x),
        .next_y(next_y)
    );
    logic display_enable;
    // draw from front to back; if draw_to_display is already enabled,
    // this means that there is already something displayed so don't draw

    logic [5:0] gridcolor;
    window window (
        .clk(clk),
        .colPos(colPos),
        .rowPos(rowPos),
        .square_x(next_x),
        .square_y(next_y),
        .square_size(SQUARE_SIZE),
        .display_enable(display_enable),
        .color(gridcolor)
    );

    logic [5:0] bgcolor;
    background bg (
        .on(display_enable),
        .colPos(colPos),
        .rowPos(rowPos),
        .color(bgcolor)
    );

    // which color selector
    always_comb begin
        if (gridcolor != BLACK) begin
            color = gridcolor;
        end else begin
            color = bgcolor;
        end
    end

    topAudio audio (
        .clk(clk),
        .jumpForward(jumpForwardIn),
        .jumpBackward(jumpBackwardIn),
        .jumpRight(jumpRightIn),
        .jumpLeft(jumpLeftIn),
        .win(1'b0),
        .lose(1'b0),
        .sound(audioOut)
    );

endmodule
