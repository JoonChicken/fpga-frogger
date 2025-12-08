module waterCollisionAudio (
    input logic enable,
    input logic clk,
    output logic waterSoundOut
);

logic prevEnable;
logic [16:0] freqCount;
logic [23:0] timer;


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
        
    if (freqCount < 40337) begin
			freqCount <= freqCount + 1;
			waterSoundOut <= 1;
        end else if (freqCount < 80674) begin
			freqCount <= freqCount + 1;
			waterSoundOut <= 0;
    end else if (freqCount == 80674) begin
			freqCount <= 0;
			waterSoundOut <=0;
		end
        
    end else if (timer < 24'd6250000 & timerEnable) begin
	  	timer <= timer + 1;
		
      if (freqCount < 45278) begin
		  	freqCount <= freqCount + 1;
		  	waterSoundOut <= 1;
      end else if (freqCount < 90556) begin
			  freqCount <= freqCount + 1;
			  waterSoundOut <= 0;
      end else if (freqCount == 90556) begin
			  freqCount <= 0;
			  waterSoundOut <=0;
		end

	end else if (timer >= 24'd6250000 begin
		timer <= 24'b0;
	end
end
	
endmodule 
