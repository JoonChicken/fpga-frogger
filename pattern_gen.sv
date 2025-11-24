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

    always_comb begin
        if (colPos < 640) begin
            color = ((6'(colPos) + offset[10:5]) ^ (6'(rowPos))) & 6'b01000;
            display_enable = 1'b1;
        end else begin
            color = 6'b000000;
            display_enable = 1'b0;
        end
    end

endmodule