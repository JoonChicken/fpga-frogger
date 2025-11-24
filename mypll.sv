/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:        12.000 MHz
 * Requested output frequency:   25.175 MHz
 * Achieved output frequency:    25.125 MHz
 */

// module mypll(
// 	input  clock_in,
// 	output clock_out,
// 	output locked
// 	);

// SB_PLL40_CORE #(
// 		.FEEDBACK_PATH("SIMPLE"),
// 		.DIVR(4'b0000),		// DIVR =  0
// 		.DIVF(7'b1000010),	// DIVF = 66
// 		.DIVQ(3'b101),		// DIVQ =  5
// 		.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
// 	) uut (
// 		.LOCK(locked),
// 		.RESETB(1'b1),
// 		.BYPASS(1'b0),
// 		.REFERENCECLK(clock_in),
// 		.PLLOUTCORE(clock_out)
// 		);

// endmodule

module mypll (
    input  ref_clk_i,    // 12 MHz clock from Upduino pin
    input  rst_n_i,      // active-low reset
    output outcore_o,    // internal routed clock
    output outglobal_o   // global clock (preferred)
);

    wire lock;

    SB_PLL40_CORE #(
    .DIVR(4'd0),
    .DIVF(7'd66),
    .DIVQ(3'd5),
    .FILTER_RANGE(3'b001),
    .FEEDBACK_PATH("SIMPLE")
) pll_inst (
    .REFERENCECLK(ref_clk_i),   // take clock from fabric
    .PLLOUTCORE(outcore_o),
    .PLLOUTGLOBAL(outglobal_o),
    .RESETB(rst_n_i),
    .BYPASS(1'b0),
    .LOCK(lock)
);

endmodule