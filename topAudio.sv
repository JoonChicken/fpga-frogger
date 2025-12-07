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

    logic jumpSoundIn, winSoundIn, loseSoundIn;
    logic enableJumpSound, enableWinSound, enableLoseSound;

    typedef enum logic [1:0] {none, jumpState, winState, loseState} soundState;
    soundState activeSound;

    logic [23:0] timer;
    logic timerRunning;

    jumpAudio myJump (.clk(clk), .enable(enableJumpSound), .jumpSoundOut(jumpSoundIn));
    winAudio  myWin  (.clk(clk), .enable(enableWinSound),  .winSoundOut(winSoundIn));
   // loseAudio myLose (.clk(clk), .enable(enableLoseSound), .loseSoundOut(loseSoundIn));


    
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
        if (anyJump & ~anyJumpPrev) begin
            activeSound  <= jumpState;
            timer        <= 12500000;
            timerRunning <= 1'b1;
        end 
        else if (win & ~winPrev) begin
            activeSound  <= winState;
            timer        <= 12500000;
            timerRunning <= 1'b1;
        end
        else if (lose & ~losePrev) begin
            activeSound  <= loseState;
            timer        <= 12500000;
            timerRunning <= 1'b1;
        end
        
        else if (timerRunning) begin
            if (timer == 0) begin
                activeSound  <= none;
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
            jumpState: begin
                sound           = jumpSoundIn;
                enableJumpSound = 1'b1;
            end
            winState: begin
                sound          = winSoundIn;
                enableWinSound = 1'b1;
            end
    //        loseState: begin
    //            sound           = loseSoundIn;
   //             enableLoseSound = 1'b1;
   //         end
            default: ; // none
        endcase
    end

endmodule
