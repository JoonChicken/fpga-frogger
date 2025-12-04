module top (
    input logic osc_12M,
    output logic osc_25_1M,
    
    input logic button_up,
    input logic button_down,
    input logic button_left,
    input logic button_right,
    
    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color,
);

    parameter BLACK = 6'b0;

    logic clk; // 25.1 MHz

    mypll mypll_inst(
        .ref_clk_i(osc_12M),
        .rst_n_i(1'b1),
        .outglobal_o(osc_25_1M)
    );

    logic [9:0] colPos;
    logic [9:0] rowPos;

    vga vga (
        .clk(osc_25_1M),
        .HSYNC(HSYNC),
        .VSYNC(VSYNC),
        .colPos(colPos),
        .rowPos(rowPos)
    );

    logic [1:0] state = 2'b01;
    logic [3:0] dpad_input;
    logic collision;
    logic reset;
    logic reached_end;
    
    assign dpad_input = {button_right, button_up, button_down, button_left};
    
    // frog positioning parameters
    parameter init_x = 320;
    parameter init_y = 448;  // Start at the bottom (480 - frog_size = 448)
    parameter frog_size = 32;
    
    logic [9:0] next_x;
    logic [9:0] next_y;
    
    
    assign reset = 1'b0;
    assign collision = 1'b0;
    
    frog frog (
        .clk(osc_25_1M),
        .state(state),
        .init_x(init_x),
        .init_y(init_y),
        .frog_size(frog_size),
        .dpad_input(dpad_input),
        .collision(collision),
        .reset(reset),
        .reached_end(reached_end),
        .next_x(next_x),
        .next_y(next_y)
    );

    logic [5:0] frogcolor;  
    frog_gen frog_gen (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .frog_x(next_x),
        .frog_y(next_y),
        .frog_size(frog_size),
        .color(frogcolor)
    );
    // grid/window color
    logic [5:0] gridcolor;
    logic window_display_enable;
    window window (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .display_enable(window_display_enable),
        .color(gridcolor)
    );

    // Background color
    logic [5:0] bgcolor;
    background bg (
        .on(1'b1),  // always enabled - background should always render
        .colPos(colPos),
        .rowPos(rowPos),
        .color(bgcolor)
    );

    // color priority: frog > grid/window > background
    always_comb begin
        if (frogcolor != 6'b000000) begin
            color = frogcolor;
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
