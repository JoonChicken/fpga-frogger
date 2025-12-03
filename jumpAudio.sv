//Divide 48MGHz into usable hertz for sound, play notes (boing? somehow)

module jumpAudio (
input logic clk,
output logic jumpSoundOut
);

logic [16:0] curCount;


always_ff @(posedge clk) begin
	curCount <=curCount + 1;
end


always_comb
	if (curCount == 54545)
		jumpSoundOut = 1’b1;
		curCount = 0;
	end else
		jumpSoundOut = 1’b0;
end

endmodule 

