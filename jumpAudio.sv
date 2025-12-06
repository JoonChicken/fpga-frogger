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
end
	
//rising edge detector
always_ff @(posedge clk) begin
	if (enable == 1'b1 & prevEnable == 1'b0) begin
		timerEnable <= 1'b1;
	end else if (timer == 24'd12500000)
		timerEnable <= 0;
end

//play sound at certain frequency until timer reaches desired duration
always_ff @(posedge clk) begin
	if (timer < 24'd12500000 & timerEnable) begin
		timer <= timer + 1;
		if (freqCount < 14261) begin
			freqCount <= freqCount + 1;
			jumpSoundOut <= 1;
		end else if (freqCount < 28522) begin
			freqCount <= freqCount + 1;
			jumpSoundOut <= 0;
		end else if (freqCount == 28522) begin
			freqCount <= 0;
			jumpSoundOut <=0;
		end
	end else if (timer == 24'd12500000) begin
		timer <= 24'b0;
	end
end


endmodule 
