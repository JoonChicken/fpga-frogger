module top (
    input logic osc_12M,
    output logic osc_25_1M,

    output logic HSYNC,
    output logic VSYNC,
    output logic [5:0] color,
);

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

    logic display_enable;

    pattern_gen pattern (
        .clk(osc_25_1M),
        .colPos(colPos),
        .rowPos(rowPos),
        .display_enable(display_enable),
        .color(color)
    );

endmodule