module pattern_gen (
    input logic clk,
    input logic [9:0] colPos,
    input logic [9:0] rowPos,
    output logic display_enable,
    output logic [5:0] color
);

    logic [10:0] offset = 11'b0;

    always_ff @(posedge clk) begin
        offset <= offset + 4;
    end

    logic lum;

    always_comb begin
        if (colPos >= 96 && colPos <= 544) begin
            lum = (colPos % 32 == 0) | ((rowPos + 1) % 32 == 0);
            color = (lum << 4) | (lum << 2) | lum;
            display_enable = 1'b1;
            if (rowPos <= 15) begin
                color = 6'b001100;
            end
        end else begin
            lum = 0;
            color = 6'b000000;
            display_enable = 1'b0;
        end
    end

endmodule