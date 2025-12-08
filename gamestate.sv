module gamestate (
    input logic clk,
    input logic start,
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
            level <= 4'b0;
            soundselector <= UI_PRESS;
            playsound <= 1'b1;
        end else if (state == MENU && start) begin
            state <= PLAYING; 
            soundselector <= UI_PRESS;
            playsound <= 1'b1;
        end else if (state == PLAYING) begin
            if (reached_end) begin
                if (level == 4'd15) begin
                    state <= WIN;
                    soundselector <= CELEBRATION;
                    playsound <= 1'b1;
                    win <= 1'b1;
                end else begin
                    level <= level + 1;
                    soundselector <= NEXTLEVEL;
                    playsound <= 1'b1;
                end
            end
            if (collision) begin
                state <= DEAD;
                level <= 4'b0;
                soundselector <= CRASH;
                playsound <= 1'b1;
                lose <= 1'b1;
            end
        end

        playsound <= 1'b0;
    end

endmodule
