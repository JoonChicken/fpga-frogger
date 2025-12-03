module top (
    input logic osc_12M,
    output logic clk, // 25.1 MHz

    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color,
    output logic audioOut,

    input logic jumpForwardIn,
    input logic jumpBackwardIn,
    input logic jumpRightIn,
    input logic jumpLeftIn,
);

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

    pattern_gen pattern (
        .clk(clk),
        .colPos(colPos),
        .rowPos(rowPos),
        .display_enable(display_enable),
        .color(color)
    );

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
