module ui_gen(
    input logic clk,
    input [1:0] state,
    input logic [9:0] colPos,
    input logic [9:0] rowPos,

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
    assign colPos_local = (colPos - X_TITLE_OFFSET) / TITLE_SCALE;
    assign rowPos_local = (rowPos - Y_TITLE_OFFSET) / TITLE_SCALE;

    text_gen text_gen (
        .char_addr(ascii),
        .row_addr(rowPos_local),
        .bitmap(charRowData)
    );


    /*********************************************
     *
     *              TITLE GEN   
     *
     *********************************************/

    parameter TITLE_SCALE = 7;
    parameter TITLE_WIDTH = 56 * TITLE_SCALE;
    parameter TITLE_HEIGHT = 10 * TITLE_SCALE + 20;
    parameter X_TITLE_OFFSET = X_OFFSET_LEFT + (224 - TITLE_SCALE * 28);
    parameter Y_TITLE_OFFSET = 240 - TITLE_SCALE * 5 - 50;


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
    parameter Y_SUBTITLE_OFFSET = 240 + 80;

    wire [9:0] colPos_subtitlelocal;
    wire [9:0] rowPos_subtitlelocal;
    wire [5:0] charIndex;
    wire [7:0] str [0:21];
        assign str[0]  = "P";
        assign str[1]  = "R";
        assign str[2]  = "E";
        assign str[3]  = "S";
        assign str[4]  = "S";
        assign str[5]  = " ";
        assign str[6]  = "A";
        assign str[7]  = "N";
        assign str[8]  = "Y";
        assign str[9]  = " ";
        assign str[10] = "K";
        assign str[11] = "E";
        assign str[12] = "Y";
        assign str[13] = " ";
        assign str[14] = "T";
        assign str[15] = "O";
        assign str[16] = " ";
        assign str[17] = "S";
        assign str[18] = "T";
        assign str[19] = "A";
        assign str[20] = "R";
        assign str[21] = "T";
    wire [7:0] ascii;
    wire [7:0] charRowData;
    wire [2:0] charPixCol;

    assign colPos_subtitlelocal = (colPos - X_SUBTITLE_OFFSET) / SUBTITLE_SCALE;
    assign rowPos_subtitlelocal = (rowPos - Y_SUBTITLE_OFFSET) / SUBTITLE_SCALE;
    assign charIndex = colPos_subtitlelocal / 8;
    assign ascii = str[charIndex];
    assign charPixCol = 8 - colPos_subtitlelocal % 8;


    /*********************************************
     *
     *              SCORE GEN   
     *
     *********************************************/
    

    parameter SCORE_LEN = 10;
    parameter SCORE_SCALE = 2;
    parameter SCORE_WIDTH = SUBTITLE_LEN * 8 * SCORE_SCALE;
    parameter SCORE_HEIGHT = 8 * SCORE_SCALE;
    parameter X_SCORE_OFFSET = X_OFFSET_LEFT + 5;
    parameter Y_SCORE_OFFSET = 5;
    wire [9:0] colPos_scorelocal;
    wire [9:0] rowPos_scorelocal;
    wire [5:0] scorecharIndex;
    wire [7:0] scorestr [0:10];
        assign scorestr[0]  = "S";
        assign scorestr[1]  = "C";
        assign scorestr[2]  = "O";
        assign scorestr[3]  = "R";
        assign scorestr[4]  = "E";
        assign scorestr[5]  = ":";
        assign scorestr[6]  = " ";
        assign scorestr[7]  = "0";
        assign scorestr[8]  = "0";
        assign scorestr[9]  = "0";

    

    /*********************************************
     *
     *            OUTPUTTING   
     *
     *********************************************/


    always_comb begin
        // ---------------------------------------------------------------------------------- SCORE
        if (colPos >= X_SCORE_OFFSET && colPos < X_SCORE_OFFSET + SCORE_WIDTH &&
            rowPos >= Y_SCORE_OFFSET && rowPos < Y_SCORE_OFFSET + SCORE_HEIGHT) begin
            rowPos_local = rowPos_scorelocal;


            if (charRowData[charPixCol] == 1'b1) begin
                color = RED;
            end else begin
                color = BLACK;
            end

        end else if (display_title) begin
        // ---------------------------------------------------------------------------------- TITLE
            if (colPos >= X_TITLE_OFFSET && colPos < X_TITLE_OFFSET + TITLE_WIDTH &&
                rowPos >= Y_TITLE_OFFSET && rowPos < Y_TITLE_OFFSET + TITLE_HEIGHT) begin
                rowPos_local = rowPos_titlelocal;



                if (charRowData[charPixCol] == 1'b1) begin
                    color = RED;
                end else begin
                    color = BLACK;
                end
        // ---------------------------------------------------------------------------------- SUBTITLE
            end else if (colPos >= X_SUBTITLE_OFFSET && colPos < X_SUBTITLE_OFFSET + SUBTITLE_WIDTH &&
                         rowPos >= Y_SUBTITLE_OFFSET && rowPos < Y_SUBTITLE_OFFSET + SUBTITLE_HEIGHT) begin
                rowPos_local = rowPos_subtitlelocal;



                if (charRowData[charPixCol] == 1'b1) begin
                    color = RED;
                end else begin
                    color = BLACK;
                end

            end 
        end else begin
            color = BLACK;
        end
    end

endmodule