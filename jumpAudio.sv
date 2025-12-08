//Divide 25.1MGHz into usable hertz for sound, play notes (boing? somehow)

module jumpAudio (
input logic clk,
input logic enable,
output logic jumpSoundOut
);
	logic [16:0] freqCount;
	logic [23:0] timer;

//play sound at certain frequency until timer reaches desired duration
always_ff @(posedge clk) begin
	if (timer < 24'd2000000 & enable) begin
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
	end else if (timer == 24'd2000000) begin
		timer <= 24'b0;
	end
end


endmodule 
