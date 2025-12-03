module debounce(
    input wire clk,
    input wire reset,
    input wire btn_in,      
    output reg db_level,     // Debounced steady signal
    output wire db_tick      // Single pulse when button is pressed
    );

    localparam N = 20; 

    reg [N-1:0] q_reg, q_next;
    reg [1:0] dff;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg <= 0;
            dff <= 0;
        end else begin
            q_reg <= q_next;
            dff <= {dff[0], btn_in}; // Shift in the new raw value
        end
    end

    always @(*) begin
        q_next = q_reg;
        
        // if the inputs (state change detection) are different
        if ((dff[0] ^ dff[1]) == 1'b1) begin
             q_next = {N{1'b1}}; // Reset counter to max
        end else if (q_reg > 0) begin
             q_next = q_reg - 1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            db_level <= 0;
        else if (q_reg == 0)
            db_level <= dff[1]; // Lock in the stable value
    end

    // detect edge of clean signal
    reg db_level_delayed;
    always @(posedge clk) begin
        db_level_delayed <= db_level;
    end
    
    // pulse is high only when current is 1 and previous was 0
    assign db_tick = db_level & ~db_level_delayed;

endmodule
