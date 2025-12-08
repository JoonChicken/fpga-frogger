/*module VgaScrollingBar (
    input logic clk,         // 25.175 MHz (Pixel Clock)
    input logic reset_n,     // Asynchronous active-low reset

    // VGA Output Signals
    output logic h_sync,     // Horizontal Sync Pulse (Active Low)
    output logic v_sync,     // Vertical Sync Pulse (Active Low)
    output logic video_on,   // Indicates Active Display Area
    output logic [7:0] red_out,
    output logic [7:0] green_out,
    output logic [7:0] blue_out
);

    // --- VGA Timing Parameters (640x480@60Hz) ---
    // Horizontal Timing (Total = 800 clocks)
    parameter H_ACTIVE      = 640;  // Visible pixels
    parameter H_FRONT_PORCH = 16;   // Blanking before sync
    parameter H_SYNC_PULSE  = 96;   // Sync pulse width
    parameter H_BACK_PORCH  = 48;   // Blanking after sync
    parameter H_TOTAL       = H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH; // 800

    // Vertical Timing (Total = 525 lines)
    parameter V_ACTIVE      = 480;  // Visible lines
    parameter V_FRONT_PORCH = 10;   // Blanking before sync
    parameter V_SYNC_PULSE  = 2;    // Sync pulse width
    parameter V_BACK_PORCH  = 33;   // Blanking after sync
    parameter V_TOTAL       = V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH; // 525

    // --- Color ROM Definitions (Your two colors) ---
    // The outputs are 8-bit per color, assuming an R-2R DAC or similar interface.
    // Full Saturation Blue (0x0000FF)
    localparam BLUE_R  = 8'h00;
    localparam BLUE_G  = 8'h00;
    localparam BLUE_B  = 8'hFF;
    
    // Brown (0x964B00)
    localparam BROWN_R = 8'h96;
    localparam BROWN_G = 8'h4B;
    localparam BROWN_B = 8'h00;


  // Counters to track the current pixel position
    logic [$clog2(H_TOTAL)-1:0] h_count;
    logic [$clog2(V_TOTAL)-1:0] v_count;

    // --- Counter Logic ---
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                // End of line - reset Horizontal counter, increment Vertical
                h_count <= 0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 0; // End of frame - reset Vertical counter
                else
                    v_count <= v_count + 1;
            end else begin
                // Still counting along the line
                h_count <= h_count + 1;
            end
        end
    end

    // --- Sync Signal Generation ---
    // HSYNC and VSYNC are typically active-low.
    assign h_sync = ~((h_count >= H_ACTIVE + H_FRONT_PORCH) && 
                      (h_count < H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE));
                      
    assign v_sync = ~((v_count >= V_ACTIVE + V_FRONT_PORCH) && 
                      (v_count < V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE));

    // Video is ON only when both counters are in the active display area
    assign video_on = (h_count < H_ACTIVE) && (v_count < V_ACTIVE);


  // Bar Parameters
    parameter BAR_WIDTH = 100; // The width of the brown bar in pixels
    parameter SPEED_DIVIDER = 500_000; // Determines how often the bar moves (higher = slower)

    logic [$clog2(SPEED_DIVIDER)-1:0] speed_counter = 0;
    logic [9:0] scroll_offset = 0; // The horizontal shift of the bar

    // --- Scrolling Logic ---
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            speed_counter <= 0;
            scroll_offset <= 0;
        end else begin
            // Increment scroll_offset only after the speed_counter overflows
            if (speed_counter == SPEED_DIVIDER - 1) begin
                speed_counter <= 0;
                // Increment the offset. Use modulo to wrap the bar across the screen.
                scroll_offset <= (scroll_offset + 1) % H_ACTIVE; 
            end else begin
                speed_counter <= speed_counter + 1;
            end
        end
    end

    // --- Bar Detection Logic ---
    // The bar is visible when the current H_COUNT is between (offset) and (offset + width).
    // We use the same (h_count + scroll_offset) trick as before to simplify the check
    // and let the bar smoothly wrap around the screen.
    logic is_brown_bar;
    
    // Calculate the effective horizontal position (wrapping is handled by H_ACTIVE's boundary)
    // Note: This logic assumes you want the bar to wrap.
    wire [9:0] wrapped_h_pos = (h_count + scroll_offset);
    
    assign is_brown_bar = 
        // We are in the active video area
        (video_on) && 
        // The wrapped position is within the bar's defined width
        ((wrapped_h_pos % H_ACTIVE) < BAR_WIDTH);


  // --- Color Mux (ROM access is essentially a parameter lookup here) ---
    always_comb begin
        if (video_on) begin
            if (is_brown_bar) begin
                // Output Brown
                red_out   = BROWN_R;
                green_out = BROWN_G;
                blue_out  = BROWN_B;
            end else begin
                // Output Blue (Background)
                red_out   = BLUE_R;
                green_out = BLUE_G;
                blue_out  = BLUE_B;
            end
        end else begin
            // Output Black during Blanking Period
            red_out   = 8'h00;
            green_out = 8'h00;
            blue_out  = 8'h00;
        end
    end

endmodule
