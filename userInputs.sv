module userInputs (
	input logic clk,
	input logic forward, backward, right, left,
	output logic forwardPulse, backwardPulse, rightPulse, leftPulse
);

//synchronize inputs
logic forward0, forward1, backward0, backward1, right0, right1, left0, left1;

always_ff @(posedge clk) begin
	forward1 <= forward0;
	forward0 <= forward;

	backward1 <= backward0;
	backward0 <= backward;

	right1 <= right0;
	right0 <= right;

	left1 <= left0;
	left0 <= left;
end


	logic reset = 1'b0;


//debounce inputs (calling debouncer module)
logic debForward, debBackward, debRight, debLeft;
logic forwardLvl, backwardLvl, rightLvl, leftLvl;

debouncer myForwardDeb (.clk(clk), .reset(reset), .btn_in(forward1), .db_level(forwardLvl), .db_tick(debForward));
debouncer myBackwardDeb (.clk(clk), .reset(reset), .btn_in(backward1), .db_level(backwardLvl), .db_tick(debBackward));
debouncer myRightDeb (.clk(clk), .reset(reset), .btn_in(right1), .db_level(rightLvl), .db_tick(debForward));
debouncer myLeftDeb (.clk(clk), .reset(reset), .btn_in(left1), .db_level(leftLvl), .db_tick(debLeft));






//pulse creator
logic prevForward, prevBackwards, prevRight, prevLeft;

always_ff @(posedge clk) begin
	prevForward <= debForward;
	prevBackward <= debBackward;
	prevRight <= debRight;
	prevLeft <= debLeft;
end

assign forwardPulse = debForward & ~prevForward;
assign backwardPulse = debBackwards & ~prevBackwards;
assign rightPulse = debRight & ~prevRight;
assign leftPulse = debLeft & ~prevLeft;

endmodule 