module top (
    input logic osc_12M,

    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color,
    output logic audioOut,

    input logic jumpForwardIn,
    input logic jumpBackwardIn,
    input logic jumpRightIn,
    input logic jumpLeftIn,
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

    logic display_enable;
    // draw from front to back; if draw_to_display is already enabled,
    // this means that there is already something displayed so don't draw

    logic [5:0] gridcolor;
    window window (
        .clk(clk),
        .colPos(colPos),
        .rowPos(rowPos),
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
