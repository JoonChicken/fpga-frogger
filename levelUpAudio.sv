module levelUpAudio (
  input logic enable,
  input logic clk,
  output logic levelUpAudioOut
);

  logic prevEnable;
logic [16:0] freqCount;
logic [23:0] timer;
logic timerEnable;

    //play sound at certain frequency until timer reaches desired duration
always_ff @(posedge clk) begin
	prevEnable <= enable;

	if (enable == 1'b1 & prevEnable == 1'b0) begin
			timerEnable <= 1'b1;
	end else if (timer >= 24'd12500000) begin
			timerEnable <= 0;
	end
	
	if (timer < 24'd3125000 & timerEnable) begin
		timer <= timer + 1;
        
    if (freqCount < 23985) begin
			freqCount <= freqCount + 1;
			levelUpSoundOut <= 1;
    end else if (freqCount < 47969) begin
			freqCount <= freqCount + 1;
			levelUpSoundOut <= 0;
    end else if (freqCount == 47969) begin
			freqCount <= 0;
			levelUpSoundOut <=0;
		end
        
    end else if (timer < 24'd6250000 & timerEnable) begin
		timer <= timer + 1;
		
        if (freqCount < 21368) begin
			freqCount <= freqCount + 1;
			levelUpSoundOut <= 1;
        end else if (freqCount < 427356) begin
			freqCount <= freqCount + 1;
			levelUpSoundOut <= 0;
        end else if (freqCount == 42736) begin
			freqCount <= 0;
			levelUpSoundOut <=0;
		end
	    
    end else if (timer < 24'd12500000 & timerEnable) begin
		timer <= timer + 1;
      if (freqCount < 19037) begin
			freqCount <= freqCount + 1;
			levelUpSoundOut <= 1;
        end else if (freqCount < 38073) begin
			freqCount <= freqCount + 1;
			levelUpSoundOut <= 0;
        end else if (freqCount == 38073) begin
			freqCount <= 0;
			levelUpSoundOut <=0;
		end

	end else if (timer >= 24'd12500000) begin
		timer <= 24'b0;
	end
end

endmodule 
