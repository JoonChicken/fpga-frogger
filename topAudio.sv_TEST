module topAudio (
	input logic clk;
input logic jump_forwards,
input logic jump_backwards,
input logic jump_right,
input logic jump_left,
input logic win;
input logic lose,
output logic sound,
);

logic jumpSoundIn, winSoundIn, loseSoundIn;


jumpAudio myJump (.clk(clk), .jumpSoundOut(jumpSoundIn));
winAudio myWin (.clk(clk), .winSoundOut(winSoundIn));
loseAudio myLose (.clk(clk), .loseSoundOut(loseSoundIn));

always_comb begin

if (jump_forwards | jump_backwards | jump_right | jump_left) begin
		
		sound = jumpSoundIn;

end



if (win) begin

		sound = winSoundIn;

end



if (lose) begin

		sound = loseSoundIn;

end
end
