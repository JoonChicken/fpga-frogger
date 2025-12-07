module topAudio (
    input  logic clk,
    
    input  logic jumpForward,
    input  logic jumpBackward,
    input  logic jumpRight,
    input  logic jumpLeft,
    
    input  logic win,
    input  logic lose,
    
    output logic sound
);

    // incoming sound generators
    logic jumpSoundIn, winSoundIn, loseSoundIn;
    logic enableJumpSound, enableWinSound, enableLoseSound;

    // latch which sound is currently playing
    typedef enum logic [1:0] { NONE, JUMP, WIN_S, LOSE_S } sound_t;
    sound_t activeSound;

    // timer
    logic [23:0] timer;
    logic timerRunning;

    // instantiate sound generators
    jumpAudio myJump (.clk(clk), .enable(enableJumpSound), .jumpSoundOut(jumpSoundIn));
    winAudio  myWin  (.clk(clk), .enable(enableWinSound),  .winSoundOut(winSoundIn));
   // loseAudio myLose (.clk(clk), .enable(enableLoseSound), .loseSoundOut(loseSoundIn));

    //-------------------------------
    // Rising-edge pulses
    //-------------------------------
    logic anyJump, anyJumpPrev;
    logic winPrev, losePrev;

    assign anyJump = jumpForward | jumpBackward | jumpRight | jumpLeft;

    always_ff @(posedge clk) begin
        anyJumpPrev <= anyJump;
        winPrev     <= win;
        losePrev    <= lose;
    end

    assign jumpPulse = (anyJump & ~anyJumpPrev);
    assign winPulse  = (win & ~winPrev);
    assign losePulse = (lose & ~losePrev);

    //-------------------------------
    // Timer + latch active sound
    //-------------------------------
    always_ff @(posedge clk) begin
        
        // new request overrides whatever is playing
        if (jumpPulse) begin
            activeSound  <= JUMP;
            timer        <= 12500000;
            timerRunning <= 1'b1;
        end 
        else if (winPulse) begin
            activeSound  <= WIN_S;
            timer        <= 12500000;
            timerRunning <= 1'b1;
        end
        else if (losePulse) begin
            activeSound  <= LOSE_S;
            timer        <= 12500000;
            timerRunning <= 1'b1;
        end

        // countdown
        else if (timerRunning) begin
            if (timer == 0) begin
                activeSound  <= NONE;
                timerRunning <= 1'b0;
            end else begin
                timer <= timer - 1;
            end
        end
    end

    //-------------------------------
    // Output routing
    //-------------------------------
    always_comb begin
        // default
        sound            = 1'b0;
        enableJumpSound  = 1'b0;
        enableWinSound   = 1'b0;
   //     enableLoseSound  = 1'b0;

        case (activeSound)
            JUMP: begin
                sound           = jumpSoundIn;
                enableJumpSound = 1'b1;
            end
            WIN_S: begin
                sound          = winSoundIn;
                enableWinSound = 1'b1;
            end
    //        LOSE_S: begin
    //            sound           = loseSoundIn;
   //             enableLoseSound = 1'b1;
   //         end
            default: ; // NONE
        endcase
    end

endmodule
