module winAudio (
    input logic enable,
    input logic clk,
    output logic winSoundOut
);

logic prevEnable;
logic [16:0] freqCount;
logic [23:0] timer;

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
	if (timer < 24'd13125000 & timerEnable) begin
		timer <= timer + 1;
        
        if (freqCount < 4474) begin
			freqCount <= freqCount + 1;
			winSoundOut <= 1;
        end else if (freqCount < 8948) begin
			freqCount <= freqCount + 1;
			winSoundOut <= 0;
        end else if (freqCount == 8948) begin
			freqCount <= 0;
			winSoundOut <=0;
		end
        
    end else if (timer < 24'd6250000 & timerEnable) begin
		timer <= timer + 1;
		
        if (freqCount < 3986) begin
			freqCount <= freqCount + 1;
			winSoundOut <= 1;
        end else if (freqCount < 7972) begin
			freqCount <= freqCount + 1;
			winSoundOut <= 0;
        end else if (freqCount == 7972) begin
			freqCount <= 0;
			winSoundOut <=0;
		end
	    
    end else if (timer < 24'd12500000 & timerEnable) begin
		timer <= timer + 1;
        if (freqCount < 3551) begin
			freqCount <= freqCount + 1;
			winSoundOut <= 1;
        end else if (freqCount < 7102) begin
			freqCount <= freqCount + 1;
			winSoundOut <= 0;
        end else if (freqCount == 7102) begin
			freqCount <= 0;
			winSoundOut <=0;
		end

	end else if (timer == 24'd12500000) begin
		timer <= 24'b0;
	end
end










endmodule 
