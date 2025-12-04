module vga (
    input logic clk,
    output logic HSYNC,
    output logic VSYNC,
    output logic [9:0] colPos,
    output logic [9:0] rowPos
);

    initial begin
        colPos = 10'b0;
        rowPos = 10'b0;
    end

    always_ff @(posedge clk) begin
        if (colPos == 799) begin
            colPos <= 0;
            rowPos <= rowPos + 1;
            if (rowPos == 524) begin
                rowPos <= 0;
            end
        end else begin
            colPos <= colPos + 1;
        end
    end

    always_comb begin
        if (colPos >= 656 && colPos < 752) begin
            HSYNC = 1'b0;
        end else begin
            HSYNC = 1'b1;
        end
        if (rowPos >= 490 && rowPos < 492) begin
            VSYNC = 1'b0;
        end else begin
            VSYNC = 1'b1;
        end
    end

endmodule
