module topAudio #(
    parameter HOLD_CYCLES = 12_500_000    // ~0.5s at 25 MHz
)(
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
    logic [$clog2(HOLD_CYCLES):0] timer;
    logic timerRunning;

    // instantiate sound generators
    jumpAudio myJump (.clk(clk), .enable(enableJumpSound), .jumpSoundOut(jumpSoundIn));
    winAudio  myWin  (.clk(clk), .enable(enableWinSound),  .winSoundOut(winSoundIn));
    loseAudio myLose (.clk(clk), .enable(enableLoseSound), .loseSoundOut(loseSoundIn));

    //-------------------------------
    // Rising-edge pulses
    //-------------------------------
    logic jumpAny, jumpAnyPrev;
    logic winPrev, losePrev;

    assign jumpAny = jumpForward | jumpBackward | jumpRight | jumpLeft;

    always_ff @(posedge clk) begin
        jumpAnyPrev <= jumpAny;
        winPrev     <= win;
        losePrev    <= lose;
    end

    wire jumpPulse = (jumpAny & ~jumpAnyPrev);
    wire winPulse  = (win      & ~winPrev);
    wire losePulse = (lose     & ~losePrev);

    //-------------------------------
    // Timer + latch active sound
    //-------------------------------
    always_ff @(posedge clk) begin
        
        // new request overrides whatever is playing
        if (jumpPulse) begin
            activeSound  <= JUMP;
            timer        <= HOLD_CYCLES;
            timerRunning <= 1'b1;
        end 
        else if (winPulse) begin
            activeSound  <= WIN_S;
            timer        <= HOLD_CYCLES;
            timerRunning <= 1'b1;
        end
        else if (losePulse) begin
            activeSound  <= LOSE_S;
            timer        <= HOLD_CYCLES;
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
        enableLoseSound  = 1'b0;

        case (activeSound)
            JUMP: begin
                sound           = jumpSoundIn;
                enableJumpSound = 1'b1;
            end
            WIN_S: begin
                sound          = winSoundIn;
                enableWinSound = 1'b1;
            end
            LOSE_S: begin
                sound           = loseSoundIn;
                enableLoseSound = 1'b1;
            end
            default: ; // NONE
        endcase
    end

endmodule
