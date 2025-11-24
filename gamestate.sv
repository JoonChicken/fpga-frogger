module gamestate (
    input logic clk,
    input logic start,
    input logic reset,
    input logic collision,
    input logic reached_end,
    output logic [1:0] state,
    output logic [3:0] level,
    output logic [2:0] sound_select
);
    enum logic [1:0] {MENU, PLAYING, DEAD, WIN} statetype;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= MENU;
            level <= 4'b0;
        end else if (state == MENU && start) begin
            state <= PLAYING; 
        end else if (state == PLAYING) begin
            if (reached_end) begin
                if (level == 4'd15) begin
                    state <= WIN;
                end else begin
                    level <= level + 1;
                end
            end
            if (collision) begin
                state <= DEAD;
                level <= 4'b0;
            end
        end
    end

endmodule