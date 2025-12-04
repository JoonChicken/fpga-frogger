<<<<<<<< HEAD:window.sv
module window (
========
module frog_gen (
>>>>>>>> a108d99 (working mechanics with background):frog_gen.sv
    input logic clk,
    input logic [9:0] colPos,
    input logic [9:0] rowPos,
    input logic [9:0] frog_x,
    input logic [9:0] frog_y,
    input logic [9:0] frog_size,
    output logic [5:0] color
);

    logic [10:0] offset = 11'b0;

    always_ff @(posedge clk) begin
        offset <= offset + 4;
    end

    logic lum;
    logic in_frog;

    always_comb begin
        // check if current pixel is within the frog
        in_frog = (colPos > frog_x && colPos < frog_x + frog_size &&
                     rowPos > frog_y && rowPos <= frog_y + frog_size);
        if (in_frog) begin
            // draw frog 
            color = 6'b110000;
        end else begin
            // don't draw anything - let background/window show through
            color = 6'b000000;
        end
    end

endmodule