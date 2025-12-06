module gamestate (
    input logic clk,
    input logic dpad_input,
    input logic reset,
    input logic collision,
    input logic reached_end,
    output logic [1:0] state,
    output logic [3:0] level,
    output logic [1:0] soundselector,
    output logic playsound    // playsound HIGH -> play the sound specified
);
    enum logic [1:0] {MENU, PLAYING, DEAD, WIN} statetype;
    enum logic [1:0] {UI_PRESS, NEXTLEVEL, CRASH, CELEBRATION} soundtype;

    always_ff @(posedge dpad_input) begin
        if (state == MENU) state <= PLAYING;
        level <= 4'b0;
    end

    always_ff @(posedge reset) begin
        state <= MENU;
    end

    always_ff @(posedge collision) begin
        state <= DEAD;
    end

    always_ff @(posedge reached_end) begin
        state <= WIN;
    end

endmodule