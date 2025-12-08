module gamestate (
    input logic clk,
    input logic [3:0] dpad_input,
    input logic reset,
    input logic collision,
    input logic reached_end,
    output logic winOut,
    output logic loseOut,
    output logic [1:0] state,
    output logic [3:0] level,
    output logic [1:0] soundselector,
    output logic playsound    // playsound HIGH -> play the sound specified
);
    enum logic [1:0] {MENU, PLAYING, DEAD, WIN} statetype;
    enum logic [1:0] {UI_PRESS, NEXTLEVEL, CRASH, CELEBRATION} soundtype;

    logic prevWin;
    logic prevLose;
    logic soundResetNext;

    always_ff @(posedge clk) begin
        if (soundResetNext) begin
            winOut <= 1'b0;
            loseOut <= 1'b0;
            soundResetNext <= 0;
        end
    end
    
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= MENU;
        end else if (state == MENU && dpad_input != 4'b0000) begin
            state <= PLAYING;
            level <= 4'b0;
        end else if (collision) begin
            loseOut <= 1'b1;
            soundResetNext <= 1'b1;
            state <= MENU;
        end else if (reached_end) begin
            winOut <= 1'b1;
            soundResetNext <= 1'b1;
            state <= WIN;
        end 
    end

endmodule
