module debounce(
    input wire clk,
    input wire reset,
    input wire btn_in,      
    // stable input
    output reg db_level,
    // single pulse
    output wire db_tick
    );

    // debounce timespan in clock cycles
    localparam N = 20; 

    reg [N-1:0] q_reg, q_next;
    // 2 bit register to compare the current and previous button inputs
    reg [1:0] dff;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg <= 0;
            dff <= 0;
        end else begin
            q_reg <= q_next;
            // shift in raw button input
            dff <= {dff[0], btn_in}; 
        end
    end

    always @(*) begin
        q_next = q_reg;
        
        // if the inputs are different, restart the debounce counter
        if ((dff[0] ^ dff[1]) == 1'b1) begin
             q_next = {N{1'b1}};
        // otherwise count down to 0
        end else if (q_reg > 0) begin
             q_next = q_reg - 1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            db_level <= 0;
        else if (q_reg == 0)
            // lock in the clean input
            db_level <= dff[1]; 
    end

    // detect edge of clean input
    reg db_level_delayed;
    always @(posedge clk) begin
        db_level_delayed <= db_level;
    end
    
    // pulse is high only when current is 1 and previous was 0
    assign db_tick = db_level & ~db_level_delayed;

endmodule
