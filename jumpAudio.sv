//Divide 25.1MGHz into usable hertz for sound, play notes (boing? somehow)

module jumpAudio (
input logic clk,
input logic enable,
output logic jumpSoundOut
);

	logic prevEnable;
	logic [16:0] freqCount;
	logic [23:0] timer;

	logic timerEnable;

//start timer loops below if enabled
always_ff @(posedge clk) begin
	prevEnable <= enable;
	
	if (enable & !prevEnable) begin
		timerEnable <= 1'b1;
		timer <= 0;
		freqCount <= 0;
	end

	if (timerEnable == 1'b1) begin
		timer <= timer + 1;
		if (timer >= 24'd12500000) begin
			timerEnable <= 0;
		end
	end
end

//play sound at certain frequency until timer reaches desired duration
always_ff @(posedge clk) begin
	if (timerEnable) begin
		if (freqCount < 14261) begin
			freqCount <= freqCount + 1;
			jumpSoundOut <= 1;
		end else if (freqCount < 28522) begin
			freqCount <= freqCount + 1;
			jumpSoundOut <= 0;
		end else begin
			freqCount <= 0;
			jumpSoundOut <= 0;
		end
	end
end


endmodule 
