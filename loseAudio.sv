module loseAudio (
    input logic enable,
    input logic clk,
    output logic loseSoundOut
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
        
        if (freqCount < 114091) begin
			freqCount <= freqCount + 1;
			loseSoundOut <= 1;
		end else if (freqCount < 228182) begin
			freqCount <= freqCount + 1;
			loseSoundOut <= 0;
		end else if (freqCount == 228182) begin
			freqCount <= 0;
			loseSoundOut <=0;
		end
        
    end else if (timer < 24'd6250000 & timerEnable) begin
		timer <= timer + 1;
		
        if (freqCount < 128061) begin
			freqCount <= freqCount + 1;
			loseSoundOut <= 1;
        end else if (freqCount < 256122) begin
			freqCount <= freqCount + 1;
			loseSoundOut <= 0;
        end else if (freqCount == 256122) begin
			freqCount <= 0;
			loseSoundOut <=0;
		end
	    
    end else if (timer < 24'd12500000 & timerEnable) begin
		timer <= timer + 1;
		if (freqCount < 143757) begin
			freqCount <= freqCount + 1;
			loseSoundOut <= 1;
		end else if (freqCount < 287514) begin
			freqCount <= freqCount + 1;
			loseSoundOut <= 0;
		end else if (freqCount == 287514) begin
			freqCount <= 0;
			loseSoundOut <=0;
		end

	end else if (timer >= 24'd12500000) begin
		timer <= 24'b0;
	end
end
	
endmodule 
