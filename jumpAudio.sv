//Divide 25.1MGHz into usable hertz for sound, play notes (boing? somehow)

module jumpAudio (
input logic clk,
input logic enable,
output logic jumpSoundOut
);

	logic prevEnable;
	logic [16:0] freqCount;
	logic [23:0] timer;

//validate each enable so only called once per input/call
always_ff begin
	if (enable == 1'b1 & prevEnable == 1'b0) begin
		timer = timer + 1;
	end
end

//start timer loop below if enabled
always_ff @(posedge clk) begin
	prevEnable <= enable;
end

//play sound at certain frequency until timer reaches desired duration
always_ff @(posedge clk) begin
	if (timer < 8'd12500000 & timer != 0) begin
		timer <= timer + 1;
		if (freqCount < 28523) begin
			freqCount <= freqCount + 1;
			jumpSoundOut <= 1;
		end else if (freqCount < 57046) begin
			freqCount <= freqCount + 1;
			jumpSoundOut <= 0;
		end else if (freqCount == 57046)
			freqCount <= 0;
		end
	end else
		timer <= 24'b0;
end


endmodule 
