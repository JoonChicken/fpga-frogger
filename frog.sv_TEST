module frog (
    parameter blocksize = 32;
    parameter endarea = 15; // y coord where ending area starts
    input logic clk,
    input logic [1:0] state,
    input logic [3:0] dpad_input,  // ordered Up Down Left Right
    input logic collision,
    input logic reset,
    input logic [9:0] x,
    input logic [9:0] y,
    output logic direction[1:0],
    output logic reached_end,
    output logic [9:0] x_new,
    output logic [9:0] y_new
);
    enum logic [1:0] {MENU, PLAYING, DEAD, WIN} statetype;
    enum logic [1:0] {UP, DOWN, LEFT, RIGHT} directiontype;

    always_ff @(posedge clk) begin
        if (state == PLAYING) begin
            if (dpad_input == UP) begin

            end else if (dpad_input == DOWN) begin

            end else if (dpad_intput == LEFT) begin

            end else begin

            end
        end
    end

endmodule