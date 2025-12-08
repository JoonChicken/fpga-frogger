module ui_gen(
    input logic clk,
    input [1:0] state,
    input logic [9:0] colPos,
    input logic [9:0] rowPos,
    input logic btn_up_tick,
    input logic btn_down_tick,
    output logic [5:0] color
);

    parameter RED = 6'b110000;
    parameter BLACK = 6'b000000;
    parameter X_OFFSET_LEFT = 10'd96;
    parameter X_OFFSET_RIGHT = 10'd544;
    parameter BLOCKSIZE = 10'd32;


    /*********************************************
     *
     *            state interactions     
     *
     *********************************************/

    enum logic [1:0] {MENU, PLAYING, DEAD, WIN} statetype;
    enum logic [1:0] {UI_PRESS, NEXTLEVEL, CRASH, CELEBRATION} soundtype;

    logic display_title;
    assign display_title = state == MENU;

    /*********************************************
     *
     *              GEN SETUP     
     *
     *********************************************/


    wire [9:0] colPos_local;
    wire [9:0] rowPos_local;
    wire [7:0] ascii;
    
    wire [5:0] charIndex;
    wire [2:0] charPixCol;
    assign charIndex = colPos_local / 8;
    assign charPixCol = 8 - colPos_local % 8;

    wire [7:0] charRowData;

    text_gen text_gen (
        .char_addr(ascii),
        .row_addr(rowPos_local),
        .bitmap(charRowData)
    );


    /*********************************************
     *
     *              SCORE GEN   
     *
     *********************************************/
    

    parameter SCORE_LEN = 10;
    parameter SCORE_SCALE = 2;
    parameter SCORE_WIDTH = SCORE_LEN * 8 * SCORE_SCALE;
    parameter SCORE_HEIGHT = 8 * SCORE_SCALE;
    parameter X_SCORE_OFFSET = X_OFFSET_LEFT + 5;
    parameter Y_SCORE_OFFSET = 5;

    wire [7:0] scorestr [0:9];
        assign scorestr[0]  = "S";
        assign scorestr[1]  = "C";
        assign scorestr[2]  = "O";
        assign scorestr[3]  = "R";
        assign scorestr[4]  = "E";
        assign scorestr[5]  = ":";
        assign scorestr[6]  = " ";

    wire [9:0] colPos_scorelocal;
    wire [9:0] rowPos_scorelocal;
    wire [7:0] scoreascii;
    assign colPos_scorelocal = (colPos - X_SCORE_OFFSET) / SCORE_SCALE;
    assign rowPos_scorelocal = (rowPos - Y_SCORE_OFFSET) / SCORE_SCALE;
    assign scoreascii = scorestr[charIndex];

    // Actual score tracker
    wire [9:0] score;
    wire [9:0] currY;

    always_ff @(posedge clk) begin
        if (state == MENU) begin
            currY <= 0;
            score <= 0;
        end else if (btn_up_tick) begin
            currY <= currY + 1;
            if (currY > score) score <= currY;
        end else if (btn_down_tick) begin
            currY <= currY - 1;
        end
    end

    always_comb begin
        scorestr[7] = (score / 100) % 10 + 48;
        scorestr[8] = (score / 10) % 10 + 48;
        scorestr[9] = score % 10 + 48;
    end


    /*********************************************
     *
     *              TITLE GEN   
     *
     *********************************************/

    parameter TITLE_LEN = 7;
    parameter TITLE_SCALE = 7;
    parameter TITLE_WIDTH = 56 * TITLE_SCALE;
    parameter TITLE_HEIGHT = 8 * TITLE_SCALE;
    parameter X_TITLE_OFFSET = X_OFFSET_LEFT + (224 - TITLE_SCALE * 28);
    parameter Y_TITLE_OFFSET = 240 - TITLE_SCALE * 5 - 50;

    wire [7:0] titlestr [0:6];
        assign titlestr[0]  = "F";
        assign titlestr[1]  = "R";
        assign titlestr[2]  = "O";
        assign titlestr[3]  = "G";
        assign titlestr[4]  = "G";
        assign titlestr[5]  = "E";
        assign titlestr[6]  = "R";

    wire [9:0] colPos_titlelocal;
    wire [9:0] rowPos_titlelocal;
    wire [7:0] titleascii;
    assign colPos_titlelocal = (colPos - X_TITLE_OFFSET) / TITLE_SCALE;
    assign rowPos_titlelocal = (rowPos - Y_TITLE_OFFSET) / TITLE_SCALE;
    assign titleascii = titlestr[charIndex];


    /*********************************************
     *
     *              SUBTITLE GEN    
     *
     *********************************************/

    parameter SUBTITLE_LEN = 22;
    parameter SUBTITLE_SCALE = 2;
    parameter SUBTITLE_WIDTH = SUBTITLE_LEN * 8 * SUBTITLE_SCALE;
    parameter SUBTITLE_HEIGHT = 8 * SUBTITLE_SCALE;
    parameter X_SUBTITLE_OFFSET = 640/2 - SUBTITLE_WIDTH / 2;
    parameter Y_SUBTITLE_OFFSET = 240 + 90;

    wire [7:0] subtitlestr [0:21];
        assign subtitlestr[0]  = "P";
        assign subtitlestr[1]  = "R";
        assign subtitlestr[2]  = "E";
        assign subtitlestr[3]  = "S";
        assign subtitlestr[4]  = "S";
        assign subtitlestr[5]  = " ";
        assign subtitlestr[6]  = "A";
        assign subtitlestr[7]  = "N";
        assign subtitlestr[8]  = "Y";
        assign subtitlestr[9]  = " ";
        assign subtitlestr[10] = "K";
        assign subtitlestr[11] = "E";
        assign subtitlestr[12] = "Y";
        assign subtitlestr[13] = " ";
        assign subtitlestr[14] = "T";
        assign subtitlestr[15] = "O";
        assign subtitlestr[16] = " ";
        assign subtitlestr[17] = "S";
        assign subtitlestr[18] = "T";
        assign subtitlestr[19] = "A";
        assign subtitlestr[20] = "R";
        assign subtitlestr[21] = "T";

    wire [9:0] colPos_subtitlelocal;
    wire [9:0] rowPos_subtitlelocal;
    wire [7:0] subtitleascii;
    assign colPos_subtitlelocal = (colPos - X_SUBTITLE_OFFSET) / SUBTITLE_SCALE;
    assign rowPos_subtitlelocal = (rowPos - Y_SUBTITLE_OFFSET) / SUBTITLE_SCALE;
    assign subtitleascii = subtitlestr[charIndex];


    // subtitle flashing
    wire [23:0] flash_timer;
    wire display_subtitle;
    wire next_display_subtitle;

    always_ff @(posedge clk) begin
        flash_timer <= flash_timer + 1;
        if (flash_timer == 'b0) display_subtitle <= ~display_subtitle;
    end


    

    /*********************************************
     *
     *            OUTPUTTING   
     *
     *********************************************/


    always_comb begin
        // ---------------------------------------------------------------------------------- SCORE
        if (colPos >= X_SCORE_OFFSET && colPos < X_SCORE_OFFSET + SCORE_WIDTH &&
            rowPos >= Y_SCORE_OFFSET && rowPos < Y_SCORE_OFFSET + SCORE_HEIGHT) begin
            colPos_local = colPos_scorelocal;
            rowPos_local = rowPos_scorelocal;
            ascii = scoreascii;


            if (charRowData[charPixCol] == 1'b1) begin
                color = RED;
            end else begin
                color = BLACK;
            end

        end else if (display_title) begin
        // ---------------------------------------------------------------------------------- TITLE
            if (colPos >= X_TITLE_OFFSET && colPos < X_TITLE_OFFSET + TITLE_WIDTH &&
                rowPos >= Y_TITLE_OFFSET && rowPos < Y_TITLE_OFFSET + TITLE_HEIGHT) begin
                colPos_local = colPos_titlelocal;
                rowPos_local = rowPos_titlelocal;
                ascii = titleascii;



                if (charRowData[charPixCol] == 1'b1) begin
                    color = RED;
                end else begin
                    color = BLACK;
                end
        // ---------------------------------------------------------------------------------- SUBTITLE
            end else if (display_subtitle &&
                colPos >= X_SUBTITLE_OFFSET && colPos < X_SUBTITLE_OFFSET + SUBTITLE_WIDTH &&
                rowPos >= Y_SUBTITLE_OFFSET && rowPos < Y_SUBTITLE_OFFSET + SUBTITLE_HEIGHT) begin
                colPos_local = colPos_subtitlelocal;
                rowPos_local = rowPos_subtitlelocal;
                ascii = subtitleascii;

                if (charRowData[charPixCol] == 1'b1) begin
                    color = RED;
                end else begin
                    color = BLACK;
                end

            end else begin
                colPos_local = 'b0;
                rowPos_local = 'b0;
                ascii = 'b0;
                color = BLACK;
            end
        end else begin
            colPos_local = 'b0;
            rowPos_local = 'b0;
            ascii = 'b0;
            color = BLACK;
        end
    end

endmodule