module gamestate (
    input logic clk,
    input logic [3:0] dpad_input,
    input logic reset,
    input logic collision,
    input logic reached_end,
    output logic win,
    output logic lose,
    output logic [1:0] state,
    output logic [3:0] level,
    output logic [1:0] soundselector,
    output logic playsound    // playsound HIGH -> play the sound specified
);
    enum logic [1:0] {MENU, PLAYING, DEAD, WIN} statetype;
    enum logic [1:0] {UI_PRESS, NEXTLEVEL, CRASH, CELEBRATION} soundtype;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= MENU;
        end else if (state == MENU && dpad_input != 4'b0000) begin
            state <= PLAYING;
            level <= 4'b0;
        end else if (collision) begin
            lose <= 1'b1;
            state <= MENU;
        end else if (reached_end) begin
            win <= 1'b1;
            state <= WIN;
        end
    end

endmodule
