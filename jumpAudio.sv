//Divide 48MGHz into usable hertz for sound, play notes (boing? somehow)

module jumpAudio (
input logic clk,
output logic jumpSoundOut
);

logic [16:0] curCount;


always_ff @(posedge clk) begin
	if (curCount == 10) begin
		curCount <= 16'b0;
	end else begin
		curCount <=curCount + 1;
	end
end


always_comb begin
	if (curCount == 10) begin
		jumpSoundOut = 1'b1;
	end else begin
		jumpSoundOut = 1'b0;
	end
end

endmodule 

