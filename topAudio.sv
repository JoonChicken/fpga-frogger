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
	logic enableJumpSound, enableWinSound, enableLoseSound;

	jumpAudio myJump (.clk(clk), .enable(enableJumpSound), .jumpSoundOut(jumpSoundIn));
	winAudio myWin (.clk(clk), .enable(enableWinSound), .winSoundOut(winSoundIn));
	loseAudio myLose (.clk(clk), .enable(enableLoseSound), .loseSoundOut(loseSoundIn));

	always_comb begin

		if (jumpForward | jumpBackward | jumpRight | jumpLeft) begin
			sound = jumpSoundIn;
			enableJumpSound = 1'b1;
		end else if (win) begin
			sound = winSoundIn;
			enableWinSound = 1'b1;
		end else if (lose) begin
			sound = loseSoundIn;
			enableLoseSound = 1'b1;
		end else begin
			sound = 1'b0;
		end
	end
endmodule