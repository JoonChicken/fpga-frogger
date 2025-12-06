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
     *                 TITLE GEN     
     *
     *********************************************/

    parameter TITLE_SCALE = 7;
    parameter TITLE_WIDTH = 56 * TITLE_SCALE;
    parameter TITLE_HEIGHT = 10 * TITLE_SCALE + 20;
    parameter X_TITLE_OFFSET = X_OFFSET_LEFT + (224 - TITLE_SCALE * 28);
    parameter Y_TITLE_OFFSET = 240 - TITLE_SCALE * 5 - 50;

    wire [9:0] colPos_titlelocal;
    wire [9:0] rowPos_titlelocal;
    assign colPos_titlelocal = (colPos - X_TITLE_OFFSET) / TITLE_SCALE;
    assign rowPos_titlelocal = (rowPos - Y_TITLE_OFFSET) / TITLE_SCALE;


    parameter SUBTITLE_SCALE = 2;
    parameter SUBTITLE_WIDTH = 22 * 8;
    parameter SUBTITLE_HEIGHT = 8;
    parameter X_SUBTITLE_OFFSET = X_OFFSET_LEFT + (224 - SUBTITLE_SCALE * 28);
    parameter Y_SUBTITLE_OFFSET = 240 + 80;

    wire [9:0] colPos_subtitlelocal;
    wire [9:0] rowPos_subtitlelocal;
    wire [5:0] charIndex;
    reg [22*16:1] str = "PRESS ANY KEY TO START";
    wire [16:1] ascii;
    wire [7:0] charRowData;
    wire [2:0] charPixColData;

    assign charIndex = colPos_subtitlelocal / 8;
    assign ascii = str[charIndex];
    assign colPos_subtitlelocal = (colPos - X_SUBTITLE_OFFSET) / SUBTITLE_SCALE;
    assign rowPos_subtitlelocal = (rowPos - Y_SUBTITLE_OFFSET) / SUBTITLE_SCALE;

    text_gen text_gen (
        .char_addr(ascii),
        .row_addr(rowPos_subtitlelocal),
        .bitmap(charRowData)
    );

    assign charPixColData = colPos_subtitlelocal % 8;


    always_comb begin
        if (display_title &&
            colPos >= X_TITLE_OFFSET && colPos < X_TITLE_OFFSET + TITLE_WIDTH &&
            rowPos >= Y_TITLE_OFFSET && rowPos < Y_TITLE_OFFSET + TITLE_HEIGHT) begin
            // this is stupid so I'm doing this another way for other text
            case ({rowPos_titlelocal, colPos_titlelocal})
                
                // ROW 1 ------------------------------------------------------------------------

                20'h000: color = RED;   // F
                20'b001: color = RED;
                20'h002: color = RED;
                20'h003: color = RED;
                20'h004: color = RED;
                20'h005: color = RED;
                20'h006: color = RED;
                20'h007: color = BLACK;

                20'h008: color = RED;
                20'h009: color = RED;  // R
                20'h00A: color = RED; 
                20'h00B: color = RED;
                20'h00C: color = RED;
                20'h00D: color = RED;
                20'h00E: color = BLACK;
                20'h00F: color = BLACK;

                20'h010: color = BLACK;  //O
                20'b011: color = RED;
                20'h012: color = RED;
                20'h013: color = RED;
                20'h014: color = RED;
                20'h015: color = RED;
                20'h016: color = BLACK;
                20'h017: color = BLACK;

                20'h018: color = BLACK;  //G
                20'h019: color = BLACK;
                20'h01A: color = RED;  
                20'h01B: color = RED;
                20'h01C: color = RED;
                20'h01D: color = RED;
                20'h01E: color = BLACK;
                20'h01F: color = BLACK;

                20'h020: color = BLACK;  //G
                20'h021: color = BLACK;
                20'h022: color = RED;
                20'h023: color = RED;
                20'h024: color = RED;
                20'h025: color = RED;
                20'h026: color = BLACK;
                20'h027: color = BLACK;

                20'h028: color = RED;  //E
                20'h029: color = RED;
                20'h02A: color = RED;  
                20'h02B: color = RED;
                20'h02C: color = RED;
                20'h02D: color = RED;
                20'h02E: color = RED;
                20'h02F: color = BLACK;

                20'h030: color = RED;  //R
                20'h031: color = RED;
                20'h032: color = RED;
                20'h033: color = RED;
                20'h034: color = RED;
                20'h035: color = RED;
                20'h036: color = BLACK;
                20'h037: color = BLACK;
                

                // ROW 2 ------------------------------------------------------------------------

                20'h400: color = BLACK;   // F
                20'h401: color = RED;
                20'h402: color = RED;
                20'h403: color = BLACK;
                20'h404: color = BLACK;
                20'h405: color = RED;
                20'h406: color = RED;
                20'h407: color = BLACK;

                20'h408: color = BLACK;
                20'h409: color = RED;  // R
                20'h40A: color = RED; 
                20'h40B: color = BLACK;
                20'h40C: color = BLACK;
                20'h40D: color = RED;
                20'h40E: color = RED;
                20'h40F: color = BLACK;

                20'h410: color = RED;  //O
                20'h411: color = RED;
                20'h412: color = BLACK;
                20'h413: color = BLACK;
                20'h414: color = BLACK;
                20'h415: color = RED;
                20'h416: color = RED;
                20'h417: color = BLACK;

                20'h418: color = BLACK;  //G
                20'h419: color = RED;
                20'h41A: color = RED;  
                20'h41B: color = BLACK;
                20'h41C: color = BLACK;
                20'h41D: color = RED;
                20'h41E: color = RED;
                20'h41F: color = BLACK;

                20'h420: color = BLACK;  //G
                20'h421: color = RED;
                20'h422: color = RED;  
                20'h423: color = BLACK;
                20'h424: color = BLACK;
                20'h425: color = RED;
                20'h426: color = RED;
                20'h427: color = BLACK;

                20'h428: color = BLACK;  //E
                20'h429: color = RED;
                20'h42A: color = RED;  
                20'h42B: color = BLACK;
                20'h42C: color = BLACK;
                20'h42D: color = RED;
                20'h42E: color = RED;
                20'h42F: color = BLACK;

                20'h430: color = BLACK;  //R
                20'h431: color = RED;  
                20'h432: color = RED; 
                20'h433: color = BLACK;
                20'h434: color = BLACK;
                20'h435: color = RED;
                20'h436: color = RED;
                20'h437: color = BLACK;


                // ROW 3 ------------------------------------------------------------------------

                20'h800: color = BLACK;   // F
                20'h801: color = RED;
                20'h802: color = RED;
                20'h803: color = BLACK;
                20'h804: color = BLACK;
                20'h805: color = BLACK;
                20'h806: color = RED;
                20'h807: color = BLACK;

                20'h808: color = BLACK;
                20'h809: color = RED;  // R
                20'h80A: color = RED; 
                20'h80B: color = BLACK;
                20'h80C: color = BLACK;
                20'h80D: color = RED;
                20'h80E: color = RED;
                20'h80F: color = BLACK;

                20'h810: color = RED;  //O
                20'h811: color = RED;
                20'h812: color = BLACK;
                20'h813: color = BLACK;
                20'h814: color = BLACK;
                20'h815: color = RED;
                20'h816: color = RED;
                20'h817: color = BLACK;

                20'h818: color = RED;  //G
                20'h819: color = RED;
                20'h81A: color = BLACK;  
                20'h81B: color = BLACK;
                20'h81C: color = BLACK;
                20'h81D: color = BLACK;
                20'h81E: color = RED;
                20'h81F: color = BLACK;

                20'h820: color = RED;    //G
                20'h821: color = RED;
                20'h822: color = BLACK;
                20'h823: color = BLACK;
                20'h824: color = BLACK;
                20'h825: color = BLACK;
                20'h826: color = RED;
                20'h827: color = BLACK;

                20'h828: color = BLACK;  //E
                20'h829: color = RED;
                20'h82A: color = RED;  
                20'h82B: color = BLACK;
                20'h82C: color = BLACK;
                20'h82D: color = BLACK;
                20'h82E: color = RED;
                20'h82F: color = BLACK;

                20'h830: color = BLACK;  //R
                20'h831: color = RED;  
                20'h832: color = RED; 
                20'h833: color = BLACK;
                20'h834: color = BLACK;
                20'h835: color = RED;
                20'h836: color = RED;
                20'h837: color = BLACK;


                // ROW 4 ------------------------------------------------------------------------

                20'hC00: color = BLACK;   // F
                20'hC01: color = RED;
                20'hC02: color = RED;
                20'hC03: color = BLACK;
                20'hC04: color = RED;
                20'hC05: color = BLACK;
                20'hC06: color = BLACK;
                20'hC07: color = BLACK;

                20'hC08: color = BLACK;  
                20'hC09: color = RED;  // R
                20'hC0A: color = RED;
                20'hC0B: color = BLACK;
                20'hC0C: color = BLACK;
                20'hC0D: color = RED;
                20'hC0E: color = RED;
                20'hC0F: color = BLACK;

                20'hC10: color = RED;  //O
                20'hC11: color = RED;
                20'hC12: color = BLACK;
                20'hC13: color = BLACK;
                20'hC14: color = BLACK;
                20'hC15: color = RED;
                20'hC16: color = RED;
                20'hC17: color = BLACK;

                20'hC18: color = RED;  //G
                20'hC19: color = RED;
                20'hC1A: color = BLACK;  
                20'hC1B: color = BLACK;
                20'hC1C: color = BLACK;
                20'hC1D: color = BLACK;
                20'hC1E: color = BLACK;
                20'hC1F: color = BLACK;

                20'hC20: color = RED;    //G
                20'hC21: color = RED;
                20'hC22: color = BLACK;
                20'hC23: color = BLACK;
                20'hC24: color = BLACK;
                20'hC25: color = BLACK;
                20'hC26: color = BLACK;
                20'hC27: color = BLACK;

                20'hC28: color = BLACK;    //E
                20'hC29: color = RED;
                20'hC2A: color = RED;
                20'hC2B: color = BLACK;
                20'hC2C: color = RED;
                20'hC2D: color = BLACK;
                20'hC2E: color = BLACK;
                20'hC2F: color = BLACK;

                20'hC30: color = BLACK;    //R
                20'hC31: color = RED;
                20'hC32: color = RED;
                20'hC33: color = BLACK;
                20'hC34: color = BLACK;
                20'hC35: color = RED;
                20'hC36: color = RED;
                20'hC37: color = BLACK;


                // ROW 5 ------------------------------------------------------------------------

                20'h1000: color = BLACK;     // F
                20'h1001: color = RED;
                20'h1002: color = RED;
                20'h1003: color = RED;
                20'h1004: color = RED;
                20'h1005: color = BLACK;
                20'h1006: color = BLACK;
                20'h1007: color = BLACK;

                20'h1008: color = BLACK;  // R
                20'h1009: color = RED;
                20'h100A: color = RED;
                20'h100B: color = RED;
                20'h100C: color = RED;
                20'h100D: color = RED;
                20'h100E: color = BLACK;
                20'h100F: color = BLACK;

                20'h1010: color = RED;  //O
                20'h1011: color = RED;
                20'h1012: color = BLACK;
                20'h1013: color = BLACK;
                20'h1014: color = BLACK;
                20'h1015: color = RED;
                20'h1016: color = RED;
                20'h1017: color = BLACK;

                20'h1018: color = RED;  //G
                20'h1019: color = RED;
                20'h101A: color = BLACK;  
                20'h101B: color = BLACK;
                20'h101C: color = BLACK;
                20'h101D: color = BLACK;
                20'h101E: color = BLACK;
                20'h101F: color = BLACK;

                20'h1020: color = RED;    //G
                20'h1021: color = RED;
                20'h1022: color = BLACK;
                20'h1023: color = BLACK;
                20'h1024: color = BLACK;
                20'h1025: color = BLACK;
                20'h1026: color = BLACK;
                20'h1027: color = BLACK;

                20'h1028: color = BLACK;    //E
                20'h1029: color = RED;
                20'h102A: color = RED;
                20'h102B: color = RED;
                20'h102C: color = RED;
                20'h102D: color = BLACK;
                20'h102E: color = BLACK;
                20'h102F: color = BLACK;

                20'h1030: color = BLACK;    //R
                20'h1031: color = RED;
                20'h1032: color = RED;
                20'h1033: color = RED;
                20'h1034: color = RED;
                20'h1035: color = RED;
                20'h1036: color = BLACK;
                20'h1037: color = BLACK;


                // ROW 6 ------------------------------------------------------------------------

                20'h1400: color = BLACK;  // F
                20'h1401: color = RED;
                20'h1402: color = RED;
                20'h1403: color = BLACK;
                20'h1404: color = RED;
                20'h1405: color = BLACK;
                20'h1406: color = BLACK;
                20'h1407: color = BLACK;

                20'h1408: color = BLACK;  // R
                20'h1409: color = RED;
                20'h140A: color = RED;
                20'h140B: color = BLACK;
                20'h140C: color = RED;
                20'h140D: color = RED;
                20'h140E: color = BLACK;
                20'h140F: color = BLACK;

                20'h1410: color = RED;  //O
                20'h1411: color = RED;
                20'h1412: color = BLACK;
                20'h1413: color = BLACK;
                20'h1414: color = BLACK;
                20'h1415: color = RED;
                20'h1416: color = RED;
                20'h1417: color = BLACK;

                20'h1418: color = RED;  //G
                20'h1419: color = RED;
                20'h141A: color = BLACK;  
                20'h141B: color = RED;
                20'h141C: color = RED;
                20'h141D: color = RED;
                20'h141E: color = RED;
                20'h141F: color = BLACK;

                20'h1420: color = RED;    //G
                20'h1421: color = RED;
                20'h1422: color = BLACK;
                20'h1423: color = RED;
                20'h1424: color = RED;
                20'h1425: color = RED;
                20'h1426: color = RED;
                20'h1427: color = BLACK;

                20'h1428: color = BLACK;    //E
                20'h1429: color = RED;
                20'h142A: color = RED;
                20'h142B: color = BLACK;
                20'h142C: color = RED;
                20'h142D: color = BLACK;
                20'h142E: color = BLACK;
                20'h142F: color = BLACK;

                20'h1430: color = BLACK;    //R
                20'h1431: color = RED;
                20'h1432: color = RED;
                20'h1433: color = BLACK;
                20'h1434: color = RED;
                20'h1435: color = RED;
                20'h1436: color = BLACK;
                20'h1437: color = BLACK;

                // ROW 7 ------------------------------------------------------------------------

                20'h1800: color = BLACK;     // F
                20'h1801: color = RED;
                20'h1802: color = RED;
                20'h1803: color = BLACK;
                20'h1804: color = BLACK;
                20'h1805: color = BLACK;
                20'h1806: color = BLACK;
                20'h1807: color = BLACK;

                20'h1808: color = BLACK;  // R
                20'h1809: color = RED;
                20'h180A: color = RED;
                20'h180B: color = BLACK;
                20'h180C: color = RED;
                20'h180D: color = RED;
                20'h180E: color = BLACK;
                20'h180F: color = BLACK;

                20'h1810: color = RED;  //O
                20'h1811: color = RED;
                20'h1812: color = BLACK;
                20'h1813: color = BLACK;
                20'h1814: color = BLACK;
                20'h1815: color = RED;
                20'h1816: color = RED;
                20'h1817: color = BLACK;

                20'h1818: color = RED;  //G
                20'h1819: color = RED;
                20'h181A: color = BLACK;  
                20'h181B: color = BLACK;
                20'h181C: color = BLACK;
                20'h181D: color = RED;
                20'h181E: color = RED;
                20'h181F: color = BLACK;

                20'h1820: color = RED;    //G
                20'h1821: color = RED;
                20'h1822: color = BLACK;
                20'h1823: color = BLACK;
                20'h1824: color = BLACK;
                20'h1825: color = RED;
                20'h1826: color = RED;
                20'h1827: color = BLACK;

                20'h1828: color = BLACK;    //E
                20'h1829: color = RED;
                20'h182A: color = RED;
                20'h182B: color = BLACK;
                20'h182C: color = BLACK;
                20'h182D: color = BLACK;
                20'h182E: color = BLACK;
                20'h182F: color = BLACK;

                20'h1830: color = BLACK;    //R
                20'h1831: color = RED;
                20'h1832: color = RED;
                20'h1833: color = BLACK;
                20'h1834: color = BLACK;
                20'h1835: color = RED;
                20'h1836: color = RED;
                20'h1837: color = BLACK;


                // ROW 8 ------------------------------------------------------------------------

                20'h1C00: color = BLACK;     // F
                20'h1C01: color = RED;
                20'h1C02: color = RED;
                20'h1C03: color = BLACK;
                20'h1C04: color = BLACK;
                20'h1C05: color = BLACK;
                20'h1C06: color = BLACK;
                20'h1C07: color = BLACK;

                20'h1C08: color = BLACK;  // R
                20'h1C09: color = RED;
                20'h1C0A: color = RED;
                20'h1C0B: color = BLACK;
                20'h1C0C: color = BLACK;
                20'h1C0D: color = RED;
                20'h1C0E: color = RED;
                20'h1C0F: color = BLACK;

                20'h1C10: color = RED;  //O
                20'h1C11: color = RED;
                20'h1C12: color = BLACK;
                20'h1C13: color = BLACK;
                20'h1C14: color = BLACK;
                20'h1C15: color = RED;
                20'h1C16: color = RED;
                20'h1C17: color = BLACK;

                20'h1C18: color = RED;  //G
                20'h1C19: color = RED;
                20'h1C1A: color = BLACK;  
                20'h1C1B: color = BLACK;
                20'h1C1C: color = BLACK;
                20'h1C1D: color = RED;
                20'h1C1E: color = RED;
                20'h1C1F: color = BLACK;

                20'h1C20: color = RED;    //G
                20'h1C21: color = RED;
                20'h1C22: color = BLACK;
                20'h1C23: color = BLACK;
                20'h1C24: color = BLACK;
                20'h1C25: color = RED;
                20'h1C26: color = RED;
                20'h1C27: color = BLACK;

                20'h1C28: color = BLACK;    //E
                20'h1C29: color = RED;
                20'h1C2A: color = RED;
                20'h1C2B: color = BLACK;
                20'h1C2C: color = BLACK;
                20'h1C2D: color = BLACK;
                20'h1C2E: color = RED;
                20'h1C2F: color = BLACK;

                20'h1C30: color = BLACK;    //R
                20'h1C31: color = RED;
                20'h1C32: color = RED;
                20'h1C33: color = BLACK;
                20'h1C34: color = BLACK;
                20'h1C35: color = RED;
                20'h1C36: color = RED;
                20'h1C37: color = BLACK;


                // ROW 9 ------------------------------------------------------------------------

                20'h2000: color = BLACK;     // F
                20'h2001: color = RED;
                20'h2002: color = RED;
                20'h2003: color = BLACK;
                20'h2004: color = BLACK;
                20'h2005: color = BLACK;
                20'h2006: color = BLACK;
                20'h2007: color = BLACK;

                20'h2008: color = BLACK;  // R
                20'h2009: color = RED;
                20'h200A: color = RED;
                20'h200B: color = BLACK;
                20'h200C: color = BLACK;
                20'h200D: color = RED;
                20'h200E: color = RED;
                20'h200F: color = BLACK;

                20'h2010: color = RED;  //O
                20'h2011: color = RED;
                20'h2012: color = BLACK;
                20'h2013: color = BLACK;
                20'h2014: color = BLACK;
                20'h2015: color = RED;
                20'h2016: color = RED;
                20'h2017: color = BLACK;

                20'h2018: color = BLACK;  //G
                20'h2019: color = RED;
                20'h201A: color = RED;  
                20'h201B: color = BLACK;
                20'h201C: color = BLACK;
                20'h201D: color = RED;
                20'h201E: color = RED;
                20'h201F: color = BLACK;

                20'h2020: color = BLACK;    //G
                20'h2021: color = RED;
                20'h2022: color = RED;
                20'h2023: color = BLACK;
                20'h2024: color = BLACK;
                20'h2025: color = RED;
                20'h2026: color = RED;
                20'h2027: color = BLACK;

                20'h2028: color = BLACK;    //E
                20'h2029: color = RED;
                20'h202A: color = RED;
                20'h202B: color = BLACK;
                20'h202C: color = BLACK;
                20'h202D: color = RED;
                20'h202E: color = RED;
                20'h202F: color = BLACK;

                20'h2030: color = BLACK;    //R
                20'h2031: color = RED;
                20'h2032: color = RED;
                20'h2033: color = BLACK;
                20'h2034: color = BLACK;
                20'h2035: color = RED;
                20'h2036: color = RED;
                20'h2037: color = BLACK;


                // ROW 10 ------------------------------------------------------------------------

                20'h2400: color = RED;     // F
                20'h2401: color = RED;
                20'h2402: color = RED;
                20'h2403: color = RED;
                20'h2404: color = BLACK;
                20'h2405: color = BLACK;
                20'h2406: color = BLACK;
                20'h2407: color = BLACK;

                20'h2408: color = RED;  // R
                20'h2409: color = RED;
                20'h240A: color = RED;
                20'h240B: color = BLACK;
                20'h240C: color = BLACK;
                20'h240D: color = RED;
                20'h240E: color = RED;
                20'h240F: color = BLACK;

                20'h2410: color = BLACK;  //O
                20'h2411: color = RED;
                20'h2412: color = RED;
                20'h2413: color = RED;
                20'h2414: color = RED;
                20'h2415: color = RED;
                20'h2416: color = BLACK;
                20'h2417: color = BLACK;

                20'h2418: color = BLACK;  //G
                20'h2419: color = RED;
                20'h241A: color = RED;  
                20'h241B: color = RED;
                20'h241C: color = RED;
                20'h241D: color = RED;
                20'h241E: color = BLACK;
                20'h241F: color = BLACK;

                20'h2420: color = BLACK;    //G
                20'h2421: color = RED;
                20'h2422: color = RED;
                20'h2423: color = RED;
                20'h2424: color = RED;
                20'h2425: color = RED;
                20'h2426: color = BLACK;
                20'h2427: color = BLACK;

                20'h2428: color = RED;    //E
                20'h2429: color = RED;
                20'h242A: color = RED;
                20'h242B: color = RED;
                20'h242C: color = RED;
                20'h242D: color = RED;
                20'h242E: color = RED;
                20'h242F: color = BLACK;

                20'h2430: color = RED;    //R
                20'h2431: color = RED;
                20'h2432: color = RED;
                20'h2433: color = BLACK;
                20'h2434: color = BLACK;
                20'h2435: color = RED;
                20'h2436: color = RED;
                20'h2437: color = BLACK;


                default: color = BLACK;
            endcase
        end else if (display_title &&
            colPos >= X_SUBTITLE_OFFSET && colPos < X_SUBTITLE_OFFSET + SUBTITLE_WIDTH &&
            rowPos >= Y_SUBTITLE_OFFSET && rowPos < Y_SUBTITLE_OFFSET + SUBTITLE_HEIGHT) begin
            if (charRowData[charPixColData] == 1'b1) begin
                color = RED;
            end else begin
                color = BLACK;
            end
        end else begin
            color = BLACK;
        end
    end

endmodule