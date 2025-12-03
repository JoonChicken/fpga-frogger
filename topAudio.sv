module topAudio (
	input logic clk,
	
	input logic jumpForward,
	input logic jumpBackward,
	input logic jumpRight,
	input logic jumpLeft,
	
	input logic win,
	input logic lose,
	
	output logic sound
);

	logic jumpSoundIn, winSoundIn, loseSoundIn;


	jumpAudio myJump (.clk(clk), .jumpSoundOut(jumpSoundIn));
	winAudio myWin (.clk(clk), .winSoundOut(winSoundIn));
	loseAudio myLose (.clk(clk), .loseSoundOut(loseSoundIn));

	always_comb begin

		if (jumpForward | jumpBackward | jumpRight | jumpLeft) begin
			sound = jumpSoundIn;
		end else if (win) begin
			sound = winSoundIn;
		end else if (lose) begin
			sound = loseSoundIn;
		end else begin
			sound = 0;
		end
	end
endmodule
